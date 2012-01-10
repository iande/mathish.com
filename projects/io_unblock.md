---
layout: project
title: io_unblock
date: 2012-01-09
source_url: https://github.com/iande/io_unblock
related_tags:
  - io_unblock
  - onstomp
---

### Summary

A small library that allows IO objects to be wrapped in the warmth of
non-blocking goodness while being lovingly processed by its very own
thread. As it bytes are read and written, callbacks are invoked.
Glorious.

### Motivation

This gem's primary purpose is to handle threaded non-blocking IO so
that the OnStomp gem is less distracted from its primary duty of
handling the STOMP protocol.

### Installing

At this time, don't.
