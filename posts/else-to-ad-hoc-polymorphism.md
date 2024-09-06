---
title: Replace `when` with Function Overloading
description: Need a Union in Kotlin? Try this.
published: true
date: 2024-09-06 22:52:55
tags:
- kotlin
- patterns
---

Sometimes I want a Union type of two types in Kotlin - but I can’t. Kotlin has no Union type.

Usually this can be avoided, if you have control over your types, with a [Sealed Class](https://kotlinlang.org/docs/sealed-classes.html). But if your type hierarchy has to be open, you don’t have that option.

An example I had recently. We initialise two sorts of [Http4k](https://www.http4k.org/) web application at work: ones built using Http4k’s built in routing (a [`RoutingHttpHandler`](https://www.http4k.org/api/org.http4k.routing/-routing-http-handler/)) and ones built using [Krouton](https://github.com/npryce/krouton) (a [`ResourceRouter`](https://github.com/npryce/krouton/blob/master/src/main/kotlin/com/natpryce/krouton/http4k/routing.kt#L58)).

Both of these types implement the `HttpHandler` interface.

When we bootstrap the app, we need to add observability to the routers provided, recording things like the request method and - yes - the path routed to. And we need to add observability to both of the router types.

The natural response would be, as we can’t have a Sealed Class of these two routers (as we don’t own either of the types), a type that represents their union - `RoutingHttpHandler | ResourceRouter` in Scala or similar languages. 

```kotlin
fun createHttp4kHandler(
        applicationHandler: RoutingHttpHandler | ResourceRouter,
    ): HttpHandler {
        val filters = OpenTelemetryFilters.server(openTelemetry)
            .then(statsDMetricsFilters.server)
            .then(prometheusMetricsFilters.server)
            .then(IncomingRequestMonitoringFilter(httpMonitor, logging, clock))

        return when (applicationHandler) {
            is RoutingHttpHandler -> routes(
                AppAnatomyHttp4kHandlers.create(collectorRegistry),
                filters.then(applicationHandler),
            )

            is ResourceRouter -> AppAnatomyHttp4kHandlers.kroutons(collectorRegistry)
                .apply { otherwise(applicationHandler.withFilterIncludingHandlerIfNoMatch(filters)) }
                .toHandler()
        }
    }
```

But this isn’t a feature available in Kotlin.

The alternative, keeping the same pattern, would be to use a shared type for both - `HttpHandler` and then downcast with a type switch again:

```kotlin
fun createHttp4kHandler(
        applicationHandler: HttpHandler,
    ): HttpHandler {
        val filters = OpenTelemetryFilters.server(openTelemetry)
            .then(statsDMetricsFilters.server)
            .then(prometheusMetricsFilters.server)
            .then(IncomingRequestMonitoringFilter(httpMonitor, logging, clock))

        return when (applicationHandler) {
            is RoutingHttpHandler -> routes(
                AppAnatomyHttp4kHandlers.create(collectorRegistry),
                filters.then(applicationHandler),
            )

            is ResourceRouter -> AppAnatomyHttp4kHandlers.kroutons(collectorRegistry)
                .apply { otherwise(applicationHandler.withFilterIncludingHandlerIfNoMatch(filters)) }
                .toHandler()

            else -> error("Unsupported application handler type: ${applicationHandler::class}. You must either use http4k routing, or krouton.")
        }
    }
```

The problem here is that we lose some helpful type safety: I don’t want to be able to accept a `HttpHandler` - that will cause an error and problems (hence the `error` in the else branch). Problems that will only show themselves when the program runs.

(I’ve also seen attempts to create ad-hoc “wrapper” sealed classes around these missing unions; it adds a lot of extra types and noise to the system. I dislike it so much that I’m not even going to put the example in, it’s left as an exercise for the reader.)

The solution which I’ve used a few times now (so I guess it’s a pattern) is to replace the open-ended type switch with [ad-hoc polymorphism](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism) - [function overloading](https://en.wikipedia.org/wiki/Function_overloading):


```kotlin
    internal fun createHttp4kHandler(
        applicationHandler: ResourceRouter,
    ): HttpHandler {
        val filters = OpenTelemetryFilters.server(openTelemetry)
            .then(statsDMetricsFilters.server)
            .then(prometheusMetricsFilters.server)
            .then(IncomingRequestMonitoringFilter(httpMonitor, logging, clock))

        return AppAnatomyHttp4kHandlers.kroutons(collectorRegistry)
            .apply { otherwise(applicationHandler.withFilterIncludingHandlerIfNoMatch(filters)) }
            .toHandler()
    }

    internal fun createHttp4kHandler(
        applicationHandler: RoutingHttpHandler,
    ): HttpHandler {
        val filters = OpenTelemetryFilters.server(openTelemetry)
            .then(statsDMetricsFilters.server)
            .then(prometheusMetricsFilters.server)
            .then(IncomingRequestMonitoringFilter(httpMonitor, logging, clock))

        return routes(
            AppAnatomyHttp4kHandlers.create(collectorRegistry),
            filters.then(applicationHandler),
        )
    }
```

(The duplicated `filters` logic can by extracted easily, I’ve left it there to make the comparison easier).

Here the overload creates an ad-hoc union between `RoutingHttpHandler` and `ResourceRouter` at the call sites of `createHttp4kHandler`. We maintain type safety and avoid an `else` - can’t use this union elsewhere in the code (and perhaps we’d refactor to some wrapper sealed class later if this concept turns out to be less ad-hoc and more useful).