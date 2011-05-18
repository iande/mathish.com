---
layout: default
title: All Posts
---
{% for post in site.posts %}
  <article class="summary">
    <header>
      <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
    </header>
    <section>
      {{ post | summarize }}
    </section>
    <footer>
      <nav class="taggings">
        <h3>Tagged</h3>
        <ul>
        {% for tag in post.taggings %}
          <li class="tagging"
            data-posts="{{ tag.posts.size }}">
            <a href="{{ tag.url }}"
              title="{{ tag.description }}">{{ tag.name }}</a>
          </li>
        {% endfor %}
        </ul>
      </nav>
      <p class="pub-line">
        <a href="{{ post.url }}" class="summary-link">Read On</a>
        Published <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time> &mdash;
        <a href="{{ post.url }}#disqus_thread" data-disqus-identifier="{{ post.url }}">0 Comments</a>
      </p>
    </footer>
  </article>
{% endfor %}
<script type="text/javascript">
    var disqus_shortname = 'mathish';
    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());
</script>
