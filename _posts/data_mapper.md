---
layout: post
title: "Data Mapper Woes"
date: 2014-09-09 20:27:05
tags: [Makers Academy]
categories: Makers
published: false
---

I love [DataMapper], the lightweight Object Relational Mapper for Ruby. We've
been using it with Sinatra. It's skinny, it's simple, it's clever, it makes the
right tables happen in Postgres and the syntax is surprisingly simple. For
instance, the email field for a user table:

```ruby
property :email, unique: true, required: true, format: email_address
```

Look! It's amazing -- not only do we set the property, but we've made it
required and unique, and we've validated that it's an email address. Amazing!

I love it, but like all wonderful DSLs when it's good it's very very good, but
when it's bad it's _horrid_.

In the example I was working on

