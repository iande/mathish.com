---
layout: post
title: mathlib Found
tags: mathlib java fractals complex math
sitemap_priority: 0.5
---
Roughly 5-6 years ago, I made an effort to take Fractal rendering code I
developed during college and refactor it into a general purpose Java library,
[mathlib.jar](https://github.com/iande/mathlib).  A hard drive failure and
desktop replacement later, and I had assumed that code was lost.  In fact,
I seem to recall a fight between my former wife and I over the matter, but at
any rate, it appears I was wrong.

I doubt this code is of much utility to anyone, even I probably won't get
much direct use out of it as I don't do much with Java anymore.  However,
there were some novel bits in there, and implementations of a number of
non-trivial functions extended to
{% m %}f : \mathbb{C} \rightarrow \mathbb{C}{% em %}.  At the very least, it will
probably help with my work on implementing a Mandelbrot renderer in HTML5
using `<canvas>` and `WebWorker`s.
  