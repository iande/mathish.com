---
layout: post
title: On Functional Complexity - Part 2
short_title: Functional Complexity 2
series: Functional Complexity Modulo a Test Suite
tags: complexity theory
published: false
---
This is the second part in a series of articles I am writing on
"[Functional Complexity Modulo a Test Suite](https://github.com/raganwald/homoiconic/blob/master/2009-06-02/functional_complexity.md)."
If you have not yet read [part 1](http://mathish.com/2011/05/08/mother-functional.html)
you may want to do so in case I reference bits from it in this article.

Before we begin though, let's take a moment to have some coffee and enjoy a
picture of "[The Dude](http://www.reddit.com/r/fffffffuuuuuuuuuuuu/comments/h84cp/i_made_a_new_trace_out_of_the_dude_hope_hed_abide/)."

<figure class="display-mode" id="figure-the-dude">
  <img src="/images/the_dude.png"
    alt="The Dude abides" />
  <figcaption>El Duderino if you're not into the whole brevity thing.</figcaption>
</figure>

Things to cover:

* Randomness / Obtuseness
* Dynamic Test Suites
  * Covering Additional Cases
  * Removing Unnecessary Cases
  * Changes in Requirements
* Dependency between Test Suite and Program
