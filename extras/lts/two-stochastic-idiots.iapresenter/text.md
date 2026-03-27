##### Multi-Agent AI
# Two Stochastic Idiots Are Better Than One

A lightning talk about getting AI agents to supervise each other — and why it works.

/assets/dumb-and-dumber.jpg background: true

---

### Two AI agents working together produce better results than one working alone.
	Not because they're smarter. Because they correct each other.

I'm not talking about anything clever. I'm talking about one agent writing code and another one nagging it to rebase.

And it works. Unreasonably well.

---

### The Problem
	"I should be more disciplined"

/assets/motivator.jpg xsize: contain
: right

I was using an AI agent to write code. Good agent. Smart agent. Probably Opus according to my usage stats from James. But it could not remember to rebase/test/commit. Every single time — it forgot.

I asked the AI how to fix this. Its answer? "I should be more disciplined."

My process thinking hat went on. That's not a solution. That's a wish. Sure, there's no way to _guarantee_ someone follows a rule correctly — [Wittgenstein][wittgenstein] will tell you that — but it doesn't mean we shouldn't try to make it _easier_ to comply.

What I wanted was basically me, popping in every few minutes, shouting "REBASE. TEST. COMMIT."

---

### Why Discipline Can't Work
	It's not laziness. It's physics.

The instruction to "rebase, test, commit" goes in at the top of the context window. Then the agent starts working. Tool calls. Code. Errors. Retries. Output accumulates — thousands of tokens of it.

That early instruction doesn't disappear. It just gets drowned. The model attends to recent tokens far more than distant ones. Your behavioural rule is still technically *in* the context. It has no power.

Then the context fills up. Compaction kicks in. The agent summarises what came before — and a high-level instruction like "always rebase" is exactly the kind of thing that gets collapsed into nothing.

You're not dealing with a forgetful employee. You're dealing with an architecture that structurally cannot hold early instructions at full weight indefinitely. Discipline isn't a solution. It's a category error.

---

### The Accident
	Finding `hcom`

I was browsing a repo of extensions for [OpenCode] — my coding agent — and stumbled on [`hcom`][hcom]. A tool for making AI agents talk to each other.

That was what I needed. A second agent. A supervisor. One whose entire job is to shout "REBASE. TEST. COMMIT."

But once you have a supervisor, the options open up. Maybe _it_ holds the big plan. Maybe the worker just executes small pieces, and the supervisor gives feedback — as well as yammering on about commit discipline.

So that's what I did. And it worked.

---

### Why Does It Work?
	First intuition — the dice

/assets/dice.jpg x: right

Roll one die. You get a 3. Or a 6. Or a 1. Wildly variable.

Roll a hundred dice, take the average. You get something close to 3.5. Every time.

[Central Limit Theorem][clt]. More samples, less variance. Simple enough.

But that's not actually what's happening here. The real mechanism is better.

---

### Not Averaging — Correcting
	The thermostat

/assets/thermostat.jpg x: right

A thermostat doesn't average temperature readings and hope for the best. It _measures_, _compares_ to a target, and _acts_ to close the gap.

That's a closed-loop feedback system. Errors get corrected, not accumulated.

Two agents talking to each other _are_ a feedback loop. The supervisor reads the worker's output. If it's drifting, it says so. The worker adjusts.

One agent alone is an open loop. No feedback. No correction. Just vibes.

---
/assets/feedback-loop.svg
size: contain
### The Actor-Critic Pattern
	Discovered twenty-five years ago


Like all great patterns, this one already existed. [Konda and Tsitsiklis][konda-1999] formalised it in 1999:

- The **actor** decides what to do — the _policy_
- The **critic** evaluates how good that decision was — the _value function_

The actor proposes. The critic appraises. The actor learns from the appraisal.

Worker = actor. Supervisor = critic. We reinvented [reinforcement learning][wiki-ac] by accident.

---

### Not Foolproof
	Does the supervisor need a supervisor?

Sometimes the supervisor gets off track. Forgets it's not meant to be _implementing_. Starts writing code instead of reviewing it.

Does it need its own supervisor? Infinite regress, each layer approaching but never reaching perfection...

For the most part though — it works. The supervisor stays on task. The worker stays disciplined. The code gets rebased, tested, and committed.

Needs to be codified. Turned into a repeatable skill. But the pattern is sound.

---

### Two Idiots > One Genius
	The punchline

Neither agent is brilliant. The worker makes mistakes. The supervisor misses things. Individually, they're stochastic idiots.

But together — with a feedback loop between them — errors get caught, discipline holds, and the output converges on something better than either could produce alone.

Not because they're averaging out noise. Because they're _correcting_ each other.

Two stochastic idiots. One closed loop. Zero babysitting.

---

# Questions?

[konda-1999]: https://proceedings.neurips.cc/paper/1999/file/6449f44a102fde848669bdd9eb6b76fa-Paper.pdf "Konda & Tsitsiklis (1999). Actor-Critic Algorithms. NeurIPS 12."
[wiki-ac]: https://en.wikipedia.org/wiki/Actor-critic_algorithm "Actor-critic algorithm — Wikipedia"
[hcom]: https://github.com/aannoo/hcom "hcom — multi-agent communication for AI coding agents"
[OpenCode]: https://opencode.ai "OpenCode — AI coding agent"
[clt]: https://en.wikipedia.org/wiki/Central_limit_theorem "Central limit theorem — Wikipedia"
[wittgenstein]: https://en.wikipedia.org/wiki/Rule_following "Rule-following — Wikipedia (Wittgenstein, Philosophical Investigations §185–242)"
