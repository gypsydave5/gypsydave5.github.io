# Writing Style Guide: gypsydave5 Blog

A comprehensive guide based on analysis of all blog posts from 2014 to 2026 by David Wickes (gypsydave5). This guide is detailed enough to write new posts that read authentically in the author's voice.

---

## 1. Voice and Tone

### The Core Persona

The author writes as a knowledgeable practitioner who has strong opinions but is not above admitting error or ignorance. The voice is friendly, direct, and occasionally self-deprecating. The reader is addressed as a peer, not a student — even when the content is tutorial-style.

The persona is that of someone who is genuinely excited about ideas, sometimes frustrated by the industry, and always willing to share an opinion. There is warmth underneath the cynicism.

### Registers and Modulation

The tone is not uniform. It modulates across a post:

- Opening sections tend to be breezy and casual, establishing a conversational contract with the reader
- Technical sections become more precise and careful, but never dry
- Moments of opinion or frustration are delivered with controlled heat, then undercut by self-awareness
- Conclusions often have a rallying or philosophical quality

The author is aware they are writing informally and sometimes flags this:

> "What follows is more of a stream of consciousness that fell out a few nights ago pretty much unedited and very unpolished." (`on-developer-fetishes.md`)

> "Caveat Lector" (same post — deliberately invoking Latin to undercut the informal register)

### First Person: Confident but Not Arrogant

The author uses first person freely. "I", "me", "my experience" appear throughout:

> "I've recently started to take advantage of an additional library..."
> "I remember experimenting with different values..."
> "I'm not paying to find out what that means. But let's work it out ourselves."

This is not self-promotion — it establishes credibility through lived experience and makes admissions of confusion feel honest rather than weak.

### Second Person: Inclusive and Directive

Direct address to the reader is common and warm. The author uses "you" and "we" interchangeably, sometimes shifting mid-paragraph:

> "you're going to feel very uncomfortable about the direction frontend frameworks like React..." (`htmx-least-power.md`)
> "Let's talk about businesses specifically" (`technical-debt.md`)

Imperatives are used freely and are friendly in tone:

> "Read a book! Now is the time to step up..."
> "Don't get attached to a framework."
> "Try it now."

### Humour

Humour is present in most posts. It ranges from:

- Gentle self-deprecation: "I went from genius to idiot - very rapidly"
- Absurdist invention: The entire "Bumfle" framework in `on-developer-fetishes.md` (a fictional JS framework invented and deprecated in one paragraph)
- Dry understatement: "Wonderful. Your business is now rolling in money." (`technical-debt.md`)
- Deliberate anti-climax: A section titled `## CSS and Hexadecimal`, which begins: "What the hell were all the Fs about?"
- Single-word paragraphs for comic emphasis: "DISCO!" (`double-dash.md`)

Humour is never forced or sustained beyond its natural lifespan. A joke lands, the post moves on.

### Opinions

The author expresses strong opinions without hedging them into mush, but is careful not to be bullying. Dissent is invited:

> "does this sound right to you? Are you a senior developer who couldn't answer this question, and thinks it's dumb? Tell me why." (`three-books.md`)

Opinions are often positioned as provocations rather than pronouncements:

> "What if, instead of being a pattern to emulate, it's actually a 'smell' pointing to a fundamental flaw in our process?" (`pair-rotation-is-a-smell.md`)

---

## 2. Structure and Organisation

### Post Shapes

Posts fall into a few structural patterns:

**The Tutorial**: Introduction → Who is this for? → Building-block sections → Practical examples → Conclusion. Used for technical how-tos like the lambda calculus series, the C programming series, and the Hamkrest guide.

**The Argument**: Opening hook / premise → Development of argument → Counterargument acknowledged → Resolution / call to action. Used for opinion pieces like `pair-rotation-is-a-smell.md`, `three-books.md`, `on-developer-fetishes.md`.

**The Diary / Personal Reflection**: Narrative order, personal experience as the organising principle. Used mainly in the early (2014) posts from Makers Academy, and in `how-i-write-blog-posts.md`.

**The Explainer**: Concept introduction → Analogy → Technical detail → Practical application. Used in posts like `htmx-least-power.md`, `technical-debt.md`, `why.md` (bits and bytes).

### Headers

Section headers use H2 (`##`) as the main divider. H3 (`###`) is used within sections. H1 is almost never used at the top of the post (the title is in front matter). However, H1 appears occasionally in posts that are more document-like (e.g., `an_approach_to_testing...`).

Headers are often playful or punchy:

- `## What, Gatekeeping Much?` (`three-books.md`)
- `## DISCO` (implicit in `double-dash.md`)
- `## So HTMX, eh?` (`htmx-least-power.md`)
- `## Escalation` (`htmx-least-power.md`)
- `## A Bit` followed by `## Binary` — a deliberate pun setup

Some headers ask questions:

- `## Who is this for?` (appears in multiple posts)
- `## What is it good for?` (`default-parameters-considered-harmful.md`)

### The "Who Is This For?" Convention

Several posts include an explicit `## Who is this for?` section early on. This is characteristic of the tutorial-style posts and sets expectations for reader background without gatekeeping.

### Opening Hooks

Posts rarely begin with the topic statement. Instead they open with:

- A scene or situation: "It's Tuesday morning. Time for the daily stand-up." (`pair-rotation-is-a-smell.md`)
- A proposition that sounds slightly wrong: "Your language is really just a set of blinkers around what you can do." (`on-developer-fetishes.md`)
- An observation about a tool or concept: "Homebrew is wonderful..." (`brew-cask.md`)
- A direct statement of intent that also admits a limitation: "I'm not paying to find out what that means. But let's work it out ourselves." (`the-incremental-and-the-iterative.md`)

Early posts (2014) begin more like diary entries: "So I've been using my own solution..." or "Last night I paired with..."

### Closing

Posts end with:

- A rallying call to action: "Read a book! Now is the time..."
- A teaser for future content: "I might write this up more fully later"
- An invitation to engage: "feel free to hit me up on Twitter"
- A philosophical kicker that reframes the whole post
- An abrupt stop after making the last point — no forced conclusion

The 2014 posts often end with a single punchy line that feels like a tweet.

### Transitions

Transitions between sections are direct. The author does not belabour connections. Often a single sentence serves as the bridge:

> "Well..."

> "But it doesn't take a genius to see a problem here:"

> "And here's the pitch:"

> "So what?"

---

## 3. Sentences and Paragraphs

### Sentence Length and Variety

The author uses a wide range of sentence lengths. Short sentences punctuate passages of longer ones. Rhythm is important:

> "Binary 'thinking' leaks out of lower level programs and out into the way we write things that, on the face of it, really shouldn't be related. For instance, one of the first things I ever wrote as a program probably looked something like..." (`why.md`)

A single-sentence paragraph is used for emphasis, often when making a key point or a joke:

> "Java is giving me a headache."

> "So what."

> "DISCO!"

> "Well..."

> "Add a spinner?"

> "Send a `DELETE` request?"

### Fragment Usage

Grammatical fragments are used deliberately for pace and informality:

> "Only two things:"

> "Nothing too surprising here I hope"

> "Pretty good."

> "Big woop."

### Lists

Numbered and bulleted lists appear frequently in technical posts and argument-building posts. Lists are used when:

- Steps must be followed in order
- Benefits or features need to be enumerated
- Multiple examples illustrate the same point

Lists often have a casual item at the end that punctures the formality:

> "5. Read a book\n5. NOW!" (`three-books.md` — note the deliberate repeated "5.")

### Parenthetical Asides

Parentheses are used for quick aside commentary, often humorous:

> "(I sincerely hope that you don't get hit by a bus. I hope you win the lottery instead. Much nicer for you. Same effect on the team though)." (`pair-rotation-is-a-smell.md`)

> "(I've worked at that company - the clever sod left years ago, but he is still 'fondly' remembered...)" (footnote, `why.md`)

### Em-dashes and Italics

Em-dashes (`--` or `—`) are used frequently for dramatic pauses and interpolated emphasis. Italics appear for:

- Terms being introduced or defined
- Emphasis within a sentence
- Foreign phrases or quoted speech
- Words being used as words (mention vs. use)

> "A byte is a collection of bits - yes, this is definitely a pun about biting things."

> "The 'where' is the IP address of a computer, and a _port_ on that computer."

Bold text is rarer in the prose body and typically appears in lists for sub-headings or key terms.

---

## 4. Language and Word Choice

### Register

The author writes in educated British informal English. British spellings appear throughout (`behaviour`, `flavour`, `artefact`, `recognise`, `organising`, `colour`). Contractions are common (`it's`, `I've`, `you're`, `we're`, `don't`, `can't`).

Slang and colloquialisms appear, especially when expressing frustration:

> "What the hell were all the Fs about?"
> "some clever sod decided..."
> "because it's pretty low level and nasty"
> "Big woop."
> "gnarly"

### Vocabulary Range

The author moves fluidly between:

- Technical vocabulary used precisely: "bus factor", "idempotent", "referential transparency", "higher-order matchers"
- Plain English explanations that translate those terms immediately after
- Everyday metaphors to ground abstract concepts

The vocabulary is wide but worn lightly. Technical terms are never paraded.

### Metaphor and Analogy

Metaphors are a core explanatory technique. They are often sustained across a section or post:

**The cafe ordering protocol analogy** (in `request-response.md`): Walking into a cafe is used to explain network protocols, and then extended to a French cafe to explain protocol layering.

**Knives for web technologies** (in `htmx-least-power.md`): HTML/CSS/JavaScript compared to butter knife/cheese knife/lightsaber. Then extended to weapons, then to books. The escalation of the list is itself the joke.

**Financial debt** (in `technical-debt.md`): Walked through in detail with numbered steps including a `????` / `Profit` step as a South Park meme reference.

**The Mona Lisa** (in `the-incremental-and-the-iterative.md`): Used to distinguish incremental from iterative development.

Analogies are introduced naturally without preamble like "as an analogy consider...". They are just deployed:

> "Imagine these weren't web technologies. `HTML / CSS / JavaScript`. Imagine they were knives, and you wanted to cut up a melon."

### Quotation and Reference

External quotations are used to anchor arguments. They are given their own block quote and then analysed in detail. The author does not simply cite — they engage with the quoted text:

> "There's a lot that's worth unpacking here... But the bit we want is..."

References to books are named and praised specifically. The author cites: _Structure and Interpretation of Computer Programs_, Ward Cunningham's OOPSLA talk, _Accelerate_, Kent Beck's work, and so on.

Pop culture references appear for humour (South Park's `????` / `Profit`, `1337`, Mr. Robot), usually quickly and without explanation — they assume a certain reader.

### Self-Correction in Prose

Strikethrough is used occasionally to perform a self-correction in real-time, as a humorous device:

> "~~leverage its expressive power~~ write tests that read nice." (`hamkrest-quick.md`)

> "The ~~Domain~~ `ApplicationServices` object" (`an_approach_to_testing...`)

---

## 5. Code and Technical Content

### Code Blocks

All code is in fenced code blocks with language tags where relevant:

```ruby
true && true == true
```

```bash
brew install caskroom/cask/brew-cask
```

Inline code uses backticks for: variable names, function names, command names, file paths, technical terms used precisely, and keyboard shortcuts.

### Showing Failures

The author frequently shows the output of *failing* assertions or commands, not just passing ones. This is pedagogically deliberate — showing what the error message looks like is part of the teaching. In the Hamkrest post this is a central technique: every matcher is illustrated by showing what a failing assertion produces.

### Code Explanation Style

Code is shown first, then explained. The explanation is in plain prose, not in comments within the code. The author does not over-explain — they trust the reader to follow the code and use prose only to highlight the important thing:

> "Only two things:\n\n`description: String` is the description that appears in the test output.\n\n`invoke(actual: User): MatchResult` is the method that is called when the matcher is run."

### Command-Line Instructions

CLI instructions are in code blocks. On shell interaction, the prompt convention (`$` or the tool name) is sometimes shown, sometimes omitted. Instructions are brief and assume a Unix-like environment:

> "server: `nc -l 8000`\nclient: `nc localhost 8000`"

### Practical Exercises

Technical posts often include embedded exercises or questions for the reader:

> "Don't trust me - go and count for yourself. I'll wait."

> "Can you be that server with netcat?"

> "Q: What do you think HTTP looks like, if it uses TCP? How could you find out using netcat?"

This pedagogical interactivity is characteristic of posts aimed at beginners or those learning by doing.

---

## 6. Topics and Themes

### Recurring Technical Topics

- **Shell and Unix tools**: grep, xargs, nc, dc, find, tail, pre-commit hooks, file permissions. These appear across many years with deep familiarity.
- **Languages**: Ruby (early), JavaScript (mid-period, often critical), Go (frequent and positive), Kotlin (recent), Clojure (fondly remembered), C (reverent). TypeScript is approached with appreciation but reservations.
- **Functional Programming**: Lambda calculus, Church numerals, higher-order functions, currying, memoisation — treated with enthusiasm and mathematical precision.
- **Software Architecture**: Ports and adaptors, clean architecture, modularity, dependency inversion. Later posts are architecturally opinionated in a way early posts are not.
- **Agile and Process**: Pair programming, story slicing, TDD, trunk-based development, technical debt. Treated seriously, with historical grounding.
- **HTTP and Networking**: Multiple posts return to HTTP, TCP/IP, REST. The author considers this foundational knowledge for all web developers.
- **Testing**: Strong opinions on test readability, error messages, Hamkrest, TDD. Tests are not just safety nets — they are communication.

### Recurring Conceptual Themes

**Learning and growth**: Many posts stem from the author having just learned something and wanting to share it. The "I just learned X and here's what I think" pattern is common.

**Fundamentals over fashion**: A repeated theme that understanding underlying mechanisms (HTTP, bits, TCP, lambda calculus) is more valuable than chasing new frameworks. "Travel broadens the mind" (used about languages) encapsulates this.

**Against fetishism / tribalism**: The author is consistently critical of over-attachment to tools, languages, frameworks, or editors. These posts have a Buddhist flavour ("attachment is the root of suffering" is a post description).

**Pragmatism over purity**: Even when making theoretical arguments, the author grounds them in practical consequences. Abstract debates are always connected back to "what does this mean for how I write code on Monday?"

**The joy of understanding**: Many posts convey genuine excitement about an idea — not just "here is how to do X" but "isn't it wonderful that X works this way?"

### The Origin Story (2014 Posts)

The 2014 posts document the author's journey through Makers Academy bootcamp and early career. These posts are more personal and less polished but establish the base character: curious, self-doubting, determined, and given to hyperbole when excited:

> "This is probably the greatest thing since sliced bread."

> "I went from genius to idiot - very rapidly"

These posts are worth understanding because they show the voice in formation. The later confidence is earned.

---

## 7. What to Avoid / Anti-patterns

### Things This Author Does NOT Do

**Passive voice**: Almost entirely absent. The prose is active. Things are done by people and programs.

**Corporate buzzwords without irony**: Words like "leverage", "synergy", "scalability" either don't appear or appear in quotes with visible distaste. The one occurrence of "leverage" in `hamkrest-quick.md` is immediately struck through.

**Hedging technical claims into meaninglessness**: The author makes claims. "I think X" is used but not as a cowardly retreat — it's used when the claim is genuinely uncertain. On matters of style or opinion, the author is direct.

**Long introductions before getting to the point**: While posts are warm in their openings, they do not have preambles that apologise for what is about to follow or extensively explain what the post will contain before containing it. The `## Who is this for?` section does some of this work efficiently.

**Exhaustive coverage for its own sake**: Posts are not comprehensive reference guides. They cover what the author found interesting, useful, or surprising. "I am not going to cover X here" appears when necessary and without apology.

**Condescension**: The author does not talk down to readers even when the material is basic. The early "bits and bytes" post for beginners maintains the same peer-to-peer warmth as posts aimed at experienced developers.

**Ending with a whimper**: Posts don't trail off. Even when a post ends on an open question, the question is charged.

### Common Pitfalls to Avoid When Writing in This Style

- Do not make every post a comprehensive survey. Pick the interesting angle.
- Do not make jokes that require explanation. If the joke needs explaining, cut it.
- Do not maintain a single tone throughout. The variation between technical precision and casual aside is essential.
- Do not introduce every analogy with "Think of it like...". Just make the comparison.
- Do not write three paragraphs when one sentence will do. Restraint at the sentence level; ambition at the idea level.
- Do not publish without at least one strong opinion. Observation without attitude is a listicle.

---

## 8. Front Matter and Metadata Conventions

All posts use YAML front matter. The standard fields are:

```yaml
---
title: "Post Title Here"
date: YYYY-MM-DD HH:MM:SS
published: true
description: A short description of the post
tags:
  - tag1
  - tag2
---
```

Older posts include `layout: post`. Newer posts omit this.

`published: false` is used for drafts that exist in the posts directory but should not appear on the site.

Tags are lowercase, generally single-word or hyphenated. Common tags include: `javascript`, `ruby`, `go`, `clojure`, `kotlin`, `tools`, `shell`, `programming`, `agile`, `beginners`, `http`.

Titles for technical posts are often plain and descriptive. Titles for opinion posts are sometimes more provocative or allusive:

- "On Developer Fetishes"
- "Pair Rotation is a Smell"
- "Three Books"
- "Default Parameters Considered Harmful" (a nod to the classic "X Considered Harmful" genre)

---

## 9. Footnotes

Footnotes appear frequently, especially in technical and tutorial posts. They serve specific functions:

**Caveats that would interrupt the flow**: "This is _not_ how it works in real computers - I'm sorry to mislead you." (footnote, `why.md`)

**Humorous asides and confessions**: "I've worked at that company - the clever sod left years ago, but he is still 'fondly' remembered..."

**Etymology and history**: The origin of the word "byte" as a pun.

**Deeper rabbit holes**: Pointing to related topics the post won't cover, like two's complement, bit shifting, or additional reading.

**Admissions of uncertainty**: "I am assuming you're writing Kotlin using IntelliJ IDEA... If not I'd recommend it." (`hamkrest-quick.md`)

Footnotes are written in the same casual voice as the main text. They are never dry reference notes — they are mini-asides, often with personality.

### Placement: Endnotes, Not Inline

Footnote definitions must be placed at the end of the file, grouped together after the body text and any reference-style link definitions. They should **not** be placed inline next to their reference in the text. The `[^name]` marker appears inline where the footnote is referenced; the `[^name]:` definition goes at the bottom.

---

## 10. Link Style

Links appear as:

**Reference-style** (common in older posts):

```markdown
[Homebrew] is wonderful...

[Homebrew]: http://brew.sh/
```

**Inline** (more common in newer posts):

```markdown
[HTMX](https://htmx.org/)
```

External sources are linked where relevant but not excessively. The author does not festoon technical terms with Wikipedia links. Links appear when they provide genuine additional value.

---

## 11. Evolution of the Style Over Time

**2014-2015**: Personal diary voice, shorter posts, more tentative opinions, heavier use of "I just learned X". Posts are often about tools (Homebrew, Vim, Tmux) and early language discovery (Ruby, JavaScript, Clojure).

**2016-2017**: More structured. The C programming series, lambda calculus series show a new ambition for multi-part technical writing. Opinions sharpen. The author is more confident about what matters.

**2018-2019**: Professionalisation. Posts about REST, HTTP, error handling, modularity. The "why learn about X" series shows a teaching intent. The `on-developer-fetishes.md` post is the most opinionated and personal writing in the archive.

**2020-2022**: Gap in dated posts. The undated posts (many addressing Go, TypeScript, Kotlin) show a mature, assured voice. These are the most polished posts.

**2023-2026**: Strong process opinions (pair rotation, technical debt, story sizing). The posts are shorter on average but more densely argued. The author is now writing from a position of seniority and experience, addressing teams as much as individuals.

---

## 12. Quick Reference: Characteristic Phrases and Constructions

These patterns appear repeatedly and would signal authentic authorship:

- "Let me explain:" (before an analogy)
- "So what." (standalone dismissal after a boast or premise)
- "Well..." (transition to complication of a seemingly settled point)
- "But here's the thing:" (transition to the real argument)
- "I hope I'm making my point here" (after a list of escalating analogies)
- Rhetorical questions used as section breaks: "So what's the problem?"
- Using `[^n]` footnotes for personality, not just citations
- Striking through a buzzword: `~~leverage~~ use`
- A single-word or very short sentence paragraph for comic timing
- "In any case," as a transition when moving past a tangent
- Latin phrases deployed for comic incongruity (e.g., "Caveat Lector", "Audere Legere")
- Numbered steps where one step is intentionally funny or vague (`????`, `5. NOW!`)
