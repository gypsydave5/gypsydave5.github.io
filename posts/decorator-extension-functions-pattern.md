---
title: 'Pattern: Decorator extension functions'
description: compose your decorators beautifully
published: true
date: 2024-09-09 22:52:55
tags:
- kotlin
- pattern
- decorator
- http4k
---

The decorator pattern is a good way to extend the behaviour of an object without using inheritance. In some ways it’s _the_ way to get the benefits of code reuse through composition.

But if you use a decorator repeatedly it can get confusing. The website [Refactoring Guru](https://refactoring.guru/design-patterns/decorator) uses the example of a series of different notifier implementations as an example of decorators, which is quite a nice example.[^1]

Here, instead of using inheritance, a `Notifier` is composed by stacking together a series of `Notifier` decorators:

```kotlin
interface Notifier {
    fun notify(message: String)
}

val nullNotifier = object : Notifier { 
    fun notify(message: String) {} // the `nullNotifier` does nothing
}

class EmailNotifierDecorator(
    val notifier: Notifier, 
    val emailClient: EmailClient,
) : Notifier {
  override fun notify(message: String) {
	  emailClient.send(message)
	  notifier.notify(message)
  }
}
```

So you can have an email notifier decorating a `nullDecorator` to build a `Notifier` that sends emails:

```kotlin
val notifier = EmailNotifierDecorator(nullNotifier, EmailClient())
```

And a `SlackNotifierDecorator` for slack notifications:

```kotlin
class SlackNotifierDecorator(
    val notifier: Notifier, 
    val slackClient: SlackClient,
) : Notifier { 
    override fun notify(message: String) { 
        slackClient.send(message)
        notifier.notify(message)
  }
} 

val notifier = SlackNotifierDecorator(nullNotifier, SlackClient())
```

And so on. You can then compose the different notification requirements together by stacking the decorators.

But this soon looks nasty when you perform more than two decorations at a time:

```kotlin
val myNotifier = SlackNotifierDecorator(
    FacebookNotifierDecorator(
        EmailNotifierDecorator(
            nullNotifier, 
            EmailClient()
        ), 
        FacebookClient()
    ), 
    SlackClient(),
)
```

What even is happening here?

A good way to avoid this chaos is to take a leaf out of the functional programming playbook and turn a nested operations into serial operations - something like Clojure’s threading macro, the `.` compose operator in Haskell, `compose` or `andThen` in Scala... you take your pick.


We can do this with our decorators by adding an extension function to each of the decorator’s modules. We can add the extension to the `Notifier` interface perform the decoration in series:

```kotlin
// In practice you'd locate these decorators with their classes and import them as and when you needed them.

fun Notifier.withEmail(emailClient: EmailClient) = 
    EmailNotifierDecorator(this, emailClient)

fun Notifier.withSlack(slackClient: SlackClient) = 
    SlackNotifierDecorator(this, slackClient)

fun Notifier.withFacebook(facebookClient: FacebookClient) = 
    FacebookNotifierDecorator(this, facebookClient)

val myNotifier = nullNotifier
    .withSlack(SlackClient())
    .withEmail(EmailClient())
    .withFacebook(FacebookClient())
```

Which reads a lot better.

### Real World Example

This pattern can be seen in the popular Kotlin HTTP library [http4k](https://www.http4k.org/)’s implementation of filters to transform HTTP request and responses.

A [`Filter`](https://github.com/http4k/http4k/blob/87a98624c4428dc6d9b77a1a9628747363cac9a4/http4k-core/src/main/kotlin/org/http4k/core/Http4k.kt#L7) in http4k is just a decorator around an `HttpHandler`:

```kotlin
fun interface Filter : (HttpHandler) -> HttpHandler
```

If we used these decorators ‘as is’, we’d be presented with the same nesting problem - only worse as you might want to use a lot of `Filter`s.

```kotlin
val myHandler: HttpHandler = { Response(Status.OK) }

val debuggingFilter =
  DebuggingFilters.PrintRequestAndResponse(System.out)

val requestTracingFilter =
  ServerFilters.RequestTracing()

val setContentTypeFilter =
  ServerFilters.SetContentType(ContentType.TEXT_PLAIN)

val openTelemetryFilter =
  ServerFilters.OpenTelemetryTracing

val server = openTelemetryFilter(
    setContentTypeFilter(
        requestTracingFilter(
            debuggingFilter(
                myHandler
            )
        )
    )
)
```

But with a very simple [pair of extension functions](https://github.com/http4k/http4k/blob/87a98624c4428dc6d9b77a1a9628747363cac9a4/http4k-core/src/main/kotlin/org/http4k/core/Http4k.kt#L13-L15):

```kotlin
fun Filter.then(next: Filter): Filter = 
    Filter { this(next(it)) }


fun Filter.then(next: HttpHandler): HttpHandler = 
    this(next)
```

We can turn the nesting into something serial that expresses the flow of the request:

```kotlin
val server = ServerFilters.OpenTelemetryTracing
    .then(ServerFilters.SetContentType(ContentType.TEXT_PLAIN))
    .then(ServerFilters.RequestTracing())
    .then(DebuggingFilters.PrintRequestAndResponse(System.out))
    .then(myHandler)
```

We can see clearly that the open telemetry filter happens _first_, _then_ the content type filter, _then_... etc, until the transformed request reaches the handler.

### Evolution to Final Form

And when even this becomes too repetitive with multiple calls to `then`, we can write ourselves a _real_
compose function to stack up these decorators:

```kotlin
fun stack(vararg filters: Filter): Filter =
    filters.reduce { first, next -> first.then(next) }
```

```kotlin
val server = stack(
    ServerFilters.OpenTelemetryTracing,
    ServerFilters.SetContentType(ContentType.TEXT_PLAIN),
    ServerFilters.RequestTracing(),
    DebuggingFilters.PrintRequestAndResponse(System.out),
).then(myHandler)
```

This is possible for `Filter`s because of their abstract interface of `(HttpHandler) -> HttpHandler`. How can we achieve this with
our `Notifier` decorators?

**WARNING**

I'd recommend stopping here unless you're _really_ interested in how to compose decorators on an industrial scale.
What follows is really an overgrown footnote.

**/WARNING**

If we declare the type of `NotifierDecorator` to be `(Notifier) -> Notifier`:

```kotlin
fun interface NotifierDecorator : (Notifier) -> Notifier
```

We can then implement it in our notifier decorators:

```kotlin
class SlackNotifierDecorator(
    private val slackClient: SlackClient,
) : NotifierDecorator {
    override operator fun invoke(next: Notifier): Notifier = object : Notifier {
        override fun notify(message: String) {
            slackClient.ping(message)
            next.notify(message)
        }
    }
}

class EmailNotifierDecorator(
    private val emailClient: EmailClient,
) : NotifierDecorator {
    override fun invoke(next: Notifier): Notifier = object : Notifier {
        override fun notify(message: String) {
            emailClient.send(message)
            next.notify(message)
        }
    }
}
```

What we have is a pattern that acts like a curried version of our old constructor: instead of `(Notifier, OtherArgs) -> Notifier`
we now have `(OtherArgs) -> (Notifier) -> Notifier` - the last bit of which is our `NotifierDecorator`.

Instead of implementing `Notifier` as a class in these two cases, we're just implementing the interface on an
anonymous object. You were warned.

Now we've got an abstract interface to play with (in the way of a function signature), we can now raise our decoration
game to the same level as http4k's `Filter`s.

First we define a pair of extension functions which should be familiar:

```kotlin
fun NotifierDecorator.then(next: NotifierDecorator): NotifierDecorator =
    NotifierDecorator { notifier: Notifier -> next(this(notifier)) }

fun NotifierDecorator.then(finally: Notifier): Notifier = this(finally)
```

This will give us the `then` behaviour we've already seen:

```kotlin
val notifier = SlackNotifierDecorator2(SlackClient())
    .then(EmailNotifierDecorator2(EmailClient()))
    .then(nullNotifier)
```

With this we never need to write custom extension functions for each new decorator we add - you now
get their composition for free as long as they implement the `NotifierDecorator` interface. This is a big 
benefit in a library like http4k where everyone and anyone might want to extend the library by writing a custom
filter, but you might consider if the complexity is worth it for your own project.

That said, we can now build the 'final form' with a function to compose `NotifierDecorator`s:

```kotlin
fun notifyWith(vararg notifiers: NotifierDecorator) =
    notifiers.reduce { first, next -> first.then(next) }

val notifier = notifyWith(
    SlackNotifierDecorator2(SlackClient()),
    EmailNotifierDecorator2(EmailClient())
).then(nullNotifier)
```

[^1]: Although it’s perhaps not how I’d do notifications.