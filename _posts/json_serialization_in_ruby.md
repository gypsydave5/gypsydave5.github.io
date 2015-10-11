---
layout: post
title: "JSON Serialization in Ruby"
date: 2015-08-18 20:39:14
tags:
  - Learnings
  - Ruby
  - JSON
published: false
---

While working on my review of [Text Provessing in Ruby][TPiR] (coming
soon - promise), I encountered a module required that I hadn't seen before:

```ruby
require 'json'
require 'json/add/core'
```

The code was writing to and reading from a JSON string being generated
from a Struct - and the it failed when the second require wasn't
there.

I couldn't find anything in the [Ruby Docs][] when I looked (failure
of search skills no doubt), but I was able to find the
[original GitHub repo][JSONgh] where the JSON module was created

Digging through the file structure `src/json/add/core`, I could see
that [`core.rb`] required all the other files in `/add`. And that
those files were monkey patching a number of the core Ruby classes
with new `to_json` and `json_create` methods. Exciting stuff.

Reading a little further along in the Readme, it became apparent that
these methods were being used as a way of serializing a those core
classes as JSON. Let me try to explain by taking a look at the patched
methods on the Regexp class.

The docs say:
> It's possible to add JSON support serialization to arbitrary classes
> by simply implementing a more specialized version of the #to_json
> method, that should return a JSON object.

And we can see that `to_json` method (called slightly indirectly) here:

```ruby
  def as_json(*)
    {
      JSON.create_id => self.class.name,
      'o'            => options,
      's'            => source,
    }
  end

  def to_json(*)
    as_json.to_json
  end
```

Here the json produced from `to_json` has three properties = `JSON.create_id`

The `(*)` is just soaking up (and ignoring) any arguments sent to both
of the
