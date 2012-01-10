---
layout: post
title: Stomper 2.1.maybe?
tags: stomper ruby stomp
---
After a significant re-tooling of Stomper's IO handling, I've got something
that seems very fast and very stable, using non-blocking IO.

I'm debating how I want to approach this, though.  The changes are
significant enough to warrant incrementing the minor number, potentially even
the major number, rather than just the bugfix/patch number.  However, there's
also a python library named stomper, so we'll see what happens as I revise
tests and verify that everything that should work does.

Some preliminary tests suggest I can relay 5,000 frames each with a 1kb body
in about 10 seconds, which pleases me.

So, I'm definitely leaning toward a rename, going from Stomper to OnStomp.
