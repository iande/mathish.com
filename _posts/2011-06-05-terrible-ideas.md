---
layout: post
title: Terrible Ideas
tags: code ruby rubygems
---
While sitting lurking on the #ruby-lang channel on freenode.net, 
[oddmund](https://github.com/jraregris) suggested creating a `method_missing`
handler that would "auto-correct" misspelled method.  His suggestion was of
course a joke, but it was a pretty good one, so
[he implemented it](https://github.com/jraregris/torispelling).  I provided
my own implementation, along with some other
[terrible ideas](https://github.com/iande/terrible_ideas).

I will never push `terrible_things` to RubyGems for two reasons:

1. It is a joke, obviously.
2. Its features are incompletely implemented.

The goal of implementing this gem was to have a bit of fun and maybe explore
something potentially useful along the way.  One useful bit came from
[Ryan Davis](http://blog.zenspider.com/), `Gem::Text` includes a Levenshtein
distance calculator, so that's handy.  The "semi-monadic" treatment of
`NilClass` actually wasn't all that interesting.  The idea has been done
a lot, and simply returning itself for `method_missing` doesn't make it
a real "Maybe monad." The fun and interesting part has been the lazy
evaluation bits.  By overloading `Object::new`, all object instantiation can
be evaluated lazily.  With a bit of enumerator handling, we can work with
infinite lists in Ruby by virtue of lazy evaluation. 

[Others have done similar things](https://rubygems.org/search?utf8=%E2%9C%93&query=lazy)
with Ruby, but most of them tend to only defer evaluation once, if further
methods are invoked on the lazy "proxy", then its fulfilled to a real object.
To be fair, a useful lazy evaluation library really can't be both correct and
indefinitely lazy in Ruby &mdash; special care has to be taken when dealing
with methods that mutate their object versus ones that return new objects.

Regardless, the whole exercise has been quite a bit of fun, and being able
to transform, filter, and take from infinite lists is pretty sweet.  I can
definitely think of a cleaner implementation than the one derived from lazy
evaluation, though it ultimately relies on the same trick of using
`Enumerator#next` so that finite numbers of elements can be plucked from
these lists that would be impossible to directly compute.

This post is a bit light, both in length and in technical content, my
apologies.  I would like to say that so far I'm impressed with so-called
"e-cigarettes."  They still provide nicotine, so I doubt they'll be much help
in breaking my addiction, but at least I'm not getting my fix by breathing
deeply of burning organic matter.  Now if only I could get nicotine in an
easily digested gel tablet.
