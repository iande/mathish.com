---
layout: post
title: Bayesian Classification
tags: code, math
published: true
---

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

To start, we'll need a way to tokenize a document into <dfn>terms</dfn>.  The
tokenizer's implementation will depend upon the type of documents under
consideration.  To keep things somewhat simple, let's assume we're working
with English phrases; thus, the terms produced by our tokenizer are simply
words.  Let's suppose we have a set of categories,
{% m %}\mathfrak{C} = \{ C_1, C_2, \ldots , C_n \}{% em %}.
So, what we're then after is the probability that a document belongs
in a particular category, {% m %}C_m{% em %}, given these extracted terms:

{% math %}
  P(C_m \mid T_1, T_2, \ldots, T_n) = \frac{P(C_m) P(T_1, T_2, \ldots, T_n \mid C_m)}{P(T_1, T_2, \ldots, T_n)}
{% endmath %}

We can expand this using the rules of conditional probability:

{% math %}
\begin{aligned}
  P(C_m \mid T_1, \ldots, T_n) &= \frac{P(C_m) P(T_1, \ldots, T_n \mid C_m)}{P(T_1, \ldots, T_n)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2, \ldots, T_n \mid C, T_1)}{P(T_1, \ldots, T_n)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2 \mid C, T_1) P(T_3, \ldots, T_n \mid C, T_1, T_2)}{P(T_1, \ldots, T_n)} \\
   &= \frac{P(C_m) P(T_1 \mid C_m) P(T_2 \mid C, T_1) \ldots P(T_n \mid C, T_1, \ldots, T_{n-1})}{P(T_1, \ldots, T_n)}
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
      \ldots P(T_n \mid C_m)}{P(T_1, \ldots, T_n)} \\
    &= P(C_m) \prod_{i=1}^n \frac{P(T_i \mid C_m)}{P(T_i)}
\end{aligned}
{% endmath %}

For any term, {% m %}T_i{% em %}, we take {% m %}P(T_i \mid C_m){% em %} to
mean the probability of that term occurring given we're working with
category {% m %}C{% em %}, and we calculate it thusly:

{% math %}
  P(T_i \mid C_m) = \frac{t(T_i, C_m)}{\sum_k t(T_k,C_m)}
{% endmath %}

where {% m %}t(x, y){% em %} is the number of times term {% m %}x{% em %}
occurs in category {% m %}y{% em %}.  Next, we tackle {% m %}P(T_i){% em %}
which we take to mean the probability of term {% m %}T_i{% em %} to occur in
general:

{% math %}
  P(T_i) = \frac{\sum_j t(T_i, C_j)}{\sum_j \sum_k t(T_k, C_j)}
{% endmath %}

In other words, we are taking all occurrences of {% m %}T_i{% em %} across
all categories and dividing it by all occurrences of all terms across all
categories.  This brings us, finally, to {% m %}P(C_m){% em %}, meaning the
probability of choosing category {% m %}C{% em %} without taking the terms
into consideration.  There are a couple ways we could
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
alternative for calculating P(C_m):

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
  P(C_m\mid T_1, \ldots, T_n) &= P(C_m) \prod_{i=1}^n \frac{P(T_i \mid C_m)}{P(T_i)} \\
  &= \frac{\sum_k u(T_k, C_m)}{\sum_k u^*(T_k)} \left ( \prod_{i=1}^n
    \frac{\frac{t(T_i, C_m)}{\sum_k t(T_k,C_m)}}{\frac{\sum_j t(T_i, C_j)}{\sum_j \sum_k t(T_k, C_j)}}
    \right )
\end{aligned}
{% endmath %}

Our problem is now just one of counting.  The expression may look horrible,
but that is largely a result of each expression being explicitly defined. Now
that we know what the expressions mean, let's do an informal clean up of
this warlock.

Let's let {% m %}\upsilon_y{% em %} represent the number of distinct terms
in category {% m %}C_y{% em %} and {% m %}\upsilon_*{% em %} represent the total
number of distinct terms.  Further, let's say that {% m %}\tau_{x,y}{% em %}
is the number of times term {% m %}T_x{% em %} occurs in category
{% m %}C_y{% em %}; {% m %}\tau_{x,*}{% em %} is the number of times term
{% m %}T_x{% em %} occurs in all categories; {% m %}\tau_{*,y}{% em %} is
the total number of occurrences of all terms in category {% m %}C_y{% em %};
and {% m %}\tau_{*,*}{% em %} is the total number of occurrences of all terms in
all categories.  We then have:

{% math %}
\begin{aligned}
  P(C_m\mid T_1, \ldots, T_n) &= \frac{\upsilon_m}{\upsilon_*} \left ( \prod_{i=1}^n
    \frac{\frac{\tau_{i,m}}{\tau_{*,m}}}{\frac{\tau_{i,*}}{\tau_{*,*}}}
    \right ) \\
  &= \frac{\upsilon_m}{\upsilon_*} \left ( \prod_{i=1}^n
    \frac{\tau_{*,*} \tau_{i,m}}{\tau_{*,m} \tau_{i,*}}
    \right ) \\
  &= \frac{\upsilon_m \tau_{*,*}^n}{\upsilon_* \tau_{*,m}^n}
    \prod_{i=1}^n \frac{\tau_{i,m}}{\tau_{i,*}}
\end{aligned}
{% endmath %}
