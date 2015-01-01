---
layout: post
title: "Evaluating Ruby in Vim"
date: 2015-01-01 21:28:04
tags:
    - Ruby
    - Vim
published: true
---

I was watching [Avdi Grimm]'s [Ruby Tapas] videos - well, trying to watch them.
I got stuck when I saw him do something in Vim that I'd not seen before.
Something magical.

On screen he had an expression - something like this:

```ruby
p = Point.new(2,3)
```

In one keypress it became:

```ruby
p = Point.new(2,3) # =>
```

And then quick as a flash:

```ruby
p = Point.new(3,5) # => #<Point:0x000000038862d0 @x=3 @y=5>
```

I immediately stopped paying attention to the [excellent video about
constructors] and started to look up what was going on.
So here we go down the Vim rabbit hole again...

The magic is performed by either [rcodetools]' xmpfilter tool or
[seeing\_is\_believing], hooked up to Vim via [vim-ruby-xmpfilter], (which works
for both) or [vim-seeing-is-believing]. Take your pick as I can't really see the
difference at the moment.

I've got xmpfilter set up with the following in my `.vimrc`

```vim
autocmd FileType ruby nmap <buffer> <F4> <Plug>(xmpfilter-mark)
autocmd FileType ruby xmap <buffer> <F4> <Plug>(xmpfilter-mark)
autocmd FileType ruby imap <buffer> <F4> <Plug>(xmpfilter-mark)

autocmd FileType ruby nmap <buffer> <F5> <Plug>(xmpfilter-run)
autocmd FileType ruby xmap <buffer> <F5> <Plug>(xmpfilter-run)
autocmd FileType ruby imap <buffer> <F5> <Plug>(xmpfilter-run)
```

Now you too can evaluate Ruby code on the fly in Vim. And I can get back to
watching more of Avdi.

[Avdi Grimm]: https://twitter.com/avdi
[excellent video about constructors]: http://www.rubytapas.com/episodes/7-Constructors?filter=free
[rcodetools]: http://rubygems.org/gems/rcodetools
[Ruby Tapas]: http://www.rubytapas.com/
[seeing\_is\_believing]: https://github.com/JoshCheek/seeing_is_believing
[vim-ruby-xmpfilter]: https://github.com/t9md/vim-ruby-xmpfilter
[vim-seeing-is-believing]: https://github.com/hwartig/vim-seeing-is-believing
