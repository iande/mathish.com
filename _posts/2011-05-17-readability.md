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
*Important Note*: What you see here is essentially a rough outline.  I have
been mulling over these thoughts for a few days and made more than one attempt
at writing this post.  I am "publishing" this outline in an attempt to force
myself to work through this train of thought instead of scrapping it and
starting over again from scratch.  And this is why you should **not** post
rough outlines.  You're wrong, in a sense, but it's because of the fact that
Kolmogorov is kind of useless in practice.  As you covered in the previous
post, if you take Ruby as the base language, then `.sum` carries the additional
weight of the its definition in ActiveSupport.  However, it's all pretty
arbitrary.  Why not use 'Ruby + ActiveSupport + OtherCoolGem' as your base
language, then `(1..k).sum` is pretty terse.  If you put up a fight over
including supporting libraries in the base language, then I could make the
claim that you should be stuck purely with the keywords and grammar of the
base language, which means you don't get shit like `Array#inject` for free
either, so make sure to include the weight of that method in `sum` as well
as the program that uses `inject` (and don't forget every other method of
every class and module found in Ruby's core lib.)  Once you allow this
extension, you head towards {% m %}e{% em %}, {% m %}\pi{% em %}, and
{% m %}\phi{% em %}.  You can express particular convoluted strings with
a few characters (the name of a function,) provided there is some mutual
knowledge between you and the reader.  Use the sentence about monotremes and
your public SSH key to illustrate the progression from raw strings to
human compressibility/expansion, and then to naming (the origin of all things.)

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
it easier (or harder) to understand: readability.  We're going to start off
with a bold position and then slowly retreat from it.

<p class="bold-unfounded-claim">There is no link between functional complexity and readability.</p>

This claim may not be precisely true, but let's indulge it and see where the
thought takes us.

### At First Glance

Use test suite and program from part 1 to illustrate that there might
be some relationship.

### Enter the Befuddled

Add a bunch of no-op stuff to one of the programs to show that increasing
the size can confuse the matter.

### Enter the Jerk

Pull out some "clever" code to solve the problem that's particularly
obfuscated.  Maybe an `eval`!

### Weep Not, Gentle Functional Complexity

Show that other measures of complexity suck here, too.  Kolmogorov should be
a straight-forward matter, include cyclomatic complexity and flog.  They may
take a bit more work, but not much.  Drive home this point: all of these
measurements are relevant only to machines.  Kolmogorov measures
compressibility (or randomness) of a string, cyclomatic complexity measures
branching, and flog measures (roughly) the work a function must do.

For code that's not written by the befuddled, the rushed or the jerks, these
measurements may provide some insights into the mental machinery required to
comprehend the code, but readability is still something more.

### The Readability of the Written Word

* Is the audience already familiar with the topic? Does the work assume
  too much familiarity?  Does it assume too little?
* Does the vocabulary used match that of the audience?
* If humor is used, does the topic warrant the levity?
  Does the audience appreciate the joke?
* Is the work long enough to cover the subject but short
  enough to remain interesting?  Does it seem to get lost en route to
  its destination?  Does it meander down seemingly unrelated paths while
  posing silly rhetorical questions?
* Can we enumerate all of the properties that make piece of writing
  "readable," weight them and objectively measure the readability of a
  book, essay or poem?
  
No!  Of the quantities at hand, we may only have rough measurements; meanwhile,
the quantities unknown completely elude our rulers and calipers.  The same
is true of programs and programming languages, and perhaps made worse by
their own restrictions.

### We're Talking to Machines First, People Second

### Programming as Information Design

Start with [Magic Ink](http://worrydream.com/MagicInk/) and take it one
step further: the source code of a program is, itself, a piece of
"information software."
