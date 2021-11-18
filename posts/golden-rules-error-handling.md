---
title: 'Golden Rules: How To Handle Errors?'
description: enough about bits to make you a bit dangerous
published: false
date: 2019-07-12 22:52:55
tags:
- errors
- exceptions
- javascript
- golang
---

## Is this exception exceptional?

Ask yourself - is this exception exceptional? Is it something that should only
happen when something is horribly wrong, like when you cannot connect to the
internet? Or is it something that you would expect to happen sometimes, like a user
has entered an invalid date?

Exceptions should be _exceptional_, I'd really consider trying to move scenarios
for errors which you can easily anticipate and handle out of the "exception"
control flow and back into normal code. Save the exceptions for ... well,
exceptions!

## Throw Once, Log Once, Handle Once

Accumulating messages in "new" errors is OK, and can provide context: "For want 
of a nail, the shoe was lost...""

