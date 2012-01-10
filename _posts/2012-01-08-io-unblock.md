---
layout: post
title: Refactoring OnStomp
tags: code onstomp rubygems ruby stomp io_unblock
---
Lately, I've been giving some thought to a few issues with
the [OnStomp](https://github.com/meadvillerb/onstomp) gem and how I want
to address them. I'll start by over-explaining the issues, and then
wrap up with how I plan to address them.

### Handling IO Exceptions

In the base connection class, there's a fair bit of exception rescuing
going on, but there is a problem with it. For example, let's have a
look at `connections/base.rb`
[starting at line 209](https://github.com/meadvillerb/onstomp/blob/master/lib/onstomp/connections/base.rb#L209)

{% highlight ruby %}
begin
  if data = read_nonblock
    @read_buffer << data
    @last_received_at = Time.now
    serializer.bytes_to_frame(@read_buffer) do |frame|
      yield frame if block_given?
      client.dispatch_received frame
    end
  end
rescue Errno::EINTR, Errno::EAGAIN, Errno::EWOULDBLOCK
  # do not
rescue EOFError
  triggered_close $!.message
rescue Exception
  # TODO: [omitted for now]
  triggered_close $!.message, :terminated
  raise
end
{% endhighlight %}

The first `rescue` handles exceptions that can be raised when reading
data would cause the system to block. We handle this situation by doing
nothing and waiting until later to try reading again. The second 
exception we address is an `EOFError`, which isn't necessarily
an error. For example, if the client has told the server it is all done
and intends to disconnect, the server may shutdown the connection which
can cause this exception to be raised. Even when an EOFError is
unexpected, it always tells us that it's time to shutdown the connection
and move on.

This brings us to the final `rescue` block, which handles every other
kind of exception. The system responds by shutting down the connection,
firing a `terminated` event, and then re-raising the exception. I chose
to re-raise the exception to give additional feedback to developers,
which might have been handy if it weren't for the fact that the
exception is being raised within a separate IO processing thread.
Thus, the exception can only be rescued when the thread is joined, which
doesn't happen until the developer has called `disconnect` on the
`OnStomp::Client` object. By that time, it is far too late to handle
the error in any meaningful way.

So, it's pretty obvious that re-raising exceptions in this fashion is
useless, now I want to show you why it's also problematic. Suppose that
we've got this bit of code:

{% highlight ruby %}
# Pull messages from a file, database, etc.
messages = get_messages_from_persistent_storage

client.transaction do |t|
  messages.each do |msg|
    t.send msg.destination, msg.body
    # Delete the message from file, database, etc
    remove_message_from_persistent_storage m
  end
end

client.disconnect
{% endhighlight %}

If an `Errno::ECONNRESET` exception is raised before all of the
messages have been sent, the developer won't know it until 
`client.disconnect` has been called. Now, from the server's perspective
everything behaves as expected: the transaction starts with a `BEGIN`
frame, some messages are received, and the connection is closed before
a `COMMIT` frame is received, so the received messages are discarded.
The developer, on the other hand, gets screwed: the exception is raised
in a separate thread from where the `transaction` block is evaluated.
All of the messages have been deleted from the persistent storage and
not one of them has actually been accepted by the server, which is a
dick move on my part.  Now, to be fair, I never intended the
`transaction` block to work in this way. The intent of `transaction`
was to deal with exceptions generated within the block itself and
either commit or abort the transaction automatically. In other words, if
`remove_message_from_persistent_storage` raised an exception, the
`transaction` block would be there to rescue it, send an `ABORT` frame
to the server, and then halt any further transaction processing. My
original intentions aside, it sure would be nice if the developer had
an easy way to verify that the transaction had been committed before 
deleting those persisted messages. This is the crux of
[a comment by celesteking](https://github.com/meadvillerb/onstomp/issues/13#issuecomment-3251571),
and I think it's a pretty good idea.

We could handle this issue with something like the following:

{% highlight ruby %}
client.on_commit do |commit_frame, *args|
  # Delete all messages from file, database, etc
  remove_all_messages_from_persistent_storage
end

# Pull messages from a file, database, etc.
messages = get_messages_from_persistent_storage

client.transaction do |t|
  messages.each do |msg|
    t.send msg.destination, msg.body
  end
end

client.disconnect
{% endhighlight %}

However, this only works if we're performing a single transaction. If
we have multiple transactions, then we need to keep track of transaction
IDs and our `on_commit` call turns into a giant `case` statement.
Clearly this is a less than desirable solution.

A better approach might take the following form:

{% highlight ruby %}
# Pull messages from a file, database, etc.
messages = get_messages_from_persistent_storage

client.transaction do |t|
  t.on_abort do
    # Called when the transaction is explicitly aborted or an IO
    # exception prevents sending the final COMMIT frame.
  end
  t.on_commit do
    remove_all_messages_from_persistent_storage
  end

  messages.each do |msg|
    t.send msg.destination, msg.body
  end
end

client.disconnect
{% endhighlight %}

I suppose these blocks could also be supplied as parameters to
the `transaction` method (note: I'm using a Ruby 1.9 style hash)

{% highlight ruby %}
client.transaction(on_abort: lambda { ... },
                   on_commit: lambda { ... }) do |t|
  # ...
end
{% endhighlight %}

Personally, I prefer the former over the latter, but it requires a bit
more effort to implement if I want to guarantee that any `on_abort`
callback will be called even if it is defined after a the `ABORT` frame
has already been generated (or if an IO exception has occurred while
processing the transaction.)

Hopefully this illustrates why triggering a `terminated` event on the
connection and re-raising the exception is both a useless and
inadequate way of handling errors, and why something better is needed.

### Event Dispatching

The second serious issue is
[one I've touched on before](/2011/04/24/events-on-a-train.html):
there are some major issues with how event callbacks are invoked.

1. Not all event callbacks will be invoked in the same thread, so your
   callbacks may run into synchronization issues.
2. Unless you spend a fair amount of time with the code base, you'll
   probably have no idea which thread an event is going to be invoked
   within.
3. Changing the client's state in a callback (e.g. re-connecting
   within the `on_connection_terminated` event) can produce
   [errors that are spectacularly difficult to trace](https://github.com/meadvillerb/onstomp/issues/12).
4. IO processing stops until the callbacks are completed. A
   long-running callback could very easily choke the connection.
5. If an exception is raised within a callback it may
   percolate up to the threaded processor, which will kill the IO loop
   and ruin everyone's day.

I don't think I really need to explain this problem further, so let's
move on to the last issue.

### The Code Base

There is a whole lot of code within OnStomp that has *nothing* to do
with the actual Stomp protocol, which makes it difficult to figure out
exactly what OnStomp is doing. Also, some of the library's packaging
makes no sense to me now -- fortunately, that's mostly my problem and
not something anyone else should have to worry about.

### Fixing It

I've begun work on the proper fixes for these problems. The first step
will be factoring out all the non-blocking IO stuff into a separate
gem: [io_unblock](https://github.com/iande/io_unblock). Rather than
a connection that dispatches events, this will be working with
lambdas, procs or blocks that are always invoked from within
the IO processor thread. Within OnStomp, these callbacks will not be
available to developers, instead they will be used to enqueue events
that an event dispatcher will invoke later. I don't know if a callback
invoking, threaded IO-ish object will be of use to anyone else, but
as it will in no way be tied to the OnStomp gem or the Stomp protocol,
I see no harm in releasing it on its own.

I'm toying with the idea of putting all of the event dispatching code
into a separate gem, as well. However, I won't know if this is
warranted until I actually start mucking about with it. In any case,
I do plan on running the dispatcher within yet another thread to
resolve the issues surrounding the current event dispatch process.

There are a couple of things I need to keep in mind while making these
changes. First, being able to safely reconnect within a
`on_connection_closed` event callback should not be the exercise in
coding gymnastics that it is right now. Second, I need to preserve
the ability developers have to use the `before_transmitting` or
`before_<frame command>` events to change frames before they are
serialized and sent on to the broker. Right now this is trivial because
the client triggers those events and after the callbacks complete, it
passes the frame off to the connection. If event dispatching is
handled within a separate thread, some care must be taken to ensure
that the dispatcher has triggered those events before the frames are
serialized.

I think that's enough for now, I'll post more when I start making some
actual headway.
