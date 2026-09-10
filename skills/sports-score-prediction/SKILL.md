---
name: sports-score-prediction
description: >-
  Predict the most likely SCORELINES (not just the winner) of a specific sports
  match, with probabilities, by combining four lenses — prediction markets
  (Polymarket + Kalshi), expert analysts, a last-5-match form comparison, and a
  championship-context "motivation model" that reads each team's standing,
  stakes, and squad completeness to infer how much effort and what tactical
  focus (attack / defend / balanced) each side will bring. Use this WHENEVER the
  user wants a score prediction, "top scores," correct-score best bets, exact
  result, or "how will X vs Y end" for any match — football/soccer above all,
  but also other goal/point sports — and ESPECIALLY in a tournament where
  group-stage math, knockout format, or two-legged ties change what each team is
  playing for. Trigger on "predict the score", "best bet for the score", "top 3
  scores", "who wins and by how much", or an uploaded fixture list.
---

# Sports Score Prediction (with Championship Logic)

## Why this skill exists

Naive score models treat a match as two abstract attack/defense ratings and
stop there. Real tournament matches are shaped by **what each team is playing
for**. A side that needs only a draw manages the game; an already-qualified
side rests its stars; two teams who both advance on a draw produce a cagey
non-event; a must-win team throws bodies forward and gets countered. None of
that shows up in a raw rating, but all of it moves the scoreline.

This skill predicts **scorelines with probabilities** by triangulating four
lenses and then modulating them through a **motivation model** that converts
standings + stakes + morale + completeness into an estimate of each team's
**effort** and **tactical focus**, which in turn sets the goal expectations the
score distribution is built from.

Default sport is association football; the structure generalizes to any
goal/point sport (see "Other sports").

## When to use it

Trigger on any request to predict the **score / result / correct score / top
scorelines** of a specific upcoming or unresolved match, or for each match in a
fixture list. For "who will win" with no interest in the scoreline, the lighter
`outcome-prediction` skill is enough; this skill is for when the **scoreline and
its probability** matter, or when tournament context is in play.

## Procedure

Always search the web first; markets, team news, and form are time-sensitive and
past most training cutoffs. Never fill them from memory. Budget roughly 1–2
searches per match (a good preview usually carries market odds, an Opta-type
model, recent form, and team news in one page); add targeted searches for
injuries/suspensions or prediction-market prices when a preview lacks them.

### Step 1 — Frame the match

Pin down: competition, **match type**, venue (home/away/neutral), date, and the
resolution rule (90 minutes only, or extra time / penalties if knockout). Match
type drives everything downstream:

- **Group stage / round-robin** — points and goal difference matter; a draw can
  be a good result for one or both sides.
- **Knockout (single-leg, "eliminatoria")** — win or go home; cagey, often
  lower-scoring in regulation, more likely to be level after 90 and decided in
  extra time or on penalties. Predict the 90-minute score but flag this.
- **Two-legged tie ("llave")** — the aggregate is what matters. Find the
  first-leg result and the away-goals rule (if any). First legs trend cautious;
  second legs depend on the deficit/lead the chasing side carries.

### Step 2 — Standings & stakes (what's to gain/lose)

For each team, state where they sit and exactly what each result does for them:
qualification, seeding, goal difference, elimination. Be concrete: "a draw tops
the group for A; B is already through; C can still sneak a best-third place with
a win." This is the raw material for the motivation model.

### Step 3 — Morale & completeness ("completitud")

Research squad availability and mindset:

- **Completeness** — are the main players available? Note injuries, suspensions,
  and especially **expected rotation** (qualified or eliminated sides rest
  starters). A missing star striker lowers that team's goal expectation; a
  missing first-choice keeper or centre-back raises the opponent's.
- **Morale / momentum** — winning or losing streak, a recent thrashing given or
  taken, confidence, manager comments about resting players.
- **Off-field** — fatigue, short turnaround, travel disruption, turmoil.

### Step 4 — The motivation model (the core step)

Combine Steps 2–3 into a read of each team's **effort level** and **tactical
focus**, then carry that into the goal expectations. This is what makes the
prediction tournament-aware. See `references/motivation-model.md` for the full
mapping; the essentials:

| Situation | Effort | Focus | Effect on scoreline |
|---|---|---|---|
| Must win (only a win advances) | High | Attack | Their goals ↑, but exposed to counters (opp goals ↑) |
| A draw suffices | Moderate | Balanced/defensive | Game-managed, total goals ↓ |
| **Both** draw-suffices | Low–moderate | Defensive | Cagey, draw probability ↑, total ↓ |
| Already qualified / dead rubber | Low, rotated | Variable | Lower λ + higher variance; favourite's edge shrinks |
| Knockout, win-or-go-home | High but cautious | Balanced | Tight in regulation; more 0-0/1-1 after 90 |
| Playing for seeding/GD | Moderate–high | Attack | Wants margin; total ↑ |

Completeness modifiers stack on top: star out → that side's goals ↓; key
defender/keeper out → opponent's goals ↑; heavy rotation → λ ↓ and variance ↑;
strong momentum → small λ ↑; fatigue/turmoil → small λ ↓.

The output of this step is, for each team, a goal-expectation lean (higher /
baseline / lower) and a focus label — used to set and adjust the Poisson rates
in Step 8–9.

### Step 5 — Market lens (Polymarket + Kalshi)

Pull the prediction-market prices from **both Polymarket and Kalshi** (they can
disagree; report both, and note bookmaker odds as a third reference). Convert
prices to probabilities and list the **top 3 scorelines with probabilities**. If
the granular correct-score market isn't retrievable, derive the top 3 from the
moneyline + totals using `references/probability-methods.md`, and say it's
derived rather than quoted. Never invent a price you didn't find.

### Step 6 — Expert lens

Summarize analyst/model calls (Opta-type supercomputers, named previews) as the
**top 3 scorelines**, each with a one-line rationale; capture consensus and any
notable dissent.

### Step 7 — Last-5 form comparison

For each team, pull the **last 5 matches** (results, goals for/against, and how
they were playing). Summarize each side's scoring and conceding pattern and the
head-to-head if any, then translate into the **top 3 scorelines** form implies.
Flag when the present motivation context breaks the historical pattern.

### Step 8 — Total-goals read (how many goals)

State whether the match projects **high-scoring, low-scoring, or balanced**, and
why — combining the over/under market, both teams' form, and crucially the
motivation model (two draw-suffices sides → low; a must-win chaser vs a leaky
defence → high). This fixes the overall goal volume the scoreline sits inside.

### Step 9 — Synthesize: final top 3 scorelines + probabilities

Set each team's expected goals (λ) from form and the market, **adjusted by the
motivation model and completeness**, anchor the total to Step 8, and compute the
score distribution (Poisson for football; see reference). Reconcile against the
three lenses and present your own **top 3 scorelines, each with a probability**
and a one-line reason. Note where the lenses agree (confidence) and diverge (the
real uncertainty). Optionally add a **best single pick** (most probable) and a
**best value pick** (your probability most above the market's).

## Output format

```
[Frame: competition · match type · venue · date · resolution rule]
Stakes: [what each team needs; what's at risk]
Morale/availability: [key ins/outs, rotation, momentum — one or two lines]
Effort & focus read: [Team A: effort/focus] · [Team B: effort/focus]
Goals read: [high / low / balanced + one-line why]

Market (Polymarket / Kalshi)
1–3. [Scoreline — prob] (note Polymarket vs Kalshi if they differ; derived if applicable)

Experts
1–3. [Scoreline — rationale + source]

Last 5 (form)
[one-line pattern per team]
1–3. [Scoreline]

Prediction
1. [Scoreline] — [probability] — [reason]
2. [Scoreline] — [probability] — [reason]
3. [Scoreline] — [probability] — [reason]
[Agreement vs divergence. Optional: best single pick vs best value pick.]
```

For a fixture list, repeat per match and end with a cross-match summary
(highest-confidence calls, draw-likely games, best value angles).

## Other sports

The four lenses and the motivation model are constant; only the score model
changes. Low-count goal sports (football, hockey) → independent Poisson.
Higher-scoring sports (basketball, NFL) → predict a points spread and total and
convert to a likely score band rather than an exact integer pair; the market and
expert lenses carry more weight than an exact-score model there. Always say which
approach you used.

## Guardrails

- **Search every dimension; never guess.** Standings, team news, market prices,
  and last-5 results all come from retrieved sources, with citations.
- **Don't fabricate prices.** If a Polymarket or Kalshi number isn't found, say
  so and derive transparently, or omit it.
- **Paraphrase** analyst commentary; keep any direct quote short and attributed.
- **Calibrate humility.** Exact-score is high variance — the top pick is usually
  ~1-in-6 or worse even in a lopsided game. Say so. Dead rubbers and rotation
  widen the band further.
- **Frame wagering as entertainment**, briefly, and include a responsible-
  gambling note when giving betting angles; no staking advice.
- This is general analysis, not financial advice.

## References

- `references/motivation-model.md` — full mapping of match type × standings ×
  stakes × morale/completeness → effort, tactical focus, and the goal-expectation
  adjustments to apply. Read it whenever the match has any tournament context.
- `references/probability-methods.md` — odds↔probability conversion, de-vigging,
  and building a top-3 scoreline distribution (Poisson with motivation-adjusted
  λ; points-based bands for high-scoring sports). Read it whenever turning a
  market price into a probability or a goal expectation into a score.
