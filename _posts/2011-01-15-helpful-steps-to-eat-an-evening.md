---
layout: post
title: Helpful Steps to Eat an Evening
tags: rubygems rvm ruby ubuntu notes
---
Why spend our free time doing things we enjoy when it could be better spent
fighting with calculating machines?

1. Update rubygems via `gem update --system`, only to discover after the fact
   that RubyGems 1.4 is not compatible with Ruby 1.9.x.
1. Uninstall all gems, all Ubuntu ruby packages and then
   `rm -rf /usr/lib/ruby/` just for good measure.
1. Black out again, wake up in a car that is
   [Tokyo drifting everywhere](http://www.youtube.com/watch?v=AUhE5KsJ5hk)
1. Install [RVM](http://rvm.beginrescueend.com/)
1. Re-configure [capistrano](https://github.com/capistrano/capistrano) to use
   the RVM plugin
1. Get the first successful `cap deploy` of the evening, but we're running
   the production site on a sqlite database.
1. Add `gem 'pg'` to the `Gemfile`
1. Fight with getting bundle to update `Gemfile.lock` until I remember to add 
   the MacPorts' postgres install directory to `PATH` and export
   `ARCHFLAGS="-arch x86_64"`
1. Re-`cap deploy`, Re-`cap deploy:migrate`.
1. Here we are.

On the plus side, the newest version of
[Phusion Passenger](http://www.modrails.com/) runs with RVM like a god
damned champ.
