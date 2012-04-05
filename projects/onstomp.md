---
layout: project
title: OnStomp
date: 2012-01-09
version: 1.0.5
license_url: http://mdvlrb.com/onstomp/file.LICENSE.html
download_url: https://rubygems.org/gems/onstomp
source_url: https://github.com/meadvillerb/onstomp
docs_url: http://mathish.com/projects/onstomp/doc/
changes_url: http://mdvlrb.com/onstomp/file.CHANGELOG.html
related_tags:
  - onstomp
---

### Summary

A client-side ruby gem for communicating with message brokers that support
the [STOMP](http://stomp.github.com/) 1.0 and 1.1 protocols. This gem was formerly known as `stomper`,
but that name has been dropped because a
[python stomp library](http://code.google.com/p/stomper/) by the same name
already existed. Also, I think "OnStomp" better expresses the event-driven
nature of this gem.

### Motivation

There is a STOMP client gem named [stomp](http://gitorious.org/stomp), so why
create another gem?  OnStomp was designed around giving  users more control
over how STOMP frames are handled through an event-driven interface. All
IO reading and writing is performed through the use of non-blocking methods
in the hopes of increasing performance.

The `stomp` gem is a good gem that works well, I just desired a different
style API for working with message brokers.

### Installing

The OnStomp gem can be installed as a standard ruby gem:

    gem install onstomp
    
Alternatively, you can clone the
[source](https://github.com/meadvillerb/onstomp) with git.
