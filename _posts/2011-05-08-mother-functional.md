---
layout: post
title: On Functional Complexity - Part 1
---
About a year ago, I began giving some serious thought to an article named
[Functional Complexity Modulo a Test Suite](https://github.com/raganwald/homoiconic/blob/master/2009-06-02/functional_complexity.md)
by [Reg Braithwaite](http://raganwald.posterous.com/).  Today, I think I have
something to say on the matter.

### Background

Suppose you're a programmer embracing the trends of test or behavior driven
development.  You have a problem to solve and expectations on how the
solution should behave.  So, you think about the problem, enumerate the
behaviors and write some tests to model this version of reality.  You start
writing code to satisfy these tests.  Red becomes green, you refactor clumsy
first drafts into terse and expressive statements that are almost a pleasure
to read, when without warning, four years of undergraduate mathematics grab
ahold of your brain and thrust you into theoretical domains.  Your output of
practical, working code is halted for the day, while you begin contemplating
ways to measure "readability", "maintainability", "complexity" and how these
ideas fit within the framework you have spent the past few years operating
within.  You immediately regret taking that second major in mathematics, but
it's an integral part of you now.  You know you can't run from it, so you do
your best to appease it by firing up your favorite text editor, ensuring that
your blog is running [MathJax](http://www.mathjax.org/), and whipping out
your {% m %}\LaTeX{% em %} fu!

### Some Preliminary Definitions

The following definitions have been directly derived from the original
article linked above.

For our purposes, a <dfn>program</dfn>, {% m %}p{% em %}, is a function of inputs that
returns some kind of output.  We will use {% m %}\mathcal{P}{% em %} to denote
the set of all programs.

A <dfn>test</dfn>, {% m %}t{% em %}, is a function that maps a program, {% m %}p{% em %}
to either 1, for true, or 0, for false: {% m %}t : \mathcal{P} \rightarrow \{0, 1\}{% em %}.

A program, {% m %}p{% em %}, is said to <dfn>satisfy</dfn> a test,
{% m %}t{% em %}, if and only if {% m %}t(p) = 1{% em %}.  We will this
relationship with the symbol {% m %}\models{% em %}:

{% math %}
  p \models t \iff t(p) = 1
{% endmath %}

A test, {% m %}t{% em %}, is a <dfn>meaningful test</dfn> if and only if there
exist two programs, {% m %}p_1{% em %} and {% m %}p_2{% em %}, such that
{% m %}t(p_1) = 0{% em %} and {% m %}t(p_2) = 1{% em %}.  That is to say,
there exists at least one program that satisfies the test and at least one
program that does not satisfy the test.

A test suite, {% m %}\sigma = \{ t_1, t_2, \ldots, t_n \}{% em %}, is a set of
{% m %}n{% em %} tests.  We denote the number of tests in a suite as
{% m %}|\sigma| = n{% em %}. A program is said to <dfn>satisfy</dfn> a test suite,
{% m %}\sigma{% em %} if it satisfies each of the tests in {% m %}\sigma{% em %}.
More formally, {% m %}p \models \sigma{% em %} if, and only if
{% m %}\forall t \in \sigma, p \models t{% em %}.  As all tests are bound
to the range {% m %}\{0, 1\}{% em %}, we can provide an equivalent arithmetic
definition:

{% math %}
  p \models \sigma \iff \sum_{i=1}^{|\sigma|} t_i(p) = |\sigma|.
{% endmath %}

We say two programs are <dfn>functionally congruent modulo a test
suite</dfn> when they both satisfy the same test suite.  When there is no
danger of ambiguity, we may simply refer to two (or more) programs as being
"congruent."  We represent this notion of congruence as follows:

{% math %}
  p_1 \equiv p_2 (\bmod \sigma) \iff p_1 \models \sigma, p_2 \models \sigma.
{% endmath %}

Consider all of the programs that might satisfy the test suite.  There are an
infinite number of programs in this set (I will provide a trivial proof of
this statement in the section "[Example Programs and Calculations](#example-programs-and-calculations)".)
Now, let's suppose we have a metric, {% m %}|p|{% em %}, that measures the
size of a program.  As a trivial example, let's suppose {% m %}|p|{% em %} is
the number of characters in the string representation of program {% m %}p{% em %}.
We could use a more interesting measurement
but for now let's stick with the simple "string length" measurement.  We
take this measuring stick and apply it to each of the programs in the set
of programs that satisfy a given test suite, and record the "shortest length"
measured.  This "shortest length" is the <dfn>functional complexity</dfn> of
the test suite.  Given a metric for a program {% m %}|p|{% em %},
the functional complexity of a test suite {% m %}D_{\sigma}{% em %}, is
given by,

{% math %}
\begin{aligned}
   L_{\sigma} & = \left\{ |p| : p \models \sigma \right\}, \\
  D_{\sigma} & = \min L_{\sigma}.
\end{aligned}
{% endmath %}

And finally, we define the <dfn>functional complexity of a program,
modulo a test suite</dfn>, {% m %}F_{\sigma}(p){% em %}, to be the functional
complexity of the test suite, {% m %}D_{\sigma}{% em %} if and only if the
program satisfies the test suite.
Alternatively,

{% math %}
  F_{\sigma}(p) = \left\{
    \begin{array}{ll}
      D_{\sigma} & \text{if \(p \models \sigma\)} \\
      \infty & \text{otherwise}
    \end{array}
    \right.
{% endmath %}

The important point to take away from this is that every program that
satisfies a given test suite has the same functional complexity relative to
that test suite.

### Example Programs and Calculations

Suppose we want a program that takes the sum of all of the integers from
1 to {% m %}k{% em %}.  We begin by writing some tests (note: I am going to
make use of a hypothetical `assert` function that returns 1 if the block it
is given evaluates to true, and 0 otherwise):

{% highlight ruby %}
def test_1 program
  assert { program.call(10) == 55 }
end

def test_2 program
  assert { program.call(6) == 21 }
end

def test_3 program
  assert { program.call(83) == 3486 }
end
{% endhighlight %}


Our test suite consists of three tests, each checking that our program
produces the correct sum for distinct values of {% m %}k{% em %}.  As
mentioned earlier, there are an infinite number of programs that can satisfy
this test suite, and here is the trivial proof:

{% highlight ruby %}
def sum_with_while k
  i = 1
  sum = 0
  while i <= k
    sum += i
    i += 1
  end
  sum
end

def sum_with_while_1 k
  unused_local = 1
  sum = 0
  i = 1
  while i <= k
    sum += i
    i += 1
  end
  sum
end

def sum_with_while_2 k
  unused_local = 2
  sum = 0
  i = 1
  while i <= k
    sum += i
    i += 1
  end
  sum
end
{% endhighlight %}

Hopefully, the pattern is obvious: the program `sum_with_while_<x>` will set
`unused_local = x`.  This assignment adds nothing of value to the program,
but the program still returns the appropriate result, and thus satisfies the
test suite.

Now, let's consider a few non-trivial variations:

{% highlight ruby %}
p1 = lambda do |k|
  i = 1
  sum = 0
  while i <= k
    sum += i
    i += 1
  end
  sum
end

p2 = lambda do |k|
  a = b = 0
  while a < k
    b += (a += 1)
  end
  b
end

p3 = lambda do |k|
  (1..k).inject { |sum,i| sum + i }
end

# Only when Symbol#to_proc is available (eg: Ruby 1.8.7+)
p4 = lambda do |k|
  (1..k).inject(&:+)
end

# Only if Enumerable#sum is available (eg: active_support)
p5 = lambda do |k|
  (1..k).sum
end

p6 = lambda do |k|
  k * (k + 1) / 2
end

p7 = lambda do |k|
  case k
  when 10 then 55
  when 6 then 21
  when 83 then 3486
  end
end
{% endhighlight %}

Each of these programs, {% m %}p_1 \ldots p_7{% em %}, satisfy our test suite.
Programs {% m %}p_1{% em %} and {% m %}p_2{% em %} are very similar, but with
some variables renamed and some operations switched about.  Programs
{% m %}p_3{% em %}, {% m %}p_4{% em %}, and {% m %}p_5{% em %} are also
similar: {% m %}p_4{% em %} removes some verbosity by using Ruby's
`Symbol#to_proc` method while {% m %}p_5{% em %} makes use of ActiveSupport's
`Enumerable#sum` method which in turn calls `inject`.  The program
{% m %}p_6{% em %} calculates the sum analytically without iteration while
program {% m %}p_7{% em %} provides results only for the values tested for.

We will ignore the variable assignment and line ending characters when
calculating the length of these programs.  For example, when calculating the
length of {% m %}p_6{% em %}, we count only the characters in "lambda do |k|"
(13 characters), "&nbsp;&nbsp;k * (k + 1) / 2" (17 characters, including the
two leading spaces), and "end" (3 characters), for a total of 33 characters.
We ignore line ending characters (eg: `\n`) because they aren't readily
visible.  Why make the process of verifying these numbers more tedious than
it already is?

Below are the lengths of each of the programs based upon this method of
counting characters:

{% math %}
\begin{aligned}
  |p_1| & = 78 \\
  |p_2| & = 65 \\
  |p_3| & = 51 \\
  |p_4| & = 36 \\
  |p_5| & = 28 \\
  |p_6| & = 33 \\
  |p_7| & = 81
\end{aligned}
{% endmath %}

We see that {% m %}p_5{% em %} is the shortest of our programs, weighing in
at 28 characters.  One could argue that the size of {% m %}p_5{% em %} is
misrepresented because the `sum` method is not a native Ruby method, and we
could address that concern by adding the length of the definition of `sum` to
{% m %}|p_5|{% em %}.  When measured in the same way as our programs, the 
`Enumerable#sum` method found in ActiveSupport 3.0.7 weighs in at 112
characters, so let's tack that on, {% m %}|p_5| = 140{% em %}.  Ensuring that
the metric accounts for the program's definition as well as any external
dependencies keeps our measurements meaningful.  Otherwise, we could create
a very small program that satisfies our test suite:

{% highlight ruby %}
p8 = lambda do |k|
  p1[k]
end
{% endhighlight %}

If our notion of size does not account for the size of all external
dependencies, our metric (and that which we intend to build upon it) loses
nearly all utility.

Taking into consideration the adjustment made to {% m %}|p_5|{% em %}, the
"smallest" example program that satisfies our test suite is
{% m %}p_6{% em %}.  It is entirely possible that there exist programs even
smaller that also satisfy the suite, but given that
{% m %}p \models \sigma{% em %} we can conclude

{% math %}
\begin{aligned}
  D_{\sigma}    & \leq |p_6| \\
  F_{\sigma}(p) & \leq |p_6| \\
                & \leq 33
\end{aligned}
{% endmath %}

So, we only have an upper bound on {% m %}D_{\sigma}{% em %}? Close enough!

### Kolmogorov Complexity and Functional Complexity

One way of measuring the complexity of a string is by measuring its
[Kolmogorov complexity](http://en.wikipedia.org/wiki/Kolmogorov_complexity).
A quick overview of the process, taken straight from the linked Wikipedia
article, is to take a string:

    abababababababababababababababababababababababababababababababab
    
and search for a smaller representation of the it:

    ab repeated 32 times
    
The first string has 64 characters, the second string has only 20.  Our
simplification of the original string may not be minimal, but it is
substantially smaller, which suggests that the original string was not very
complex.  The actual Kolmogorov complexity of a string is the size of its
minimal representation in some fixed universal description language.  Provided
that our language of choice is Turing complete, our measurements will vary
from some other choice in language by a fixed constant.  So, let's pick Ruby.

{% highlight ruby %}
'ab'*32
{% endhighlight %}

We now have a representation of our original string that is only 7 characters
long.  This representation may still not be minimal, but as with Functional
complexity, we now have an upper bound &mdash; the Kolmogorov complexity of
the original string in Ruby is at most 7.  It's been a while since I've thrown
down some {% m %}\LaTeX{% em %}, so if we let {% m %}K(s){% em %} represent
the Kolmogorov complexity of a string, {% m %}s{% em %}, and {% m %}d(s){% em %}
represent a minimal description of {% m %}s{% em %} in Ruby, then:

{% math %}
\begin{aligned}
  K(s) & = |d(s)| \\
       & \leq 7
\end{aligned}
{% endmath %}

So, unsurprisingly, or original string is really not that complex, it can be
greatly compressed, and it is very "un-random."  All three of those statements
are roughly synonymous.  Now, what is the relationship, if any, between
Kolmogorov complexity and Functional complexity modulo a test suite?
Kolmogorov complexity deals with individual strings whereas Functional
complexity deals in programs that satisfy a test suite, so to find a
relationship between the two, we need to get them both working in the same
domain.  In our example test suite, we have a pretty simple mapping between
input and expected output that can be represented by many different strings.
Here's one:

{% highlight ruby %}
"10=55,6=21,83=3486".split(',').each_with_index do |io, i|
  i, o = io.split('=')
  define_method :"test_#{i+1}" do |p|
    assert { p[i.to_i] == o.to_i }
  end
end
{% endhighlight %}

This test suite builder weighs in at 159 characters (excluding `\n`
characters) compared to 169 characters in our original test suite.  We could
use a regular expression instead of multiple calls to `String#split`:

{% highlight ruby %}
"10=55,6=21,83=3486".scan(/(\d+)=(\d+)/).each_with_index do |(i,o), k|
  define_method :"test_#{k+1}" do |p|
    assert { p[i.to_i] == o.to_i }
  end
end
{% endhighlight %}

to bring our length down to 147 characters.  The best part of this little
excursion is that none of the numbers I've thrown at you are important, I just
like to count things. What really matters is that you now see how
`10=55,6=21,83=3486` serves as a complete representation of our original
test suite.  We want to measure this string's Kolmogorov complexity.

None of the programs we've written to satisfy our test suite will generate
the string we're now after, so we need to wrap them in a loving adapater:

{% highlight ruby %}
adapter = lambda do |p|
  [10,6,83].map { |i| "#{i}=#{p[i]}" }.join ','
end
{% endhighlight %}

Excluding line endings &mdash; Do I need me to keep repeating that? Let's
assume it's implied from here on out &mdash; our adapter is 63 characters
long.  We can now represent one 20 character string as a string of at least
63 characters.  In terms of compression, we're doing it wrong, but fret not,
for soon things will get better.  In the meantime, we now have a program
that takes old programs and turns them into new programs capable of producing
the string we seek: {% m %}p^{\prime} = A(p){% em %}.  Taking
{% m %}p_2{% em %} as an example, we can do it all in Ruby with roughly 128
characters.  <span id="kc-iff-1">Hopefully</span> it is clear that if
{% m %}p \models \sigma{% em %}, then {% m %}p^{\prime}{% em %} generates our
desired string.

Now comes the improvement to our compression fail: when measuring Kolmogorov
complexity, we are free to pick our language.  Instead of using Ruby, we 
could use Python or Pascal.  We are also free to pick a superset of Ruby, say
Ruby + `adapter`.  We're going to be little pickier than that, though.  Our
language of choice is the one where every program written is fed into the 
adapter.  With this restriction, the program:

{% highlight ruby %}
lambda { |*_| "10=55,6=21,83=3486" }
{% endhighlight %}

will not produce the desired string.  Instead, it will be wrapped by `adapter`
and evaluate to:

    10=10=55,6=21,83=3486,6=10=55,6=21,83=3486,83=10=55,6=21,83=3486

Thus, if our wrapped program, {% m %}p^{\prime}{% em %}, produces the desired
string, then our original program satisfies the original test suite.  Combine
this with our [earlier statement](#kc-iff-1), and we've got an equivalence:

{% math %}
  p \models \sigma \iff p^{\prime} = s,
{% endmath %}

where {% m %}s{% em %} is our encoded test suite `10=55,6=21,83=3486`.  Thus,
given a minimal description, {% m %}d(s){% em %}, of our encoded test suite
{% m %}s{% em %} in this adapter wrapped Ruby language, we can infer that
{% m %}d(s) \models \sigma{% em %} (perhaps with the help of `eval`.)  We also
know that {% m %}D_{\sigma} \approx d(s){% em %}, since {% m %}d(s){% em %} is
minimal in length. So, {% m %}|d(s)|{% em %} gives us our Kolmogorov
complexity and our <a href="#note-approximate-functional-complexity" id="ref-approx">
Functional complexity*</a>.

From our previous excursions in counting characters and whitespace (but not
newlines!), we see that all of the programs that satisfy the test suite are
longer than the 20 characters.  Bummer, we still fail at compression.  But
what happens if we add a few more tests?  Let's expand our encoded test suite
to the following:

    10=55,6=21,83=3486,99=4950,1019=519690,9001=40513501,15146=114708231

Now our desired string is 68 characters long.  We know that
{% m %}|d(s)| \leq |p_6| = 33{% em %}, and we have finally un-failed at
compression!  In addition to finding a representation for the string that is
half as long, we also kicked program {% m %}p_7{% em %} out of the set of
programs that satisfy our test suite.  Keeping with the spirit of how
{% m %}p_7{% em %} satisfies the test suite, we can get it back in line with
the following change:

{% highlight ruby %}
p7 = lambda do |k|
  case k
  when 10 then 55
  when 6 then 21
  when 83 then 3486
  when 99 then 4950
  when 1019 then 519690
  when 9001 then 40513501
  when 15146 then 114708231
  end
end
{% endhighlight %}

In adjusting {% m %}p_7{% em %} to satisfy the new test suite, we have
increased its length to 175 characters.  So when our test suite was 20
characters long, {% m %}p_7{% em %} satisfied it in 81 characters.  When
the test suite grew by 48 characters, {% m %}p_7{% em %} was forced to
grow by 94 characters.  Changing a test changes a program... I smell a
potentially useful metric in there, and we will dig deeper into this next
time.

I had intended to explore the relationship between these measures of
complexity and somewhat vague notions such as "readability" and
"maintainability" in this article, but it's already quite a bit longer than
I had anticipated.  I will definitely be talking about "maintainability"
next time:  I believe there is a relationship between how much code must
change when test suites are modified, but I need some time to think more
about the math (I may have to whip out calculus or difference equations.)
I would also like to explore "readability," though I may refer to it as 
"comprehensibility" instead, by inverting a lot of the work done in this
article, but I may have to turn this series of articles into a trilogy to do
so.  Stay tuned... or don't, I'm still going to write it anyway!

### Foot Noted

#### Note: Approximate Functional Complexity

I played a little fast and loose with notation earlier.  The description
string, {% m %}d(s){% em %}, is just that a *string*.  As I mentioned, we may
need the help of `eval` to map it from the world of characters to the domain
of programs, so {% m %}D_{\sigma}{% em %} may be a few characters longer than
{% m %}|d(s)|{% em %}.  However, the number of additional characters is
constant, so I'm okay with saying the two measures of complexity are roughly
equivalent.
[&nbsp;[jump back](#ref-approx)&nbsp;]
