---
title: SRAPI Specifications: Fast and Right
description: How we did SRAPI
published: false
date: 2022-09-28 16:55:04
tags:

---

## Abstract

The SRAPI team delivered a high quality and fully tested service in a very short amount of time. But how? We explore how the use of specification tests (aka contract tests) affect the workflow of London-style TDD, producing faster code that explores the problem domain earlier, while providing confidence in the behaviour of external dependencies that goes far beyond that available in the type system.

We will describe the construction of SRAPI with commentary.

## What is SRAPI

The Settlements Reporting API...

## 1. Baby Steps

First step - define the API. While I personally have an issue with writing my API documentation before I've written any code (how do I know I can write that API until I've written the code), this was by and far the largest chunk of work at the beginning for me. The rest of the team worked on getting the walking skeleton to stand up, and defining the types of event we would be working with in the schema registry.

Boring work, all in all. 

## 2. Outside In - and Through

Then we started work on providing something on that API we'd defined so carefully; a bit of hardcoded, dummy data that we could assert on, and that our downstream consumers could (eventually) start using at least as a stub to confirm that all the networking was in place and working for them.

And so we started.

First we wrote a test - of course. A very simple acceptance level test that declared that, if we made a request for all the settlements for a particular store (through its `store_id`), then we'd get back an expected hardcoded response. We didn't go so far as to define the specific data types at this point - the `store_id` was `"Pepper"` and the settlements were `"Hello, Pepper!"` for... historical reasons. But we didn't write this test in a simplistic way - we actually wrote a _domain-driven test_ (also known as a specification) for the idea of getting this hardcoded data:

https://github.com/saltpay/settlements-reporting-api/blob/eeb15ffff9f9831e09a42ac3bae3eafd5e69611e/src/specifications/settlements.go

```go
package specifications

import (
	"context"
	"testing"

	"github.com/alecthomas/assert/v2"
)

type SettlementsSystemDriver interface {
	SettlementsByStoreID(ctx context.Context, storeID string) (settlements string, err error)
}

type Settlements struct {
	Subject     SettlementsSystemDriver
	MakeContext func(tb testing.TB) context.Context
}

func (s Settlements) Test(t *testing.T) {
	t.Helper()

	t.Run("gets settlements by store ID", func(t *testing.T) {
		ctx := s.MakeContext(t)
		settlements, err := s.Subject.SettlementsByStoreID(ctx, "Pepper")
		assert.NoError(t, err)
		assert.Equal(t, "Hello, Pepper!", settlements)
	})
}
```

The way I think of this sort of test is that it abstracts away the incidental parts of our software (HTTP, Databases, Kafka), and tries to talk about the "truth" of what's going on within a domain (in this case, the domain of settlements reporting). And what's going on in this test is this: given I ask for the settlements for the Store with the ID of umm... `"Pepper"`, then I should get back the expected settlements: `"Hello, Pepper!"`.

But these abstract ideas - you can think of it as a "what" - are useless unless they're brought into contact with reality - the "how". That's what the `SettlementsSystemDriver` interface is all about. It is the interface for the idealised SRAPI system - at the moment, just a way of getting settlements by `storeID`. What we need to do is bring the real world into contact with the idea world by adapting it to meet this interface. And so we have an implementation of the `SettlementsSystemDriver` that communicates over HTTP:

https://github.com/saltpay/settlements-reporting-api/blob/eeb15ffff9f9831e09a42ac3bae3eafd5e69611e/black-box-tests/acceptance/api_driver.go

```go
package acceptance

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/saltpay/go-o11y/tracing/tracingtesting"
)

type SettlementsAPIClient struct {
	baseURL    string
	httpClient *http.Client
	logger     APIClientLogger
}


func NewSettlementsAPIClient(transport http.RoundTripper, baseURL string, logger APIClientLogger) *SettlementsAPIClient {
	return &SettlementsAPIClient{
		baseURL:    baseURL,
		httpClient: &http.Client{
            Timeout: 5 * time.Second, 
            Transport: tracingtesting.NewTracePropagationRoundTripperMiddleware(transport),
        },
		logger:     logger,
	}
}

func (a *SettlementsAPIClient) SettlementsByStoreID(ctx context.Context, storeID string) (settlements string, err error) {
	url := a.baseURL + "/stores/" + storeID + "/settlements"
	a.logger.Log("GET", url)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return "", fmt.Errorf("could not create request - %w", err)
	}

	res, err := a.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("problem reaching %s, %w", url, err)
	}
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		return "", fmt.Errorf("unexpected status %d from GET %q", res.StatusCode, url)
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return "", err
	}

	return string(body), nil
}

func (a *SettlementsAPIClient) CheckIfHealthy(ctx context.Context) error {
    // code to check if the service is healthy
}

func (a *SettlementsAPIClient) WaitForAPIToBeHealthy(ctx context.Context, retries int) error {
    // code to wait for service to be healthy
}
```

A bit long winded, but not impossible to read. See how, after a lot of HTTP gubbins has been taken care of in both directions, we get back to the simple idea of if I stick this string in (the `storeID`), I get this other string out (the "settlements").

We bring Specification and the Driver together (heaven and earth, the ideal and the real, the yin and the yang... I could go on) in the executable test file:

https://github.com/saltpay/settlements-reporting-api/blob/eeb15ffff9f9831e09a42ac3bae3eafd5e69611e/black-box-tests/acceptance/api_test.go

```go
package acceptance

import (
	"context"
	"net/http"
	"testing"

	"github.com/saltpay/go-o11y/tracing/tracingtesting"

	"github.com/saltpay/settlements-reporting-api/src/specifications"

	"github.com/alecthomas/assert/v2"
)

const fiveRetries = 5

func TestSettlementsReportingApplication(t *testing.T) {
	config, err := loadTestingConfig()
	assert.NoError(t, err)

	client := NewSettlementsAPIClient(http.DefaultTransport, config.BaseURL, t)

	if err := client.WaitForAPIToBeHealthy(context.Background(), fiveRetries); err != nil {
		t.Fatal(err)
	}

	t.Run("api can do greetings", func(t *testing.T) {
		specifications.Settlements{
			Subject: client,
			MakeContext: func(tb testing.TB) context.Context {
				ctx, traceID := tracingtesting.NewContext()
				tb.Log("traceID", traceID)
				return ctx
			},
		}.Test(t)
	})
}
```

The `specifications.Settlements` struct takes our client - the `Driver` - as its `Subject`. It will use this test subject to run its tests against when you call the `Test(t)` method on it. It really is that simple.

But wait, I hear you say. This is a lot of work for very little payback at this point. Why bother? Why not write an acceptance test - something that looks like the `Driver` above but with some assertions in it?

Firstly, was it that much more work? Conceptually, I'll grant you, the ideas are bigger - this is not something you might be used to. But the actual code is almost identical - it just lives in more than one place. And the pay off... well, we'll see.

Then we added the hardcoded response body directly into a handler in the walking skeleton:

https://github.com/saltpay/settlements-reporting-api/blob/eeb15ffff9f9831e09a42ac3bae3eafd5e69611e/src/adapters/httpserver/settlementshandler/settlements_handler.go#L29-L31

Tests passing, we continued on our merry way. In this case, our plan was to take that hardcoded data currently in the handler and use it like a spearhead - defining it further and further through the layers of the system, and by doing so forcing ourselves to build the different objects that we will need.

And so to the "service" layer, the home of the "domain", the business logic - the purest definition of our application's logic. In terms of DDD and the ports+adapters architecture, this is the _thing_ we're adapting to.

So we initially write a simple unit test:

https://github.com/saltpay/settlements-reporting-api/blob/1a32a85886c215e2bb9929ed28cc017295e59baf/src/domain/settlements/service_test.go
```go
package settlements_test

import (
	"context"
	"testing"

	"github.com/alecthomas/assert/v2"

	"github.com/saltpay/settlements-reporting-api/src/domain/settlements"
)

func TestService_SettlementsByStoreID(t *testing.T) {
	t.Run("it returns a hardcoded settlement", func(t *testing.T) {
		s := settlements.NewService()
		settlements, err := s.SettlementsByStoreID(context.Background(), "garbage")
		assert.NoError(t, err)
		assert.Equal(t, "Hello, Pepper!", settlements)
	})
}
```

and using that we drive the "data" down to the service layer

https://github.com/saltpay/settlements-reporting-api/blob/1a32a85886c215e2bb9929ed28cc017295e59baf/src/domain/settlements/service.go
```go
package settlements

import (
	"context"
)

type Service struct{}

func NewService() *Service {
	return &Service{}
}

func (s *Service) SettlementsByStoreID(ctx context.Context, storeID string) (settlements string, err error) {
	return "Hello, Pepper!", nil
}
```

and with the right wiring we keep the "acceptance" test passing.

Software development like this often feels like a choose your own adventure book. There are a few solid paths we can take here, all of which need doing at some point:

1. Continue our journey down through the depths and push the hardcoded settlement into some sort of repository object to store it
2. Stop messing around with strings and define an actual `Settlement` type that has data in it as defined in our API specification

We'd get more value from (2) - it would be nice to be able to deliver some value to our client, even if it's just a hardcoded piece of stub data. Also, as we push through and explore the system, we're going to get closer and closer to defining how our events will become settlements - and that's going to need a real idea of what a settlement looks like.

But hindsight is 20:20: we went with (1) ever so quickly and christened a Settlements Service, which would be in charge of returning the settlements we were asking for. Here's the one and only unit test for it at this point:


```go
func TestService_SettlementsByStoreID(t *testing.T) {
	t.Run("it returns a hardcoded settlement", func(t *testing.T) {
		s := settlements.NewService()
		settlements, err := s.SettlementsByStoreID(context.Background(), "garbage")
		assert.NoError(t, err)
		assert.Equal(t, "Hello, Pepper!", settlements)
	})
}
```
https://github.com/saltpay/settlements-reporting-api/blob/1a32a85886c215e2bb9929ed28cc017295e59baf/src/domain/settlements/service_test.go

Just to assert that it's giving back the hardcoded data; the specification test confirms that it's all wired up.

And so then we defined a `Settlement` type in our system, and used it in our specification and in our domain code, with a DTO ([data-transfer object](https://en.wikipedia.org/wiki/Data_transfer_object)) type inside the HTTP adapter representing the collection of settlements and some transfer metadata around pagination.

Here's the (not massively different) test:
```go
func (s Settlements) Test(t *testing.T) {
	t.Helper()

	t.Run("gets s by store ID", func(t *testing.T) {
		ctx := s.MakeContext(t)
		settlements, err := s.Subject.SettlementsByStoreID(ctx, "Pepper")
		assert.NoError(t, err)
		assert.Equal(t, &stl.HardcodedSettlements, settlements)
	})
}
```
https://github.com/saltpay/settlements-reporting-api/blob/8143512d8c37348eef6491c279308a8c27766ddb/src/specifications/settlements.go


And here's the type for a Settlement in our domain code:[^2]

```go
type Payment struct {
	PaidAt      time.Time
	ReferenceID string
	IBAN        string
}

type Amount struct {
	Currency    string
	GrossAmount string
	NetAmount   string
	FeesAmount  string
}

type Settlement struct {
	ID                 string
	SettlementRaisedAt time.Time
	StoreID            string
	Amount             Amount
	Payment            Payment
	Status             string
}
```

---

<!--------->
<!-- I'd want this bit to be in like an inset or something? -->
<!--------->

#### Tiny Regrets

My biggest regret at this point is not making a "tiny type" (a very small [value object](https://martinfowler.com/bliki/ValueObject.html)) for both the `storeID` and the `id` of the settlement. Why? Because at this point  we were happily flinging strings around for both of these things. I knew that they were UUIDs, and that _maybe_ it would be good to get some type safety around that idea at some point. But it would also be good not to worry about it for now, and delay that decision.

But we _had_ decided. Using a `string` directly for those types built up debt across the system - every time we used a string for one of those IDs we were reinforcing an implicit decision that they were strings. So later when we came to decide that they were really UUIDs we had a painful time ripping through a lot of code, changing one type to another in dozens of places.

The tiny type would have _encapsulated our deferred decision_ - inside the type we could have had a string (or a UUID, or an int - or whatever) as the underlying representation. But the rest of the program would not have that information - it would just have a `StoreID` type to deal with. Then, when we made a decision (or changed our minds again and again), that change would be isolated _inside_ our `StoreID` type, and not spread throughout the code.

My two takeaways here would be: use tiny types early, and _definitely_ use them if you're deferring a decision to a later date.

To me, this idea of "deferring" something - a decision, a function binding to a type, the writing of a concrete type - is the core of what makes object-oriented programming flow so well, both in terms of running it and writing it.

---

 <!--
 This should bit should also be inset somewhere
 -->
 

---
#### Hey, you got domain types in my acceptance tests!

So now we have a `Settlement` type. But where does that live? Obviously inside the "domain" of our application - that special protected core that we write adapters to reach. In a ports+adapters architecture you use the adapters to translate the "real world" of things like (HTTP, Kafka, PostgreSQL) into the "ideal world" of our domain. And a key part of this is to make sure that those ideal domain types don't get mixed up into the adapters: you don't want to be looking at your domain code and seeing things like HTTP status code, or database connections.[^1] And so we use those "data-transfer objects" - the DTOs - to represent our domain objects in the context of the adapter.

But what about our tests? Do they fall under the same category as our adaptors, and have their own set of "adapter specific" types to represent the domain? Or do we use the types from the domain again?

This question is a bit of a no-brainer in most test set ups I've worked in: unit tests for the domain use the domain types, obviously, while the acceptance tests - running over HTTP say - would use types specific to HTTP. Obviously.

But when testing with specifications, this can't be the case: we're describing the behaviour of our system _once_, and then applying that to different views of our system - the "inside" view of just the domain objects, all the way out to the "outside" view, working over various transport media like HTTP. So what types do we use in that _one_ test?

Some (OK, me) would say that we should use the domain types again. The specification tests are the description of the "pure" behaviour of the domain we're working in, and we should express the domain _wherever we work with it_ using the same types.

Others would argue, and rightly, that we need to isolate our domain as much as possible. To have our acceptance-level tests depending on the domain types is breaks that encapsuation - the domain is leaking out. We should define types that represent the domain as the domain "in the tests".

Our team chose the second path, which maintained the encapsulation of the domain types at the expense of defining a collection of "test" domain types that shadow the "real" domain types. And so our `Settlement` type in our domain gained its twin inside another package which was used in the specification and the tests. 

But what would you do? If it helps, Einar and Dave Farley are in the second camp, Nat Pryce, Uberto Barbini and myself are in the second camp.

---


(which later used _the same specification_ as our acceptance test https://github.com/saltpay/settlements-reporting-api/blob/9ad40809a1b46179f17fb7ec36ca634d2354364c/src/domain/settlements/service_test.go )

[^1]: Although, like everything in software development, "it depends".

[^2]: OK, I'm being disingenous here: on the first pass, there were no DTO types: we were using the same type in the domain and in the adapters. Not cool, but easily fixed when you fix it early.
