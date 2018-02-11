---
layout: post
title: "Environmentalism"
date: 2014-09-12 20:17:05
tags:
    - Makers Academy
    - Learnings
    - Sinatra
    - Heroku
published: true
---

I've never really seen the point of environment variables until today. They've
been slowly introduced into the syllabus at Makers during the bookmark manager
project. To start with they were a way determine which database to use; whether
the one for the test suite or the one for playing around on the local server.

Something like

```ruby
env = ENV["RACK_ENV"] || "development" DataMapper.setup(:default,
"postgres://localhost/bookmark_manager_#{env}")
 ```

Which is all well and good. Then it comes to getting the app up - let's say on
Heroku.

Heroku has PostgreSQL support, so that's taken care of by adding a plugin on the
dashboard. Tick. Pushing the application to Heroku is easy enough (as long as
you haven't spelled `Gemfile` in all caps at any point in your Git history. Who
would do that?). But then you hit the buffers, because the database isn't where
you've told Sinatra it is.

So where is it? Hiding somewhere over at Amazon apparently. If you run `heroku
config` you'll see a great (OK, tiny) stack of... you guessed it... environment
variables. The two key ones to look at are `DATABASE_URL` and
`HEROKU_POSTGRES_PINK_URL`. Next to them both is a long URL that lets you know
that the nice folks at Amazon are taking care of your instance of Postgres on
the behalf of Heroku.

So we just jam that URL into the DataMapper setup right?

```
ruby DataMapper.setup(:default,
"postgres://whole-mess-of-letters.compute-1.amazonaws:porty_goodness_here")
```

Wrong. That URL is a magic number, it's specific to the Heroku server you're
pushing to. But what about James? What about Vincent? Maybe they want to have an
instance of their own. Or what if Heroku go and migrate your database to another
cloud supplier? Bad times.

Environment variables to the rescue. Look, it's right there in the config:
`DATABASE_URL`. Just jam that sucker into the DataMapper setup. Of course, you
need to make sure that you're using it in Heroku, so maybe some sort of `if`
statement to make sure you're using it in the right place. Not pretty, but...

```ruby
if env.include?(/heroku/)
    DataMapper.setup(:default, ENV["DATABASE_URL"])
else
    DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
end
```

Environment variables. No longer a 'nice to have'.
