##### From Story to Code
# AI-Assisted Analysis
Using a Claude Code skill to facilitate Example Mapping with QA, BA, and PO.

---

### Background: Example Mapping
	A structured analysis technique (Matt Wynne)

- **Story** (yellow): what we're building
- **Rules** (blue): the constraints that govern it
- **Examples** (green): concrete scenarios in Given/When/Then
- **Questions** (red): the things we don't know yet

The goal is to leave the room with agreement rather than assumptions.

---

### The Tool
	`/analyse CSUB-1212`

A Claude Code skill that:

1. Reads the story, parent epic, and sibling stories from Jira
2. Generates a draft Example Map from that context
3. Runs an interactive session with the group — presenting, revising, confirming
4. Writes the agreed output back to Jira

---

### Story One: Remove the Feedback Prompts
	CSUB-1212

The extraction feedback UI — asking authors whether AI-extracted content was correct — was confusing 50% of users and not producing useful data for the other 50%.

The skill read the epic and siblings, generated rules and examples, worked through open questions with the group. Ticket went from rough to "Ready for Solution" in one session.

---

### Story Two: Fix the Editorial Policy Links
	CSUB-1216

This one was described as "update some links."

The skill investigated and found that `editorialPolicyUri` was hardcoded in a `when` block rather than in the config pipeline. It also found that the same URI was being used for both the ethics statement and acknowledgements links, which should point to different pages.

Checking the actual URLs: several were broken or redirecting. The story turned out to need two new config properties and a full URL audit across six brands.

The title hadn't changed but the scope had.

---

### What the Skill Contributed

It didn't write any code. What it did:

- Brought in context from the epic and siblings before we started
- Surfaced the discrepancy between the ticket description and what the system actually did
- Kept the session structured so we covered rules, examples, and open questions
- Wrote a clean, agreed description back to Jira at the end

The group made all the decisions. The skill made sure we had the information to make them.

---

### CSUB-1212: Implemented

After the session I took CSUB-1212 through to implementation — extraction feedback removed, tests in place, shipped.

A well-scoped story with clear acceptance criteria is much easier to implement. That part is not surprising. But having the analysis done properly before picking up the ticket made the difference here.

---

### Live Demo
	CSUB-1203

Stop populating the author contribution statement from double anonymous drafts.

A sibling of CSUB-1212 — the audience already knows the epic. Let's see what the tool makes of it.

---

### Observations

The more interesting outcome was CSUB-1216. Without the analysis session, that story could have been picked up as a small config change and turned into a much messier piece of work mid-implementation.

The session didn't just produce documentation. It changed what the story actually was.

---

##### What I'd Take Forward
# Run Analysis Before Implementation

The cross-functional session matters. The skill just makes it easier to run one properly.

