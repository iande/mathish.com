---
layout: post
title: Events on a Train, Seeking a Ruby 1.9 World
short_title: OnStomp Event Thread
tags: onstomp rubygems ruby stomp
---
So, true to my nature of nothing ever being quite "good enough" I'm already
looking to add new features to [OnStomp](http://mdvlrb.com/onstomp/) as well
as making plans for what version 2.0 will look like.

### Events on a separate loop

First, the new features, which is to say a new **feature**.  One thing that's
[been bothering me](https://github.com/meadvillerb/onstomp/issues/8) is that
most events are dispatched from the IO thread of an `OnStomp::Client`
instance.  This means that long-running (or a long chain of short
running) event handlers, once triggered, will have to finish running before
further IO processing can occur.  Another issue is that if an exception is
raised in any of these callbacks, it will generally close the connection.  In
either case, IO can be negatively impacted by the programming approach the
gem tries to encourage.

A second issue, slightly more subtle but just as significant, is that
not all events are triggered in the same thread. The events that get
triggered outside the IO processing thread are `before_transmitting` and
`before_<frame>`.  Let's jump into an example:

{% highlight ruby %}
main_thread = Thread.current

client = OnStomp.connect "stomp://localhost"

client.before_transmitting do |f, *_|
  # Thread.current == main_thread
end

client.before_send do |send_frame, *_|
  # Thread.current == main_thread
end

client.on_send do |send_frame, *_|
  # Thread.current != main_thread
end

client.after_transmitting do |f, *_|
  # Thread.current != main_thread
  # The current thread is the same here as in 'on_send'
end

client.send "/queue/test", "Hello World!"

{% endhighlight %}

Now, `before_transmitting` and `before_send` will be invoked (in that order)
before the actual `SEND` frame is sent off to a dark and mysterious buffer
where the IO processor will eventually get around to writing it to the
socket. This means, you don't have to worry about mutex locking and whatnot
between these two groups of events.  However, it still displeases me, as event
handling will be split across two distinct threads.

So, to solve these issues I'm probably going to drop in a second thread.
There are a few issues that need careful consideration.  I'll need to ensure
that all `before_*` events are triggered before a client-generated frame
gets sent to the IO write buffer.  Also, it would be nice if all events
triggered within the failover extension used the same thread as well by
sharing an event dispatcher amongst all of the clients in the pool.  This
will keep the overall thread count down, and resolve some of its finer quirks
that appear to be the result of events being triggered in a particular
client's IO processing thread.

In short, I'll follow the lead of
[Arthur "Two Sheds" Jackson](http://www.youtube.com/watch?v=HLjS3gzHetA).

### Welcome to the world of tomorrow!

I'm eagerly awaiting the day when JRuby has full Ruby 1.9.2 support,
including non-blocking IO for OpenSSL connections.  On that day, OnStomp 2.0
will hit the shelves, and it will require Ruby 1.9+.  I have no intention
of totally abandoning Ruby 1.8.7, and the OnStomp 1.0 branch will always
support Ruby 1.8.7.  That said, I am still looking forward to dropping all of
the conditional code and strange shit like:

{% highlight ruby %}
ENUMERATOR_KLASS = (RUBY_VERSION >= '1.9') ? Enumerator : Enumerable::Enumerator
{% endhighlight %}

It might even provide an opportunity to make use of `Fiber`s.  It's going to
be pretty sweet.

Next time, I'm getting off at Willoughby.
