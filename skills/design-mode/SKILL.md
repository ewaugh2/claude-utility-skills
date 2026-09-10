---
name: design-mode
description: Enter a structured design conversation before building anything — a document, slide/presentation, office tooling/systems setup, UI, prompt/agent, another skill, an API, a data schema, or software. Interview the user about the desired OUTPUT and its restrictions, propose a design grounded in domain-appropriate principles, surface trade-offs, and don't implement until the user explicitly accepts. Trigger VERY loosely — use whenever the conversation is about designing or re-designing anything, in any phrasing ("design", "redesign", "rethink", "restructure", "architect", "plan out", "how should X look/be organized") or any sign the user is shaping an artifact rather than building it. When in doubt, trigger; the skill's first step asks the user whether they want design mode, so a false trigger costs one question and exits cleanly. Do NOT use once a design is already agreed and the user just wants it built.
---

# Design Mode

A mode for designing *anything* — documents, presentations, office tooling/systems, UIs, prompts/agents, other skills, APIs, data models, and software architecture — before a single line is implemented. The job is to converge with the user on a clear, principled design and only then hand off to building.

The value of this mode is the discipline it enforces: understand the output **and the restrictions that bound it** before proposing a shape, propose a shape grounded in real principles, expose trade-offs honestly, and never start building until the user has explicitly said go. A design that ignores its constraints is a fantasy — the restrictions are what make the problem real, so surface them early and treat them as first-class inputs alongside the goals. The user always knows when they are in design mode and when they have left it.

## The process is the spine; the principles are swappable

The *process* below is the same for every domain. What changes per domain is (1) which principle menu you reason from and (2) which questions you ask. So your very first job after entering is to classify what's being designed, then pull the matching principle set from the table further down.

## 0. Confirm entry — the opt-in gate

Because the trigger is deliberately loose, the very first thing you do — before announcing anything or asking any design question — is ask the user whether they want design mode. Ask it as a **multiple-choice question** with exactly two options:

1. **Yes — enter design mode** (recommended)
2. **No — skip it, just handle my request directly**

If **yes**: proceed to step 1. If **no**: exit the skill immediately and silently — no design-mode ceremony, no summary — and handle the user's request as you normally would without this skill.

## 1. Enter design mode — announce it

State explicitly, in one line, that design mode is on and that nothing gets built until the user approves. The user should never be unsure which mode they're in.

Then restate the problem in your own words before asking anything. This catches solution-first framing early — a user who asks for a cache may really have a slow-query problem, and a user who asks for "a slide on revenue" may really need a slide that answers one specific question. Name what you think the real goal is — and then **always confirm it with a multiple-choice question** showing exactly two options:

1. **Agree — that's the goal** (recommended)
2. **Not quite — let me state it in my own words**

Do not move on to requirements until the user has either agreed or given you their own goal statement. If they restate it, adopt their wording as the goal.

Classify the domain (document / presentation / office-systems / UI / prompt-agent / skill / API / data / software / other) and load the corresponding principles below. If it's genuinely cross-domain, pull from more than one set.

## 2. Gather requirements — the output AND its restrictions

The questions are about the *output* and the *constraints that bound it*, not the implementation. Both matter equally: the output defines what success looks like, the restrictions define the space you're allowed to find it in. Concretely, pin down:

- **The output itself**: what it must do or contain, and who/what consumes it.
- **Restrictions / constraints**: the boundaries the design must live within — technical, resource, scale/performance, legal/compliance/confidentiality, organizational — and which are hard vs soft.
- **Non-goals / scope boundaries**: what this explicitly is *not*. This is as important as the goals.
- **Success criteria**: how you'll both know the design is good.
- For technical work, separate **functional** (what it does) from **non-functional** (how well — latency, scale, maintainability) requirements.

Carry the restrictions forward: every constraint named here should visibly shape the proposal in step 3, and any constraint you *can't* satisfy must be flagged as a risk rather than quietly dropped.

Ask in **small clusters**, not a wall of questions — a few related questions at a time. State your **assumptions explicitly** and invite correction rather than interrogating the user about everything; a good assumption they can veto is faster than a question.

**Prefer multiple-choice questions.** For most questions, offer a short list of options, **recommend one** as your default, and always leave room for the user to write their own answer. This is faster for the user and surfaces options they may not have considered. The exception is genuinely **open-ended** questions (e.g. "what's the real goal here?") — ask each of those on its own, as a plain free-text question, not in MCQ form and not bundled with other questions.

Know when to **stop**: once more questions stop changing the design, move on. Don't gold-plate the interview.

## 3. Propose the design — grounded and reviewable

Select the **domain-appropriate principles** (table below) and *name* which principle drove which decision — "I'm splitting these because of single-responsibility," "this slide is one-idea-per-slide," "the sections are MECE." Naming the principle makes the design reviewable instead of arbitrary.

A good proposal includes:

- **Trade-offs and at least one rejected alternative**, with the reason it lost. Never present a single take-it-or-leave-it answer as if it were the only option.
- **The structure made visible** at design abstraction — interfaces/contracts and data flow for code; the outline/section tree for a document; the slide skeleton and headline-per-slide for a deck. Not implementation detail.
- **Traceability**: tie each decision back to a requirement from step 2.
- **Risks, unknowns, and assumptions** listed separately and honestly.

## 4. Iterate

Design is a loop, not a one-shot. Expect revisions. Re-propose, re-confirm. Stay in this loop until the user signals acceptance.

## 5. Closing handshake — always ask two things

Before you exit, you must ask the user **both** of these (don't assume):

1. **What should the output be?** Options: an implementation plan you hand back; you start implementing it yourself now; or something else.
2. **What format?** Default suggestion is **chat-only**; alternatives are a Markdown file, or something else they name.

Only an explicit "yes, go" plus these instructions counts as acceptance. Vague approval ("looks good", "nice") gets one confirming question — "Want me to start building, or is this still under review?" — not an automatic start.

## 6. Exit design mode — announce it, on either path

Exit is symmetric with entry: the user always knows the mode just ended and why. There are two exit paths:

- **Accepted → building**: "Exiting design mode. Locked scope: [X]. Proceeding to [the agreed output] as [the agreed format]: [steps]." Then do exactly that.
- **Abandoned / redirected**: if the user changes topic or drops it, say design mode is closing and summarize what was agreed so far, so nothing is silently lost.

## Cross-cutting rules

- **Resist scope creep.** When a new requirement surfaces mid-design, name it explicitly and re-confirm rather than silently absorbing it.
- **No implementation leaks.** Design mode produces structure, interfaces, outlines, and at most pseudocode — never the finished artifact until you've exited via step 6.

---

## Domain → principles (each with its meaning)

Reason from the set that matches what's being designed. Name the principle when you apply it. Domains are ordered from least technical to most technical.

### Documents / reports
- **MECE** (Mutually Exclusive, Collectively Exhaustive — sections that don't overlap and leave no gaps)
- **Pyramid Principle** (lead with the conclusion, then grouped supporting arguments)
- **Inverted pyramid** (most important information first, detail after)
- **One idea per paragraph** (each paragraph makes a single point)
- **Parallelism** (items at the same level share grammatical and structural form)

### Presentations / slides
- **One idea per slide** (a single takeaway per slide)
- **Assertion–evidence** (the headline states the claim; the body is a visual that supports it)
- **Data-ink ratio** (maximize information per unit of visual clutter — Tufte)
- **Rule of three** (group into about three chunks for memorability)
- **Visual hierarchy** (size, contrast, and position guide the eye to what matters first)
- **Progressive disclosure / builds** (reveal complex content in stages rather than all at once)

### Office tooling & systems
- **Adoption over optimality** (a technically superior system nobody uses scores zero; design for the path of least resistance)
- **Single source of truth** (each fact lives in one system and is referenced, never copied across OneDrive / Notion / Excel)
- **Interoperability over consolidation** (let tools exchange data rather than forcing everything into one mega-tool)
- **Sociotechnical fit** (design the process and the tooling together; map tools to how the office actually works, not an idealized org)
- **Cost of novelty / "boring technology"** (every new tool carries a learning and maintenance tax; spend that budget deliberately)
- **Reversibility / low switching cost** (prefer changes you can pilot and roll back; avoid lock-in and own your data exit)
- **Minimize handoffs** (each manual transfer between tools or people is a failure point; reduce them)

### UI / UX design
- **Hick's Law** (decision time grows with the number of choices — reduce the options presented)
- **Fitts's Law** (time to hit a target depends on its size and distance — make key targets big and close)
- **Gestalt grouping** (proximity, similarity, and alignment signal which things belong together)
- **Progressive disclosure** (reveal complexity only as the user needs it)
- **Consistency** (the same pattern behaves the same way everywhere)

### Prompt / agent design
- **Clear role & objective** (state who the agent is and the single goal up front)
- **Context economy** (every token in context must earn its place; push detail to retrieval or tools)
- **Explicit output contract** (specify format and constraints; show examples)
- **Tool boundaries & least privilege** (give only the tools and permissions the task needs)
- **Determinism where it matters** (bundle scripts or structured steps for exact-output work instead of re-deriving it each run)
- **Graceful failure** (define what the agent does when uncertain or blocked)

### Designing a skill (meta)
- **Progressive disclosure** (keep SKILL.md lean; push detail into reference files loaded on demand)
- **Single responsibility** (one clear, well-scoped job per skill)
- **Triggering precision** (the description says what it does AND when to use it, with positive and negative examples)
- **Token economy** (every line that's always in context must earn its place)
- **Explain the why, not rigid MUSTs** (give the model the reasoning so it generalizes beyond your examples)
- **Determinism where it matters** (bundle scripts for repetitive or exact-output steps instead of re-deriving them each run)

### API / interface design
- **Statelessness** (each request carries everything needed to process it)
- **Idempotency** (safe retries — repeated calls don't duplicate effects)
- **Least privilege** (grant only the access strictly required)
- **Explicit versioning** (evolve the contract without breaking existing consumers)
- **Fail-fast with clear error contracts** (reject bad input early; return predictable, documented errors)
- **Principle of least astonishment** (consistent naming and predictable behavior)

### Data / database design
- **ACID** (Atomicity, Consistency, Isolation, Durability — the guarantees that make transactions safe)
- **Normalization** (organize tables to remove redundancy and update anomalies)
- **CAP theorem** (under a network partition you must choose Consistency or Availability, not both)
- **Idempotency** (applying the same operation twice leaves the same state)
- **Single source of truth** (each fact is stored once and referenced, never copied)

### Software / system architecture
- **SOLID** (Single-responsibility, Open/closed, Liskov-substitution, Interface-segregation, Dependency-inversion — five rules for keeping object-oriented code modular and changeable)
- **DRY** (Don't Repeat Yourself — every piece of knowledge has one authoritative home)
- **KISS** (Keep It Simple — prefer the simplest design that meets the requirements)
- **YAGNI** (You Aren't Gonna Need It — don't build for speculative future needs)
- **Separation of concerns** (each module owns one well-defined responsibility)
- **High cohesion, loose coupling** (keep related logic together; minimize dependencies between modules)
- **Principle of least astonishment** (behave the way the caller would reasonably expect)
- **Composition over inheritance** (assemble behavior from small parts rather than deep class hierarchies)

---

## Examples

**Should trigger:**
- "Help me design the data model for our deal-tracking tool."
- "Let's design this slide — it needs to show why the fund outperformed."
- "How should I structure this IC memo?"
- "I'm designing how our office uses OneDrive, Notion, and Excel — help me think it through."
- "Help me design the prompt for our diligence-summary agent."
- "Design mode: I want to architect a service that ingests portfolio statements."
- "Help me design a skill that drafts quarterly LP letters."

**Should not trigger:**
- "We already agreed on the schema — go build the migration." (design is done; just implement)
- "What's the capital of Chile?" (no artifact being designed)
- "Fix this bug on line 42." (implementation, not design)
