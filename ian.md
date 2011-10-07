---
layout: page
title: About Me
date: 2011-06-07
---
<section itemscope itemtype="http://data-vocabulary.org/Person">
  There's a high degree of probability that my name is <span itemprop="name">Ian D. Eccles</span>.
  Assuming that premise is true, here are a few facts about me.

  * I sing the body <a href="https://github.com/iande" rel="me" title="iande @ github" itemprop="url">Github</a>
    and contribute to [meadvillerb](https://github.com/meadvillerb)
  * I shoot <a href="http://twitter.com/#!/ieccles" rel="me" title="ieccles @ twitter" itemprop="url">tweets</a> into the air
  * I'm developing an interest in <a href="https://plus.google.com/103520585035755947358/about" rel="me" title="Ian Eccles @ Google+" itemprop="url">circles</a>, too
  * It's a good life with [ruby](http://www.ruby-lang.org/en/)
    and [haskell](http://www.haskell.org/haskellwiki/Haskell)
  * Of late I think of [Robert Culp's hair](http://www.imdb.com/name/nm0191685/)
    (circa 1970's)

  <div id="about-face" class="face-1"></div>
</section>
<script type="text/javascript">
  $(function() {
    $('a').hover(function() {
      var faceIdx = Math.floor(Math.random() * 3) + 1;
      $('#about-face').removeClass("face-1 face-2 face-3").
        addClass("face-" + faceIdx);
    });
  });
</script>
