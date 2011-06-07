---
layout: page
title: About Me
---
There's a high degree of probability that my name is Ian D. Eccles.
Assuming that premise is true, here are a few facts about me.

* I sing the body <a href="https://github.com/iande" rel="me" title="iande @ github">Github</a>
  and contribute to [meadvillerb](https://github.com/meadvillerb)
* I shoot <a href="http://twitter.com/#!/ieccles" rel="me" title="ieccles @ twitter">tweets</a> into the air
* It's a good life with [ruby](http://www.ruby-lang.org/en/)
  and [haskell](http://www.haskell.org/haskellwiki/Haskell)
* Of late I think of [Robert Culp's hair](http://www.imdb.com/name/nm0191685/)
  (circa 1970's)

An additional piece of information has been encoded in the previous list.

<div id="about-face" class="face-1">
</div>

<script type="text/javascript">
  $(function() {
    $('a').hover(function() {
      var faceIdx = Math.floor(Math.random() * 3) + 1;
      $('#about-face').removeClass("face-1 face-2 face-3").
        addClass("face-" + faceIdx);
    });
  });
</script>
