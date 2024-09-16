---
title: Application Scope and Request Scope
description: Or why you don't have a UserId when you start your application
published: true
date: 2024-09-13 10:36:45
tags:
  - web
  - http4k
---

Spring has some concepts that are applicable to all web development. The problem is that usually they’re hidden behind a lot of very Spring-specific stuff.

Take a look at this list of “Bean Scopes” from [the Spring documentation](https://docs.spring.io/spring-framework/reference/core/beans/factory-scopes.html):

In it we read that Spring offers the following “Bean Scopes” for  handling the lifecycle of objects in the application. There are a few different scopes, but I’m mostly interested in the “web application” ones: `request`, `session`, `application` and `websocket`. For the purpose of this post, let’s only talk about `request` and `application` - the other two should nearly explain themselves when we’ve finished.

For the “Application Bean Scope” the documentation says:

> Scopes a single bean definition to the lifecycle of a ServletContext. Only valid in the context of a web-aware Spring ApplicationContext.

Which is wordy, and full of very Spring-y ideas I have no interest in. But, if we get rid of some of the unnecessary and translate the obscure we get to:

> Scopes a single ~bean definition~ object to the lifecycle of a ~ServletContext~ web server.

A “Request Bean Scope” goes from

> Scopes a single bean definition to the lifecycle of a single HTTP request. That is, each HTTP request has its own instance of a bean created off the back of a single bean definition. Only valid in the context of a web-aware Spring ApplicationContext.

to:

> Scopes a single ~bean definition~ object to the lifecycle of a single HTTP request. That is, each HTTP request has its own instance of ~a bean~ an object, created off the back of a ~single bean definition~ class.

Which is all a very long winded way of saying the following:

> Some objects you can have when you have started your application. Other objects you can only have when you get an HTTP request.

Spring makes this quite hard to understand all of this because it bundles up the construction of objects into these bean _things_, and you use an annotation on a class to indicate how and where you would create it. Happily other web libraries are available where one can either create objects with constructors or a data type, where object creation isn’t quite so fraught.

But by making this quite obvious idea in every other web library:

> Some objects you can have when you have started your application. Other objects you can only have when you get an HTTP request.

We can easily forget about it and, worse, gloss over its consequences for dependency management and how to design a web application.

---

Let’s use a concrete example. A web application that from which we can request an article:

```
http://blog.gypsydave5.com/articles/abc123
```

What do we need? Well some sort of repository to get articles out of (let’s not worry about how they get in there):

```kotlin
interface ArticleRepository {
	fun getArticle(articleId: ArticleId): Article
}
```

Maybe a database-backed implementation of the `ArticleRepository`:

```kotlin
class PostgresArticleRepository(connectionPool: ConnectionPool): ArticleRepository {
    fun getArticle(articleId: ArticleId): Article = connectionPool.use { connection ->
        // get an article using the database connection
    }
}
```

And a nice web server / http handler to put it on the internet. We’ll use http4k:

```kotlin
val server : HttpHandler = routes(
    "/articles/{articleId}" bind GET to { request: Request ->
        val articleId = ArticleId.parse(req.path("articleId"))
        val article = articleRepository.getArticle(articleId)
        Response(Status.OK).body(article.toHtml())
    }
)
```

and to tidy up, we can make a nice object for our server which has its dependencies (well, dependency) injected:

```kotlin
class ArticleApp(private val articleRepository: ArticleRepository) : HttpHandler {
    private fun getArticle(request: Request): Response {
        val articleId = ArticleId.parse(req.path("articleId"))
        val article = articleRepository.getArticle(articleId)
        return Response(Status.OK).body(article.toHtml())
    }
    
    private val articleRoutes = routes(
        "/articles/{articleId}" bind GET to ::getArticle
    )
    
    override fun invoke(request: Request): Response = articleRoutes(request)
}
```

This set up hopefully seems really obvious - and that's a good thing. What I want to do now is something you'd never even
think of doing.

What if, for some reason, we wanted our `ArticleRepository` to look like this:

```kotlin
interface OnlyOneArticleRepository {
	fun getArticle(): Article
}
```

So it's a repository that returns just _one_ article. We could implement it like this:

```kotlin
class PostgresOnlyOneArticleRepository(connectionPool: ConnectionPool, articleId: ArticleId): ArticleRepository {
    fun getArticle(): Article = connectionPool.use { connection ->
        // get an article using the database connection and the articleId
    }
}
```
And if we want to use it we'd have to do something like this:

```kotlin
class ArticleApp(private val connectionPool: ConnectionPool) : HttpHandler {
    private fun getArticle(request: Request): Response {
        val articleId = ArticleId.parse(req.path("articleId"))
        val article = PostgresOnlyOneRepository(connectionPool, articleId).getArticle()
        return Response(Status.OK).body(article.toHtml())
    }

    private val articleRoutes = routes(
        "/articles/{articleId}" bind GET to ::getArticle
    )

    override fun invoke(request: Request): Response = articleRoutes(request)
}
```

This should (and does) feel weird to most web developers. Why? Well, we tend to break our web applications up in our heads
into a "set up" bit and an "action" bit. The "set up" usually lines up with starting the application, and is where we build
a some objects which are ready for the "action" bit - which is when the request comes in we call some methods.[^1] 

Messier versions of the above exist. For instance, if you can imagine more arguments need to be extracted from the
request, we could easily consider passing the whole request across in the constructor.

```kotlin
val article = PostgresOnlyOneArticleRepository(connectionPool, request).getArticle()
```

Obviously this screams at us that we're mixing the HTTP concerns with the domain concerns. To avoid this, but also
to avoid the messiness of parsing a lot of objects out of the request, we could build a factory function:

```kotlin
typealias PerRequestOnlyOneArticleRepository = (Request) -> OnlyOneRepository
```

inside it looks like this: 

```kotlin
val perRequestOnlyOneRepo: PerRequestOnlyOneArticleRepository = { request ->
    val articleId = ArticleId.parse(req.path("articleId"))
    
    PostgresOnlyOneArticleRepository(connectionPool, articleId)
}
```

```kotlin
class ArticleApp(private val perRequestOnlyOneArticleRepo: PerRequestOnlyOneArticleRepository) : HttpHandler {
    private fun getArticle(request: Request): Response {
        val articleRepo = perRequestOnlyOneArticleRepo(request)
        val article = articleRepo.getArticle()
        return Response(Status.OK).body(article.toHtml())
    }

    private val articleRoutes = routes(
        "/articles/{articleId}" bind GET to ::getArticle
    )

    override fun invoke(request: Request): Response = articleRoutes(request)
}
```

Much cleaner.

However, we're not solving any problems, we're just moving them around. Somewhere above we're building the whole
application out of the configuration that, and what happens there is...

```kotlin
val connectionPool = PGConnectionPool(port, url, connectionInfo)

val perRequestOnlyOneArticleRepo: PerRequestOnlyOneArticleRepository = { request ->
    val articleId = ArticleId.parse(req.path("articleId"))

    PostgresOnlyOneArticleRepository(connectionPool, articleId)
}

val app = ArticleApp(perRequestOnlyOneArticleRepo)

app.asServer(Undertow(9000)).start()
```

This doesn't seem like much, but when you're creating multiple dependencies both inside and outside the `PerRequestOnlyOneRepository`
closure, it's very easy to do this:

```kotlin
val perRequestOnlyOneArticleRepo: PerRequestOnlyOneArticleRepository = { request ->
    val connectionPool = PGConnectionPool(port, url, connectionInfo)
    val articleId = ArticleId.parse(req.path("articleId"))

    PostgresOnlyOneArticleRepository(connectionPool, articleId)
}

val app = ArticleApp(perRequestOnlyOneArticleRepo)

app.asServer(Undertow(9000)).start()
```

Which I've seen bring down at least one application in production. A new `connectionPool` is being created on every request,
and pretty soon the database runs out of connections, bringing everything to a grinding halt.

---

Another example, but slightly more understandable, is moving authentication inside the domain. Returning to the more
sane version of our repository:

```kotlin
class PostgresArticleRepository(connectionPool: ConnectionPool): ArticleRepository {
    fun getArticle(articleId: ArticleId): Article = connectionPool.use { connection ->
        // get an article using the database connection
    }
}
```

If we needed to implement authentication and authorization for our repository, we could choose to move an authenticator inside
that returned a `UserId`.

```kotlin
class PostgresArticleRepository(connectionPool: ConnectionPool, authenticator: Authenticator): ArticleRepository {
    fun getArticle(articleId: ArticleId): Article = connectionPool.use { connection ->
        val article = fetch(articleId, connection)
        val user = authenticator.authenticate()
        if (user.allowedToView(article)) article else error("unauthorized")
    }
}
```

But what is the authenticator authenticating? Apparently nothing at all... but it's giving us a nice domain type as a `UserId`.

Somewhere on the outside however...

```kotlin
class Authenticator(userService: UserService, request: Request) {
    fun authenticate() {
        val sessionToken = request.sessionToken
        return userService.getUser(sessionToken)
    }
}
```

This is hugely simplified. And, well, you probably feel like you're a bit safer from coupling your `Repository` to
a request because we're not passing one in the constructor. But look:

```kotlin
val connectionPool = PGConnectionPool(port, url, connectionInfo)

val perRequestArticleRepo: PerRequesArticleRepository = { request ->
    val authenticator = Authenticator(userService, request)
    
    PostgresArticleRepository(connectionPool, authenticator)
}
```

Again, you've got to the same pattern: the dependency on `Request` is transitive.

On top of this, what happens when you want to test the behaviour your `ArticleRepository` when dealing with interactions
with multiple users (for instance: "Bob saves an article, so Mary can't access it")? You'd have to mutate the `Authenticator` between
interactions so that it returns a different user... or only test the `PerRequest` version, and so every test becomes coupled to the HTTP adaptors.

---

You can make this work. You can make _anything_ work - you're a software developer. A few lambdas can easily paper over
a poor design. However, you _will_ find it increasingly hard to extend your application and to test your code: tests that allow an
`Authenticator` with the above design will first become complex, and then become impossible to change because of this complexity
- this _incidental_ complexity that we've inflicted upon ourselves.

The local answer to this particular problem is to let the `ArticleRepository.getArticle()` method take a `UserId` as 
an argument:

```kotlin
class PostgresArticleRepository(connectionPool: ConnectionPool): ArticleRepository {
    fun getArticle(articleId: ArticleId, userId: UserId): Article = connectionPool.use { connection ->
        val article = fetch(articleId, connection)
        if (userId.allowedToView(article)) article else error("unauthorized")
    }
}
```

The broader principle is to recognise that `UserId` is a _Request Scoped_ object. It should live with other _Request Scoped_ objects, conventionally within the parameters of methods called in a request. If another object depends on a _Request Scoped_ object, it too becomes _Request Scoped_ (because that dependency is transitive).

All of those objects share at least one reason to change (a new request came in). Other objects (our connection pool, for
instance) do not share that reason for change. They are _not_ in the _Request Scope_. They are in the _Application Scope_. And
just as the dependency becomes transitive, the reason for change becomes transitive. You do not want to do this.

In the words of Robert Martin, when clarifying his Single Responsibility Principle: 

> Gather together the things that change for the same reasons. Separate those things that change for different reasons.[^2]

So think of it as a special case of the Single Responsibility Principle. Or think about it as keeping request scoped things together. Or just think of it as some special case of mechanical sympathy, engineering your application to fit in with the flow of web servers.

Think of it any way you want, but _please_ think about it, notice it when it's happening, pay attention to your tests and
_don't try and hide it under the carpet with a lambda_.



[^1]: That's written with object-oriented programming in mind, but the functional equivalent is the same - instead of objects you'd
build some functions, and when a request comes in you'd call the functions
[^2]: https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html


