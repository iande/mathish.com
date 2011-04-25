---
layout: post
title: Mandelbrot Sets in Javascript
---
I'm a big fan of fractals.  From
[Lindenmayer Systems](http://en.wikipedia.org/wiki/L-system) to variations on
the [Mandelbrot set](http://en.wikipedia.org/wiki/Mandelbrot_set), they all
have a special place in a statistically self-similar region of my brain.
Archimedes can keep his circles, I'll stick with the striking complexity of
chaos.  Given this mild obsession, it should not come as surprise that one of
the first applications I enjoy making when working with a new GUI environment
is a fractal generator.  With the addition of Web Workers and programmatic
drawing via `<canvas>` elements in modern JS implementations, I find the past
repeating itself with affine self-similarity.

I am currently writing the rendering code, relying on
[jQuery](http://jquery.com) and the aforementioned recent javascript
additions.  For those that do not share in my fractal-eroticism, what I
produce can still be useful as an example of using Web Workers for
semi-concurrent javascript code execution.
