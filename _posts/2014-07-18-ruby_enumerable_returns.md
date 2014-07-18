---
layout: post
title:  "Many Enumerable Returns"
date:   2014-07-18 20:52:15
categories: Ruby
---

As threatened then, here's the followup to my [last post][lastpost] on the `#Enumerables`
section from [Ruby Monk][RubyMonk], how I felt like a bit of an idiot for a few
hours, and what I learned from that.

tl;dr - enumerable blocks aren't magic; `yield` is magic.

This question is a little further along from the last, and was framed so:

>Try implementing a method called occurrences that accepts a string argument and
>uses inject to build a Hash. The keys of this hash should be unique words from
>that string. The value of those keys should be the number of times this word
>appears in that string.

So far so, so good. So I wrote this:

{% highlight Ruby %}
def occurrences(str)
  str.scan(/\w+/).inject(Hash.new(0)) do |hashy, i|
    hashy[i.downcase] += 1
  end
end
{% endhighlight %}

Which spat out:

> ``TypeError
> can't convert String into Integer``

And left me confused for a good few minutes. OK, getting on for a quarter of an
hour. What was going on? - what I'd written was very similar to the example
above:

{% highlight ruby %}
[4, 8, 15, 16, 23, 42].inject({}) { |a, i| a.update(i => i) }
{% endhighlight %}

So I caved and looked at the answer:

{% highlight ruby %}
def occurrences(str)
	str.scan(/\w+/).inject(Hash.new(0)) do |build, word|
    	build[word.downcase] +=1
    	build
	end
end
{% endhighlight %}

Which left me none the wiser. Why was the block re-iterating the accumulator
function at the end? To test this I played around with `p`-ing the lines of the
block... and discovered something interesting. Namely,

{% highlight ruby %}

a.update(i => i) # => a

# But...

build[word.downcase] +=1 # => build[word.downcase], the new value of that key

{% endhighlight %}

The block *needs to return the accumulator* - the first example is just lucky
that it does so already!

The only reason the accumulator in an `Enumerable#inject` accumulates is that
*it's returned from the block on each iteration*. In other words, somewhere in
the definition of `#inject` for each class that can be made enumerable, the
method `yield`s to the block, and then keeps the value returned to be passed in
again as the new accumulator argument.

I'd previously thought of `#inject` as working by *magic*, whereas in fact it
was working by a method I could probably write myself given enough time.
Something like this...

{% highlight ruby %}

bob = [1,2,3,4,5,6]

def bob.inject(default = nil)
  accumulator = default || self[0]
  if default
    self.each do |element|
      accumulator = yield(accumulator, element)
    end
  else
    self.drop(1).each do |element|
      accumulator = yield(accumulator, element)
    end
  end
  puts "all adds up to: "   # just to prove it's this method being
                            # called, not the superclasses...
  p accumulator
end

{% endhighlight %}


Which gives us such fun as:

{% highlight ruby %}
bob.inject() {|a,e| a += e}
# => all adds up to: 21
bob.inject(10) {|a,e| a += e}
# => all adds up to: 31
bob.inject([]) {|a,e| a << e**2}
# => all adds up to: [1, 4, 9, 16, 25, 36]
bob.inject({}) {|a,e| a[e] = "x"*e; a}
# => {5=>"xxxxx", 6=>"xxxxxx", 1=>"x", 2=>"xx", 3=>"xxx", 4=>"xxxx"}
{% endhighlight %}

I relied on `#each` here, but we could easily write an `each` method using
a `for... in...` loop or similar. The genius is in `yield`, which is the *real
magic* that's going on here.

[Ruby Monk][RubyMonk] has more about the [magic of yield][yield], and why it's
weird in a language that professes that everything is an object. Like a lot in
Ruby, I discovered a small thing didn't work, patiently played with it until
I found out why, and then 'worked' that small new piece of knowledge to give me
greater insight into what was going on. I'm finding this to be the most
satisfying method to learn by, both because it makes me feel like I'm learning
to a deeper degree than I would by just reading the answers out of a book, and
in addition, when the books do cover the subject, I can better apply what's
written there to what I've seen in action.

[RubyMonk]: https://rubymonk.com/
[RMHashMap]: https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/44-collections/lessons/98-iterate-filtrate-and-transform#solution4313
[lastpost]: {% post_url 2014-07-12-destructuring %}
[yield]: http://rubymonk.com/learning/books/1/chapters/34-lambdas-and-blocks-in-ruby/lessons/78-blocks-in-ruby
[reification]: http://en.wikipedia.org/wiki/Reification_(fallacy)
