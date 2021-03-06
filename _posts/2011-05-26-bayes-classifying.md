---
layout: post
title: Bayesian Classification
tags: code math ir
---
### A Brief Distraction

After using the classifier I originally laid out in this post, I
discovered that my method of calculating {% m %}P(D){% em %} was very flawed.
I have made the appropriate revisions.

### The Overview

So, as everyone knows by now, [Bayes' Theorem](http://en.wikipedia.org/wiki/Bayes'_theorem)
is expressed as:

{% math %}
  P(A \mid B) = \frac{P(B \mid A) P(A)}{P(B)}
{% endmath %}

What I'm going to talk about isn't new or novel, but it's something that
interests me, so there.  I want to look at using Bayes' theorem to
classify <dfn>documents</dfn>.  This has been done to death with regard
to classifying spam, but I'm going to take a more general look.  For our
purposes, a <dfn>document</dfn> is a sequence of terms such as:
"This cat isn't made of butterscotch"; a paragraph, or the HTML source of this
page.  The idea is to classify a bunch of documents by hand to "train" our
classifier so that when new documents come along, we can ask the classifier
where they belong.  One way to accomplish this is through the use of Bayes'
theorem.

### The Real Work

To start, we'll need a way to tokenize a document into <dfn>terms</dfn>.  The
tokenizer's implementation will depend upon the type of documents under
consideration.  To keep things somewhat simple, let's assume we're working
with English phrases; thus, the terms produced by our tokenizer are simply
words.  Let's suppose we have a set of categories,
{% m %}\mathfrak{C} = \{ C_1, C_2, \ldots , C_n \}{% em %}.
So, what we're then after is the probability that a document belongs
in a particular category, {% m %}C_m{% em %}, given these extracted terms:

{% math %}
\begin{aligned}
  P(C_m \mid D) &= \frac{P(C_m) P(D \mid C_m)}{P(D)} \\
  P(C_m \mid T_1,\ldots,T_n) &= \frac{P(C_m) P(T_1,\ldots,T_n \mid C_m)}{P(D)}
\end{aligned}
{% endmath %}

We're letting {% m %}D{% em %} represent our <dfn>document</dfn>, and then
expanding the document into its individual terms, {% m %}T_1,\ldots,T_n{% em %}.
You'll notice that we've skipped the expansion of {% m %}P(D){% em %}, the
justification for this will be explained shortly.

We can expand this using the rules of conditional probability:

{% math %}
\begin{aligned}
  P(C_m \mid T_1, \ldots, T_n) &= \frac{P(C_m) P(T_1, \ldots, T_n \mid C_m)}{P(D)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2, \ldots, T_n \mid C, T_1)}{P(D)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2 \mid C, T_1) P(T_3, \ldots, T_n \mid C, T_1, T_2)}{P(D)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2 \mid C, T_1) \ldots P(T_n \mid C, T_1, \ldots, T_{n-1})}{P(D)}
\end{aligned}
{% endmath %}

This formulation is available on the Wikipedia page on [Naive Bayes classifiers](http://en.wikipedia.org/wiki/Naive_Bayes_classifier).
As we are taking a naive approach, we assume there is no interdependence
between terms, ie:

{% math %}
  P(T_i \mid T_j) = P(T_i)
{% endmath %}

Now, when it comes to words, this is a obviously poor assumption.  For instance, it is far
more likely that the word "poor" would appear before "assumption" than the
word "Faustian" in day-to-day phrases.  However, we're going to go ahead with
the naive assumption for now, which simplifies our equation:

{% math %}
\begin{aligned}
    P(C_m \mid T_1, \ldots, T_n) &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2 \mid C_m)
      \ldots P(T_n \mid C_m)}{P(D)} \\
    &= \frac{P(C_m)}{P(D)} \prod_{i=1}^n P(T_i \mid C_m)
\end{aligned}
{% endmath %}

For any term, {% m %}T_i{% em %}, we take {% m %}P(T_i \mid C_m){% em %} to
mean the probability of that term occurring given we're working with
category {% m %}C_m{% em %}, and we calculate it thusly:

{% math %}
  P(T_i \mid C_m) = \frac{t(T_i, C_m)}{\sum_k t(T_k,C_m)}
{% endmath %}

where {% m %}t(x, y){% em %} is the number of times term {% m %}x{% em %}
occurs in category {% m %}y{% em %}.  This brings us to {% m %}P(C_m){% em %},
meaning the probability of choosing category {% m %}C{% em %} without taking
the document into consideration.  There are a number of ways we could
calculate {% m %}P(C_m){% em %}, such as assuming that all categories are
equally likely:

{% math %}
  P_1(C_m) = \frac{1}{|\mathfrak{C}|}
{% endmath %}

where {% m %}|\mathfrak{C}|{% em %} denotes the number of categories in our
classifier.  While this works, a better measure of might take into account the
number of documents a category has been trained with:

{% math %}
  P_2(C_m) = \frac{d(C_m)}{\sum_k d(C_k)}
{% endmath %}

where {% m %}d(y){% em %} indicates the number of documents belonging to
category {% m %}y{% em %}.  All other things being equally, 
{% m %}P_2(C_m){% em %} will favor categories that have been fed the most
documents.  If each category is trained with the same number of documents,
then we're back to the uniform probability given earlier.

Basing {% m %}P(C_m){% em %} on document counts does pose a problem.  Suppose
the following documents belonged to the same category:

    this document is pretty small
    small this document is pretty
    pretty small this document is
    is pretty small this document
    document is pretty small this

These are all distinct permutations of the same string, and thus distinct
documents.  The problem is that the classifier we are in the process of
constructing deals with terms.  Our assumption of the independence between
terms means that their ordering has no bearing on the classifier.  From this
position, we could argue that each of the five documents listed above are
actually the same document as far as our classifier is concerned, and if we
relied on document counts for {% m %}P(C_m){% em %}, this set of documents
would give some category an unfair bias.  So, let's consider another
alternative for calculating {% m %}P(C_m){% em %}:

{% math %}
  P_3(C_m) = \frac{\sum_k t(T_k, C_m)}{\sum_j \sum_k t(T_k, C_j)}
{% endmath %}

This approach is calculating the probability of a given category as the
sum of occurrences of all terms in the category and the sum of occurrences
of all terms across all categories.  Unfortunately, this form may also be
unfairly biased by document repetition (e.g. if we fed a category the
five documents shown earlier.)  Let's consider one more alternative:

{% math %}
  P_4(C_m) = \frac{\sum_k u(T_k, C_m)}{\sum_k u^*(T_k)}
{% endmath %}

where {% m %}u(x, y){% em %} and {% m %}u^*(x){% em %} are defined
as:

{% math %}
\begin{aligned}
  u(x, y) &= \left\{
    \begin{array}{ll}
      1 & \text{if \(x \in y\)} \\
      0 & \text{otherwise}
    \end{array}
    \right. \\
    
  u^*(x) &= \left\{
    \begin{array}{ll}
      1 & \text{if \(\exists y \in \mathfrak{C} : x \in y\)} \\
      0 & \text{otherwise}
    \end{array}
    \right. \\
\end{aligned}
{% endmath %}

These definitions may seem complicated, but they are both very simple
concepts: {% m %}u(x,y){% em %} is just counting the number of distinct terms
in category {% m %}y{% em %} and {% m %}u^*(x){% em %} is counting the total
number of distinct terms from all categories.

While each of the four possibilities presented for {% m %}P(C_m){% em %} are
very different from one another, they are all valid approaches.  Personally,
I feel {% m %}P_1(C_m){% em %} is too naive in its assumption that all
categories are equally likely to be selected, and as I intend on keeping
track of only terms and categories, I can also rule out
{% m %}P_2(C_m){% em %}.  As mentioned earlier, {% m %}P_3(C_m){% em %} can
be biased by repeated terms, so I'm going to opt for
{% m %}P(C) = P_4(C_m){% em %}.  Again, I wish to stress that this is a
personal choice, your Bayesian needs may differ from mine.

With that all taken care of, we can now expand our classifier to:

{% math %}
\begin{aligned}
  P(C_m \mid T_1, \ldots, T_n) &= \frac{P(C_m)}{P(D)} \prod_{i=1}^n P(T_i \mid C_m) \\
  &= \frac{\sum_k u(T_k, C_m)}{P(D) \sum_k u^*(T_k)} \left ( \prod_{i=1}^n
    \frac{t(T_i, C_m)}{\sum_k t(T_k,C_m)} \right )
\end{aligned}
{% endmath %}

Our problem is now just one of counting.  The expression may look horrible,
but that is largely a result of each expression being explicitly defined. Now
that we know what the expressions mean, let's do an informal clean up of
this warlock by substituting simpler symbols for our sweet mess of expressions.
Before we do, we need to take a closer look at {% m %}P(D){% em %}, which in
earlier revisions of this post was explicitly, and incorrectly, defined.
For a given document, {% m %}P(D){% em %} will be the same, regardless of the
category under consideration.  When our classifier is asked to classify a
document, it will iterate over each of its categories and perform this
calculation, which each of the final category probabilities will be scaled
by this same term.  So, our first simplification will be to substitute
{% m %}P(D){% em %} with {% m %}\delta{% em %}, which we will not
explicitly define as we will eventually discard it.

Now, let's let {% m %}\upsilon{% em %} be the number of unique terms in the
category we are considering and {% m %}\Upsilon{% em %} be the number of
unique terms in all of our categories.  Finally, we let {% m %}g(T_i){% em %}
be the number of occurrences of term {% m %}T_i{% em %} in the current
category and {% m %}G{% em %} be the occurrences of all terms in all of our
categories.  With these simplifications, our equation becomes:

{% math %}
\begin{aligned}
  P(C_m \mid T_1,\ldots,T_n) &= \frac{\upsilon}{\delta \Upsilon}
    \prod_{i=1}^n \frac{g(T_i)}{G} \\
  &= \frac{\upsilon}{\delta \Upsilon G^n} \prod_{i=1}^n g(T_i) \\
  &= \frac{1}{\delta} \frac{\upsilon}{\Upsilon G^n} \prod_{i=1}^n g(T_i) \\
  \delta P(C_m \mid T_1,\ldots,T_n) &=  \frac{\upsilon}{\Upsilon G^n}
    \prod_{i=1}^n g(T_i)
\end{aligned}
{% endmath %}

Hopefully it is now painfully obvious that each category will be scaled
by a common factor, namely {% m %}\frac{1}{\delta}{% em %}.  The purpose
of our classifier is to pick the category a given document most likely
belongs in, and if they are all scaled by this common term we can disregard
it.  In an effort to preserve mathematical accuracy, I have opted to multiply
both sides of the equation by {% m %}\delta{% em %}.

All we've gained from this simplification is some mental manageability.  I
wanted to derive the explicit calculations involved in Bayesian
classification, but products of fractions containing summations don't tend
to be very memorable.  Any additional calculations we may need to perform
on the explicit form would have made things even messier, which serves
as a nice segue into our next step.

In a world where we are free to perform these calculations without loss of
precision, this expression is just fine.  However, given that we are
multiplying a series of numbers all in the range {% m %}[0, 1]{% em %}, a
computer may eventually round a product to 0, and totally ruin our day.  We
can correct this with a little help from a
<a href="#note-logarithms" id="ref-logarithms">logarithm*</a>:

{% math %}
\begin{aligned}
  \log \left( \delta P(C_m \mid T_1,\ldots,T_n) \right) &= \log \left (
    \frac{\upsilon}{\Upsilon G^n} \prod_{i=1}^n g(T_i)
    \right) \\
  \log \delta + \log P(C_m \mid T_1,\ldots,T_n) &=
    \log \left( \frac{\upsilon}{\Upsilon G^n} \right) +
    \log \left( \prod_{i=1}^n g(T_i) \right) \\
  &= \log \left( \frac{\upsilon}{\Upsilon} \right) - n \log G +
    \sum_{i=1}^n \log \left( g(T_i) \right)
\end{aligned}
{% endmath %}

Is this logarithm business really necessary?  Consider a document with
324 unique terms where, thanks the awesome power of contrived examples,
{% m %}\frac{g(T_i)}{G} = 0.1{% em %} for each term.  When we take the
product of all these terms, we end up with {% m %}0.1^{324}{% em %}.  That's
a pretty small number, so small that Ruby mistakes it for 0:

{% highlight ruby %}
0.1 ** 324 # => 0.0
{% endhighlight %}

Now, we did factor {% m %}\frac{1}{G^n}{% em %} out of our product earlier, but
{% m %}\frac{1}{G^{324}}{% em %} is also bound to be very small.  This
post alone is up to 608 unique terms, just to give an example of how likely
it is that our classifier might experience floating-point underflow.

### Digging Deeper

There are a few edge cases to consider, here are five I can think of off of
the top of my head:

1. What if there are no known terms for a particular category?
2. What if there are no known terms for the classifier as a whole?
3. What if a term is unknown to a particular category?
4. What if a term is unknown to the classifier as a whole?
5. How do we handle repeated terms (i.e. {% m %}T_i = T_j{% em %}) in a
   document that our classifier is attempting to classify for us?

We can easily address the first two cases.  If any category has not been trained, we
assume {% m %}P(C | T_1,\ldots,T_n) = 0{% em %}, thus if none of our
categories have been trained (case #2), we assume all categories are equally
likely (or unlikely) and either return an arbitrary one or none at all.
The third and fourth cases are consequences of the fact that we are
estimating probabilities.  Through training, our classifier is building
approximations for these various probabilities.  It is
entirely possible, perhaps even very likely, that we will encounter documents
we wish to classify containing terms that were not included in our training.
If we rely solely on the calculations presented here, a foreign term will
result in zeroing the overall probability or produce an error &mdash;
either from a division by zero or from the undefined {% m %}\log(0){% em %}
calculation.  To prevent garbage results, we will need to assign a non-zero
probability, {% m %}\epsilon{% em %}, to terms unknown to a particular
category.

The fifth case deserves its own paragraph.  To handle this situation, we
defer to simple rules for conditional probabilities.  Consider the following:

{% math %}
  P(A | B, C, D) = P(A | B \cap C \cap D)
{% endmath %}

If {% m %}B{% em %} and {% m %}C{% em %} are describing the same event, then
the expression simplifies to:

{% math %}
  P(A | B \cap D)
{% endmath %}

The same holds true for documents we wish to *classify*.  We could argue that
repeated terms do not describe the same event because the terms are occurring
in distinct positions; however, we have not worked positional information into
our classifier.  It is important to note that when we are *training* our
classifier with documents, we do take repeated terms into consideration.

### Final Business

Now that virtually every email client has, at one point or another, made
use of some form of Naive Bayes classification, I realize it's no longer
the hot topic it once was.  However, while reviewing the Ruby
[classifier](https://rubygems.org/gems/classifier), I discovered that their
Bayes implementation was wrong.  This was independently confirmed by
[Brian Muller](https://github.com/bmuller).  While working on a fork of it
with [Zeke](https://github.com/ezkl), I discovered that while the approach is
well known, there are nuances that can significantly impact the results
&mdash; examples being the choice in {% m %}P(C){% em %} and the default
probability, {% m %}\epsilon{% em %}.

### Foot Noted

#### Note: Logarithms

I would like to thank [Brian Muller](https://github.com/bmuller) for
explaining the use of logarithms in a
[Naive Bayes classifier](https://github.com/livingsocial/ankusa/blob/master/lib/ankusa/naive_bayes.rb)
he's developing in Ruby, even if we don't share the same views on
{% m %}P(C){% em %}.  My Numerical Analysis professors would probably be
displeased that I forgot about this trick.
[ [jump back](#ref-logarithms) ]
