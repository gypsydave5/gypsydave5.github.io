##### Multi-Agent AI
# Two Stochastic Idiots Are Better Than One
Why a supervisor and a worker outperform a single agent working alone.



---

### The Intuition
	Roll the dice

You roll one die. You get a 3. Or a 6. Or a 1. Wildly variable.

You roll a hundred dice and take the average. You get something close to 3.5. Every time.

This is the Central Limit Theorem. More samples, less variance, better estimates. Simple enough.

But here's the thing: that's not actually what's happening when two agents collaborate. The real mechanism is more interesting.

---

### Not Averaging -- Correcting
	Closed-loop feedback

A thermostat doesn't average the temperature readings and hope for the best. It _measures_, _compares_ to a target, and _acts_ to close the gap.

That's a closed-loop feedback system. The output feeds back into the input. Errors get corrected rather than accumulated.

Two agents talking to each other are a feedback loop. The supervisor reads the worker's output. If it's drifting, the supervisor says so. The worker adjusts. The error doesn't compound -- it gets caught.

One agent working alone is an open loop. No feedback. No correction. Just vibes.

---

### Ensemble Methods
	Multiple weak learners, one strong model

Machine learning figured this out decades ago. A single decision tree is fragile and overfits. But a _forest_ of mediocre trees -- each trained on different data, each making different mistakes -- combines into something far more robust.

Random Forests. Boosting. Bagging. The principle is always the same: diversity of perspective reduces error.

The supervisor and the worker bring different perspectives. The worker is deep in the code -- syntax, types, test output. The supervisor holds the big picture -- architecture, commit discipline, the plan. Different views. Same problem.

---

### Actor-Critic
	A pattern from reinforcement learning

Konda and Tsitsiklis formalised this in 1999. Two components:

- The **actor** decides what to do (the _policy_)
- The **critic** evaluates how good that decision was (the _value function_)

The actor proposes. The critic appraises. The actor learns from the appraisal.

This maps directly onto the worker/supervisor pattern. The worker (actor) writes code, runs tests, makes changes. The supervisor (critic) reviews the output, checks it against the plan, feeds back.

Neither is smart enough alone. Together they converge.

---

### The Actual Problem
	Discipline collapses under cognitive load

When an agent is twenty files deep in a refactor, discipline is the first casualty. Rebase before you test? Forgotten. Test before you commit? Skipped. Separate behaviour from cleanup? Everything lands in one enormous commit.

This isn't a knowledge problem. The agent _knows_ the rules. It just can't hold them in working memory while also reasoning about the code.

Sound familiar? It's the same reason _you_ skip the tests when you're deep in a gnarly bug.

---

### The Supervisor Fixes This
	Big picture context, persistent attention

The supervisor doesn't write code. It maintains context. It watches the worker's output and asks:

- Did you rebase onto the latest master?
- Did you run the tests?
- Is this commit mixing a behaviour change with cleanup?

It's not doing the work. It's doing the _oversight_ that the worker can't do while doing the work. The thermostat, not the boiler.

---

### The Human Benefit
	You stop being the supervisor

Without multi-agent collaboration, _you_ are the supervisor. You're reading every diff, catching every missed test, reminding the agent about commit conventions.

That's exhausting. And you're not even good at it -- you're checking your phone, making tea, context-switching. You're an open loop too.

A dedicated supervisor agent is relentless. It doesn't get bored. It doesn't check Twitter. It reads every line of output and feeds back immediately.

You get to be the _director_ instead. Set the goal, review the result. Skip the babysitting.

---

### Two Idiots > One Genius
	The punchline

Neither agent is brilliant. The worker makes mistakes. The supervisor misses things. Individually, they're stochastic idiots.

But together -- with a feedback loop between them -- errors get caught, discipline holds, and the output converges on something better than either could produce alone.

Not because they're averaging out noise. Because they're _correcting_ each other.

Two stochastic idiots, one closed loop, zero babysitting.

---

# Questions?


