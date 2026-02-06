##### Cockburn's Mug
# The Incremental and the Iterative
	Two approaches to software development. What's the difference? Why does it matter?

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
### The First Danger
	Being Purely Incremental

Building pieces without asking: "Does the *whole thing* work for users?"

You can perfectly execute a plan for the wrong product.

**Missing: User feedback. Product validation.**

---
### The Second Danger
	Refusing to Increment

"Everything must be a whole, releasable product!"

Sounds iterative. But if iterations last two months:
- Large batches of work
- Long feedback cycles *within the team*
- Integration hell
- Work becomes invisible, ad hoc

**You're still incremental - just with massive, unwieldy increments.**

---
### The Real World
	Iteration Is Often Constrained

https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/ford-factory-hulton-archive.jpg

Sometimes you *can't* ship the scooter or bicycle:
- Regulations require a complete car
- Market won't accept intermediate products
- Technical constraints prevent partial solutions

**The trap:** "Can't iterate? Build the whole car in one go!"

**The reality:** You still choose *how* to work internally.

---
## Three Ways to Build a Car
	When You Can't Release Until It's Complete

You can't iterate with users.

But you can still control your internal process.

---
### Approach 1: Parallel
	Everything At Once

/assets/ParallelCar.png
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
### Approach 3: Steel Thread
	Build the Skeleton First

/assets/SteelThreadCar.png
size: contain

End-to-end structure, then enhance.
- Chassis → Add wheels (it rolls!) → Add body
- Minimal **working system** at each stage
- Learn about the **whole** as you go

---
### Which Is Best?
	It Depends

**Sequential Component:** Clear dependencies, thorough testing. Risk: late integration issues.

**Steel Thread:** Early integration, continuous learning. Risk: may need rebuilding.

**Parallel:** Fast if teams are independent. Risk: Integration hell.

---
### The Hidden Truth
	Work Decomposes Anyway

Humans are sequential. We work on one thing at a time.

**The question isn't IF work gets broken up.**

**The question is WHEN and HOW.**

---
### Choose Your Decomposition
	Or Let It Choose You

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
	Don't Hand Over "Complete User Stories"

The anti-pattern: A "complete" feature as a single story.

What happens:
- Work lasts two months
- Becomes invisible, ad hoc
- Other disciplines excluded
- Questions go unasked
- No fast feedback

**The work disappears into a black box.**

---
### The Solution
	Deliberate Increments

**Can't ship to users every 2 days?** Fine.

**But don't let work vanish for 2 months.**

Break into incremental steps:
- Steel thread first, then layers
- Or complete components, then integrate

**Each step:**
- Analyzed beforehand (questions early)
- Reviewed afterward (all disciplines)
- Progress visible

**Make the process explicit, not ad hoc.**

---
##### Remember
# Iterate to Learn
# Increment to Manage
	Don't let "complete user stories" hide months of invisible work.

Break it down. Review early. Review often.

