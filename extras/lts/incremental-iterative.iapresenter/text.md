##### Cockburn's Mug
# The Incremental and the Iterative
	Two approaches to software development. What's the difference? Why does it matter?

---
### To Quote Alistair Cockburn
##### (well, his mug)

	> Incremental means add on to. It helps improve the process.
	> Iterative means revise. It helps improve the product.
Alistair Cockburn put this on a mug: "Incremental supports the process. Iterative supports the product."

---
## Iterative Development
	Supporting the Product
https://jpattonassociates.com/wp-content/uploads/2008/01/iterating.jpg
size: contain

Deliver a *whole, working version* each time.
- Rough sketch → better proportions → refined details
- Always complete, always usable

**Ship it. Learn from users. Improve.**

*Credit: [Jeff Patton](https://jpattonassociates.com/dont_know_what_i_want/)*

---
## Incremental Development
	Supporting the Process
https://jpattonassociates.com/wp-content/uploads/2008/01/incrementing.jpg
size: contain

Deliver *pieces*, assemble at the end.
- Quadrant by quadrant
- Nothing usable until complete
- Requires a unified view at all times

**Break big problems into chunks. Manage complexity.**

*Credit: [Jeff Patton](https://jpattonassociates.com/dont_know_what_i_want/)*

---
### Henrik Kniberg's Classic
	The Ideal: Iterate With Users

https://blog.crisp.se/wp-content/uploads/2016/01/Making-sense-of-MVP-.jpg
size: contain

**Top row (incremental):** Car parts → nothing works until the end

**Bottom row (iterative):** Skateboard → scooter → bike → car

Each iteration delivers *transportation* - the real user need.

---
# The Danger
	Being Purely Incremental

https://images.unsplash.com/photo-1625726411847-8cbb01fcd823?w=800
size: contain

Building pieces without asking: "Does the *whole thing* work for users?"

You can perfectly execute a plan for the wrong product.

**Missing: User feedback. Product validation.**

I think this is the danger we're most used to addressing - at least I am. This is what Kniberg and Patton are arguing against. And they should, they're product people. You should try to work on and  release something that's complete enough for users to use and give you feedback on.

But there is another danger. 

---

/assets/Clipboard.png

---
# The Other Danger
	Being Purely Iterative

https://images.unsplash.com/photo-1625726411847-8cbb01fcd823?w=800

"Everything must be a whole, releasable feature that the user can use!"

Sounds iterative. But if iterations last two months:
- Large batch sizes
- Long feedback cycles *within the team*
- Integration hell
- No sense of progress
- Work becomes invisible, ad hoc

---

### Meanwhile, In The Real World...
	Iteration Is Often Constrained

https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/ford-factory-hulton-archive.jpg

Sometimes you *can't* ship the scooter or bicycle:
- Regulations require a complete car
- Market won't accept intermediate products
- Technical constraints prevent small partial solutions

**The trap:** "Can't iterate? Build the whole car in one go!"

**The reality:** You still choose *how* to work internally.

---
# _Nobody_ builds a car like this
/assets/SequentialComponentCar.png
size: contain

---
## Three Ways to Build a Car
	When You Can't Release Until It's Complete

You can't iterate with users.

But you can still control your process.

---
### Approach 1: Parallel Component
	Everything At Once
/assets/ParallelComponentCar.png
size: contain
All parts advance simultaneously.
- High work-in-progress
- Nothing complete until the end
- **Big bang integration**

---
### Approach 2: Sequential Component
	Finish Each Part First
/assets/SequentialComponentCar.png
size: contain

Complete components, then integrate.
- Wheels finished → Chassis finished → Assembly
- Each deliverable **testable in isolation**
- **Continuous integration**

---
### Approach 3: "Steel Thread"
	Build the Skeleton First
/assets/SteelThreadCar.png
size: contain

End-to-end structure, then enhance.
- Chassis → Add wheels (it rolls!) → Add body
- Integration concerns addressed at every stage
- Minimal **working system** at each stage
- Learn about how to build the **whole** as you go

---
# Which Is Best?
	"It Depends"
	_but probably steel thread_


**Parallel:** Fast if teams are independent. Risk: Integration hell.

**Steel Thread:** Early integration, continuous learning. Risk: may need rebuilding.

I'd favour the steel thread approach, as in my experience  the time spent on fixing late integration issues 

---
### The Hidden Truth
	Work Will Be Broken Down Anyway

Humans are sequential. We work on one thing at a time. We break up problems

**The question isn't IF work gets broken up.**

**The question is WHEN and HOW and by WHO.**

---
### Choose Your How You Break Work Down
	Or It Will Be Chosen For You

**No deliberate breakdown:**
- Decomposition happens invisibly
- No conscious decisions about boundaries
- No reviews until the end

**Deliberate breakdown (Sequential/Steel Thread):**
- Clear, reviewable deliverables
- Regular reflection points
- Questions asked early

**Control the breakdown. Don't let it control you.**

---
## The Practical Takeaway
#### Iterations are the best, but small stories are better.
	- Always try to deliver small iterations
	- If you can't do small iterations, do small increments
	- If you're delivering small increments, prefer a steel thread
	- If you can't deliver small increments, try harder

Don't get me wrong - if you can work on and deliver a single iteration of your product and have it in front of your users in two days _every time_, then - bravo. We should all be aiming for this.

But if you _can't_ get your iterations down to this size, it doesn't mean that we just give up and work with two month long stories. We have to fall back to more incremental techniques - preferably a steel thread, then more of an isolated component approach.

Otherwise we get:

- Work lasts two months
- Becomes invisible, ad hoc
- Other disciplines excluded
- Questions go unasked
- No fast feedback

**The work disappears into a black box.**

---
## The Solution
	Deliberate Increments

**Can't ship to users every 2 days?** Fine.

**But don't let work vanish for 2 months.**

Break into incremental steps:
- Preferably get to steel thread first, layer
- If that's not practicable, complete component, then integrate

**Each step:**
- Analyzed beforehand (questions early)
- Reviewed afterward (all disciplines)
- Progress visible

**Make the process explicit, not ad hoc.**

---
## How do we ensure this?
	Story Mapping and Example Mapping are Useful Tools

Story Mapping and Example Mapping are techniques that should be driving you towards breaking things up into smaller parts - iterable or incremental - at the earliest possible stages of work.

---
## But We Still Have To Think
	There Is No Royal Road, You Have To Work

Even with these techniques, you still have to apply your product brain and your developer brain to think about what can make up an iteration, and what the most sensible way to sequence and break up increments would be. Nothing is ever easy, eh?

---
##### Remember
# Small Iterations to Learn
# Small Increments to Manage
	Don't let your  "complete user stories" hide months of invisible work.

Break it down. Review early. Review often.

