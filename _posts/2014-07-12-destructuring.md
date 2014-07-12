---
layout: post
title:  "Destructuring in a Method Block"
date:   2014-07-12 18:52:15
categories: Ruby RubyMonk Enumerable Inject Map Array
---

I went from genius to idiot - very rapidly - when looking at `Enumerable#map` and
`\#inject` in [RubyMonk], a free resource to help learn ruby that I've found
really useful. Let's start with 'genius' (although not really genius, more wrong
but lucky).

The [question][RMHashMap] was as follows:

> Exploit the fact that map always returns an array: write a method `hash_keys`
> that accepts a hash and maps over it to return all the keys in a linear Array.

Exciting, right?

The solution that RM gave was this:

{% highlight ruby %}
def hash_keys(hash)
    hash.map { |pair| pair.first }
end
{% endhighlight %}

But I went for:

{% highlight ruby %}
def hash_keys(hash)
    hash.map {|key,value| key}
end
{% endhighlight %}

Not much difference, but enough. I had become confused when I entered my code,
thinking more about the `each_with_index` method mentioned in the same page
above. I was forgetting that `#map` would be sending back a single value,
an array of the key-value pair. Ruby Monk's solution used that fact to use the
method `#first` on the array, to get the first element (the key) out.

But, by chance, my solution worked by taking splitting the array by telling the
block for map that it would be getting two arguments - checking with the good
people on the #ruby channel on IRC (a chap called bannisterfiend to be precise),
this is [*destructuring*][destructuring], binding a set of values to
a corresponding set of values that you can normally bind to a single variable
(that's the definition as given in [Common Lisp][Lisp], but makes sense here).

What we're seeing is this:

{% highlight ruby %}
x, y = [1,2]
x # => 1
y # => 2
{% endhighlight %}

But done as a loop for all the arrays pulled out of the hash by `#map`. Tony
Pitluga sings the praises of destructuring block arguments (which is what this
is) in his longer article on [destructuring in Ruby][destructuring].

There's an improvement in the semantics of the method (would you rather have
`key` or `pair.first`?) and a saving of writing/time in any later work you might
want to do on the values. Of course, we wouldn't want to do this to longer
arrays - too many elements to bind to values.

Unless we used the 'unarray' or, 'star' or (best name evar) [splat
operator][splat] to collect some of the other elements.
Consider:

{% highlight ruby %}
x, \*y = [1,2,3,4,5,6j
x # => 1
y # => [2,3,4,5,6]
{% endhighlight %}

There's a lot more on the magic of the splat in the second edition of [The Well
Rounded Rubyist][WRR] which has just been published (and which I'm enjoying
immensely).

OK, I'll write up my other mistake (the one that broke the `#map` block) later in
the week.

PS - noticed when getting links for this post that Ruby 2.0 introduces the
double-splat operator for [turning keyword-value pairs in argument lists into
a hash][double-splat]. Which is also exciting.

[RubyMonk]: https://rubymonk.com/
[RMHashMap]: https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/44-collections/lessons/98-iterate-filtrate-and-transform#solution4313
[destructuring]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
[Lisp]: http://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node252.html
[splat]: http://endofline.wordpress.com/2011/01/21/the-strange-ruby-splat/
[WRR]: http://www.manning.com/black2/
[double-splat]: http://stackoverflow.com/questions/18289152/what-does-double-splat-operators-do-in-ruby
