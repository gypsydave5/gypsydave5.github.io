# Two Stochastic Idiots Are Better Than One — Rough Notes

The hook: I got tired of telling my "author" agent to remember to
rebase/test/commit on every change. No matter what — it forgot. Asking
the AI how to fix it, it just said "I should be more disciplined" which,
my process thinking hat on, is just stupid. Sure, there's no way to
guarantee that someone will follow a rule correctly (see Wittgenstein),
but that doesn't mean that we shouldn't try to find ways to make it
easier (or harder not) to comply correctly.

I thought what I needed was something very similar to me just popping in
every commit and shouting rebase/test/commit.

So I found hcom accidentally when looking at a repo of extensions for
opencode. And this seemed to be what I wanted. But now I had a
"supervisor" model, the options seemed to open up a bit. Maybe _it_
could hold the "big plan" and the "worker" could just execute small
bits, with the "supervisor" giving feedback — as well as yammering on
about rebase/test/commit.

And so that's what I did, and it worked.

The first way I thought of this — the dice example, CLT.

The second — the thermostat.

But like all great patterns, it had already been discovered about more
than twenty years ago — the actor-critic pattern (link to paper,
wikipedia).

Not fool proof — the supervisor sometimes gets off track and forgets
it's not meant to be implementing (does it need a supervisor? Infinite
regress approaching perfection...), but for the most part I think this
works. Needs to be codified in an opencode skill.

Questions.
