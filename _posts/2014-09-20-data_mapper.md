---
layout: post
title: "Data Mapper Woes"
date: 2014-09-20 20:27:05
tags: [Makers Academy]
categories: Makers
published: true
---

I love [DataMapper](http://datamapper.org/), the lightweight Object Relational
Mapper for Ruby. We've been using it with Sinatra. It's skinny, it's simple,
it's clever, it makes the right tables happen in Postgres and the syntax is
surprisingly simple. For instance, the email field for a user table:

```ruby
property :email, unique: true, required: true, format: email_address
```

Look! It's amazing -- not only do we set the property, but we've made it
required and unique, and we've validated that it's an email address. Amazing!

I love it, but like all wonderful DSLs when it's good it's very very good, but
when it's bad it's _horrid_.

In the example I was working on I was creating a user which could be associated
with many posts - it was a basic Twitter like app. The user had some
requirements as above - specifically those listed for the email, but also that
the user name was unique and that the password was more than six characters
long. So far so incredibly boring.

I set the wheels in motion, I write a feature test in Cucumber to see if as
a user, when logged in, and I create a new post, then the post count goes up by
one (I like speaking in Gherkin). Everything looked OK - but the post wasn't
saving. And there were no useful error messages.

[Alex Peattie](http://alexpeattie.com/) is a hero. He's left Makers now, but
before he did he hacked through what was going on with my problem. And I mean
hacked in the manner of destroying briar patches and slaying dragons - my mouth
dropped in awe as he systematically got to the source of the problem ("So, let's
force it to save...  it saves the post fine, but doesn't update the user...
hmmm..."), then started dropping `puts` into the DataMapper source code after
identifying the problematic lines in the backtrace.

As it turns out, it was the password length that was the problem. As the User
was being updated with the new post it it is being associated with, the password
requirement (6 letters or more) was kicking in -- even when no password was
being submitted with the update. So the post was fine - just the user didn't,
and so prevented the post from saving.

Simple to fix (just tell the user model to only validate password length on
creation), but difficult to identify. I won't make that mistake again, but Alex
remains my hero for sorting that out (and giving a great demonstration
debugging). [We all miss him](http://alex-farewell-card.herokuapp.com/).


