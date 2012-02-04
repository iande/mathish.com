---
layout: post
title: On Locality
tags:
  - properties of code
  - complexity
  - thoughts
  - code
---
**Note**: I'm still writing this post, and am only sharing it to prove I'm
actually writing something on the matter of locality.


For this one, let's jump right into some code samples. We'll start with an
imaginary `class_a.rb` file,

{% highlight ruby linenos %}
# class_a.rb
class ClassA
  def initialize *items
    @items = items
  end

  def items
    @items
  end

  def items_and_one
    [1] + items
  end
end
{% endhighlight %}

then make `class_b.rb`,

{% highlight ruby linenos %}
# class_b.rb
class ClassB
  def initialize obj
    @my_a = obj
  end

  def times_3
    @my_a.items.map { |i| 3 * i }
  end

  def times_4_and_more
    @my_a.items_and_one.map { |i| 4 * i } +
      times_3
  end

  def foo
    "foo"
  end

  def foobar
    "#{foo}bar"
  end
end
{% endhighlight %}

and finally `run_it.rb`, a script to tie it all together:

{% highlight ruby linenos %}
require 'class_a'
require 'class_b'
a = ClassA.new(1, 2, 3)
b = ClassB.new(a)

b.times_3          # => [3, 6, 9]
b.times_4_and_more # => [4, 4, 8, 12, 3, 6, 9]
b.foobar           # => "foobar"
{% endhighlight %}

Now, with much tedium, let's follow what happens at `run_it.rb:6`

1. We start at `class_b.rb:7`, the definition of `times_3`
2. `times_3` calls `items` from `class_a.rb:7`
3. `items` returns the instance variable `@items` to `class_b.rb:8`
4. `times_3` then maps the array, multiplying each element by 3

At step 2, we move from `ClassB` to `ClassA`, then at step 3 we jump back to
`ClassB` from `ClassA`. The jump back is expected since we then do further
manipulation of the returned value, so we only really care about the first
crossing of a "module boundary."

    b.times_3 =>
      1 module boundary crossing


