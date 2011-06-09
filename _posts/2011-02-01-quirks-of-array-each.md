---
layout: post
title: Quirks of Array#each
tags: ruby notes
sitemap_priority: 0.25
---
I'm probably just late to the party, but at least with Ruby 1.8.7 and 1.9.2,
there's nothing special that has to be done for each of these examples
to produce the same output:

{% highlight ruby %}
[ [1, 2, 3], [4, 5, 6], [7, 8, 9] ].each do |trip|
  puts "#{trip[0]} / #{trip[1]} / #{trip[2]}"
end

[ [1, 2, 3], [4, 5, 6], [7, 8, 9] ].each do |a,b,c|
  puts "#{a} / #{b} / #{c}"
end

[ [1, 2, 3], [4, 5, 6], [7, 8, 9] ].each do |(a,b,c)|
  puts "#{a} / #{b} / #{c}"
end
{% endhighlight %}

I knew that wrapping the block parameters in parentheses worked when arrays
were yielded to the block.  I did not realize that Ruby would automatically
do this when presented with a block that takes multiple parameters.