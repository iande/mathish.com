---
layout: post
title: "Properties of Code: Readability"
short_title: Properties of Code - Part 2
tags:
  - properties of code
  - readability
  - thoughts
  - code
published: false
---
This is the second post in a series I am writing in response to
"[Functional Complexity Modulo a Test Suite](https://github.com/raganwald/homoiconic/blob/master/2009-06-02/functional_complexity.md)."
If you have not yet read [part 1](http://mathish.com/2011/05/08/mother-functional.html)
you may want to do so in case I reference bits from it in this article.
While this series has its roots in Braithwaite's original article, its
branches may stretch into very different spaces.  See what I did there? The
series is a tree, each post is a branch, and each section over-extends the
metaphor.

Before we go any further, let's take a moment to have some coffee and enjoy a
picture of "[The Dude](http://www.reddit.com/r/fffffffuuuuuuuuuuuu/comments/h84cp/i_made_a_new_trace_out_of_the_dude_hope_hed_abide/)."

<figure class="display-mode" id="figure-the-dude">
  <img src="/images/the_dude.png"
    alt="The Dude abides" />
  <figcaption>El Duderino if you're not into the whole brevity thing.</figcaption>
</figure>

We could also take an additional moment to [thank the fine redditor](http://www.reddit.com/r/fffffffuuuuuuuuuuuu/comments/h84cp/i_made_a_new_trace_out_of_the_dude_hope_hed_abide/),
selusa, who created this image, but I'll leave that as an exercise for the
reader.
While we're on the topic of redditors and readers, let's talk about reading.
More specifically, let's talk about the quality of written code that makes
it easier (or harder) to understand: readability.

### Compressing Strings

Consider the following two strings.  In both instances, I have taken a
"source string," chosen a particular character contained within the string,
and then removed all occurrences of that character.  The first string is
the remains of a sentence:

    Mntremes, such as platypuses and echidnas, are lng-lived, egg laying
     mammals with lw metablic rates.

The second is a seemingly arbitrary string of characters:

    AAAAB3NzaC1yc2EAAAABIwAAAQEAv+ZzGOKzf0kaSMEZ5K3IEt2gE22usDzBgS7nE2rFO0nv
    +BJnvF2vXSUsBkqJb9YjyrRrfDiXMQGA2CVSz4/RCKMyrnZn9xQw4V8KbWJOIQ217YswCfNO
    wFS7SlvrY7vKXGcRQDW8mFQ1gwKO+TOZzIb2rMtEJkF17tVIPle4cuqJsLrye5PcWv1z4hbw
    3xp/+Xg4zgMe9bB3j2M5mPNJRFz81qSwBEuptf4MR0DFBaOqDFBikiIRO7ua5YNbwtdsIyuh
    LDXVcVJRpE2NAEh+r7GzwbLx/XxL52qSjnJeqYKPfKp3t59pHJMgld+R+KZSIf8ytE7pWf36
    FnQ==
  
We know how the strings were produced, we see the results, but can we infer
the "source strings" used in their derivation?

Let's consider the first string.  Even if we were unfamiliar with the word
"monotremes", we can see that at least one vowel is missing from "Mntremes",
further the strings "lng-lived," "lw," and "metablic" give us enough clues to
deduce that the letter "o" is missing. We could probably reconstruct the
original string based upon our prior knowledge of English word formation and
our own vocabulary.  We may arrive at "Montreme" instead of "Monotreme," but
a bit of googling would correct our mistake.

What about the second string?  Can we even infer what character has been
omitted?  In general, probably not, but in this particular case, we could
make an educated guess.  Obviously I am trying to make some point about
string compression (the section title says so.)  I have chosen two examples,
one a sentence, the other a set of arbitrary characters, so that the two
would strongly contrast one another.  What character could I omit from
the second string to really drive this contrast home?
Perhaps the same "o" character I removed from the first?  And if you reasoned
similarly, you would be correct.  However, where in the hell do we put the
"o" characters to reproduce the original?

The first string was derived from a sentence about [monotremes](http://en.wikipedia.org/wiki/Monotreme)
&mdash; which in turn was derived from the linked Wikipedia article:

    Monotremes, such as platypuses and echidnas, are long-lived, egg laying
     mammals with low metabolic rates.

The second string still looks like gibberish &mdash; it isn't, but I don't
want to reveal what it is just yet:

    AAAAB3NzaC1yc2EAAAABIwAAAQEAv+ZzGOKzf0kaSMEZ5K3IEt2gE22usDzBgS7nE2rFO0nv
    +BJnvF2vXSUsBkqJb9oYjyroRrfDiXMoQGA2CVSz4/RCKMyrnZn9xQw4V8KobWJOIQ217Ysw
    CfNOwFS7SlvrY7vKXGcRQDW8mFQoo1gwKO+TOZzIb2rMtEJkF17tVIPle4cuqJsLrye5PcWv
    1z4hbw3xp/+Xg4zgMe9bB3j2M5mPNJRFz81qSwBEuptf4MR0DFBaOqDFBikiIRO7ua5YNbwt
    dsIyuhLDXVcVJRpE2NAEh+r7oGzwbLx/XxL52qSjnJeqYKPfKp3t59pHJMgld+R+KZSIf8yt
    E7pWf36FnQ==

By omitting the occurrences of the "o" character, we reduce the first string
by 5 characters (or 4.76%), the second is reduced by 7 characters (but
only 1.88%.)  We might be tempted to draw a conclusion from this: perhaps
there is a relationship between this reduction and the overall readability of
the compressed string.  However, suppose we had chosen to omit the spaces
from the first string.  We would end up with:

    Monotremes,suchasplatypusesandechidnas,arelong-lived,egglayingmammalswit
    hlowmetabolicrates.

We get a reduction of 14 characters (13.33% of the total length) so that's
something, but I personally have an easier time reconstructing the first
instance than this one.  However, consider this formulation:

    Monotremes are mammals: live long, lay eggs, have slow metabolisms.

This string has 38 fewer characters and the only "information" we lose are
the two examples of monotremes: platypuses and echidnas.  However, I can think
of no meaningful reductions to perform on the "gibberish string" that preserve
its information (or at least the bulk of it) save the one I just now
performed &mdash; naming it.  I am now free to say "gibberish string" and
within the context of this post (and perhaps other contexts as well) we both
know I am referring to this mess:

    AAAAB3NzaC1yc2EAAAABIwAAAQEAv+ZzGOKzf0kaSMEZ5K3IEt2gE22usDzBgS7nE2rFO0nv
    +BJnvF2vXSUsBkqJb9oYjyroRrfDiXMoQGA2CVSz4/RCKMyrnZn9xQw4V8KobWJOIQ217Ysw
    CfNOwFS7SlvrY7vKXGcRQDW8mFQoo1gwKO+TOZzIb2rMtEJkF17tVIPle4cuqJsLrye5PcWv
    1z4hbw3xp/+Xg4zgMe9bB3j2M5mPNJRFz81qSwBEuptf4MR0DFBaOqDFBikiIRO7ua5YNbwt
    dsIyuhLDXVcVJRpE2NAEh+r7oGzwbLx/XxL52qSjnJeqYKPfKp3t59pHJMgld+R+KZSIf8yt
    E7pWf36FnQ==
    
By giving this string the name "gibberish string," we have reduced it by
356 characters (or 97.70%, if you prefer relative measures.)  That's some
pretty sweet compression!  This technique isn't new and it isn't novel, we
do it all the time: "Elizabeth" becomes "she" and "armoire" becomes "it."  In
mathematics we reduce the infinite set of digits "3.141592653589..." to the
single character symbol {% m %}\pi{% em %}.  Naming is the origin of all
particular things.

And speaking of names, "gibberish string" has another name: "one of my public
SSH keys", or as I call it, "ian@godel.pub" &mdash; "gödel" being the name of my
laptop, transformed to "godel" because I don't like to taunt alternative
character encodings.

And speaking of things that are mine, this post is going to get pretty
subjective for a bit.

### Comparing Kolmogorov Complexity and Readability

Kolmogorov complexity is a useful measurement, if for no other reason than it
provides a definition of randomness that is free from the philosophical
concerns that generally come with the term.  However, I do not believe it is
well suited to help us measure readability.  At issue is Kolmogorov's reliance
on counting characters and its requirement that all functions called within a
function also be included when counting characters.

I derive great utility from "ian@godel.pub" as well as {% m %}e{% em %},
{% m %}\phi{% em %} and {% m %}\pi{% em %}.  In my tiny brain I can associate
properties &mdash; or more generally: informatin &mdash; with these names.
My public SSH key grants me access to various git repositories and servers;
{% m %}\pi{% em %} is the relationship between circle's circumference and its
diameter; the "golden ratio," {% m %}\phi{% em %}, has the property that its
multiplicative inverse is itself minus 1:

{% math %}
  \frac{1}{\phi} = \phi - 1
{% endmath %}

Each of these entities may have be incompressible in terms of their
Kolmogorov complexity, but when referenced by name, the complexity of the
strings has no bearing on readability.  With that in mind, let's revisit
a few examples from the previous article.

{% highlight ruby %}
p4 = lambda do |k|
  (1..k).inject(&:+)
end

p5 = lambda do |k|
  (1..k).sum
end

p6 = lambda do |k|
  k * (k + 1) / 2
end
{% endhighlight %}

These three programs had the following lengths:

{% math %}
\begin{aligned}
  |p_4| & = 36 \\
  |p_5| & = 140 \\
  |p_6| & = 33
\end{aligned}
{% endmath %}

The program {% m %}p_5{% em %} initially weighed in at 28 characters, but
we tacked on the length of the `sum` method and arrived at 140 characters.
But was anything of value achieved in doing so?  As the `inject` method is
made available through Ruby's standard library and not part of the core
language itself, shouldn't we have penalized {% m %}p_4{% em %} as well?
Incidentally, doing so would also penalize {% m %}p_5{% em %} further as it
internally relies on `inject`.  My personal feeling on the matter is that
we should not penalize either program at all.  After all, I typically use
a library for its abstractions.  The good ones free me from worrying about
the incidental details so the internals of my functions more closely resemble
their names.  Consider the following iterations of Ruby code:

{% highlight ruby %}
def count_divs url
  path = (url.path.nil? || url.path.empty?) ? '/' : url.path
  sock = TCPSocket.new url.host, (url.port||80)
  sock.write "GET #{path} HTTP/1.0\r\n\r\n"
  body = sock.read
  sock.close
  body.scan(/<div[^>]*>/).size
end
{% endhighlight %}

Clearly, `count_divs` is doing more than just counting `<div>` tags, so let's
fix that:

{% highlight ruby %}
def count_divs url
  read_body(url.host, url.port, url.path).scan(/<div[^>]*>/).size
end

def read_body host, port, path
  path = (path.nil? || path.empty?) ? '/' : path
  sock = TCPSocket.new host, (port||80)
  sock.write "GET #{path} HTTP/1.0\r\n\r\n"
  sock.read.tap { sock.close }
end
{% endhighlight %}

Getting better, but for `count_divs` to work, `read_body` must actually return
the HTML content referenced by the given URL, and to do that it needs to know
something about how to request the content from an HTTP server.  In fact,
we're blindly scanning everything returned by the server, including the
response headers.  So, let's release ourselves from the HTTP protocol by
turning to `open-uri`:

{% highlight ruby %}
require 'open-uri'

def count_divs url
  read_body(url).scan(/<div[^>]*>/).size
end

def read_body url
  open(url) { |f| f.read }
end
{% endhighlight %}

For this simple example, we really don't need the `read_body` method anymore,
but if we wanted to count other tags, it might be handy to keep around.  So,
what point am I trying to make with this mind-numbing exercise?
