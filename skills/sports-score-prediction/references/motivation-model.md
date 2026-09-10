# The motivation model

How to turn championship context into goal expectations. The chain is:

**match type + standings + stakes + morale + completeness → each team's effort
& tactical focus → adjustments to each team's expected goals (λ) and to the
total-goals read.**

Apply this after you have a baseline λ for each team from form and the market,
then shade the λ up or down as below. Keep shades modest and stack them; the
market already prices a lot of this, so you are adjusting at the margin and,
above all, catching things the market may lag (late team news, a pure dead
rubber, mutual draw-suffices).

## 1. Stakes → effort & focus

| What the team needs | Effort | Likely focus | λ effect (self / opponent) |
|---|---|---|---|
| Must win to advance | High | Attack, commit numbers | self ↑ ; opponent ↑ (open to counters) |
| Win wanted for seeding / GD / top spot | Moderate–high | Attack | self ↑ ; total ↑ |
| A draw is enough | Moderate | Balanced→defensive, game-manage | self ↓ ; total ↓ |
| Already qualified, result irrelevant | Low (rotation) | Variable / experimental | self ↓ ; variance ↑ ; edge ↓ |
| Eliminated, pride only | Low–moderate | Variable | self ↓ ; variance ↑ |
| Avoid heavy defeat (GD protection) | Moderate | Defensive | total ↓ |

### Key combined patterns

- **Both sides advance on a draw** → lowest-event profile on the board. Raise
  draw probability, cut the total, expect 0-0 / 1-1. (The classic cautious
  "mutual interest" game.)
- **Must-win underdog vs comfortable favourite** → underdog λ up but opponent λ
  up more on the counter; favourite often wins by managing transitions. Good
  spot for "favourite wins, both teams score."
- **Dead rubber for the favourite, must-win for the other** → rotation shrinks
  the favourite's edge; the motivated, full-strength side is live for an upset
  or a draw. Widen the distribution.
- **Both dead rubbers** → high variance, low predictive confidence; lean on
  market and lower the total slightly; flag low confidence explicitly.

## 2. Match type adjustments

- **Group stage** — stakes table above applies directly.
- **Single-leg knockout** — both sides cautious early; regulation tends
  lower-scoring with more 0-0/1-1, then extra time. Predict the 90-minute score
  but note ET/penalties as the tiebreak; don't over-weight a decisive winner.
- **Two-legged tie** — anchor on the aggregate. First leg: away side often
  protects, slightly lower total. Second leg: the trailing side becomes a
  "must-win" (apply that row), the leading side a "draw-suffices" (apply that
  row), scaled by the size of the first-leg margin and any away-goals rule.

## 3. Morale & completeness modifiers

Stack these on top of the stakes/type read:

| Factor | λ effect |
|---|---|
| First-choice striker / top scorer OUT | that team's λ ↓ (meaningfully) |
| First-choice keeper or key centre-back OUT | opponent λ ↑ |
| Heavy expected rotation (qualified/eliminated) | that team's λ ↓ and variance ↑ |
| Strong momentum (winning run, big recent win) | small λ ↑ |
| Poor morale (losing run, just thrashed) | small λ ↓ |
| Fatigue / short turnaround / long travel | small λ ↓, total ↓ |
| Off-field disruption / turmoil | small λ ↓ |
| Manager has openly said he'll rest players | that team's λ ↓, variance ↑ |

## 4. Turning the read into numbers

1. Start from baseline λ_A, λ_B (from last-5 scoring/conceding rates and the
   market's implied total + margin — see `probability-methods.md`).
2. Apply the stakes row for each team, then match-type, then each morale/
   completeness modifier, nudging λ up or down. Typical single-factor nudge is
   ±0.1 to ±0.3 goals; don't let several small factors compound into an
   implausible swing.
3. Re-check the implied total against your Step 8 goals read; if they disagree,
   reconcile (the goals read and the market total are the sanity check).
4. Feed the adjusted λ into the Poisson model for the top-3 scorelines.

## 5. Worked illustration

Two sides level on points; Team B advances with a draw and is at full strength;
Team A must win but rests no one. Baseline λ_A ≈ λ_B ≈ 1.1.
- Team A "must win, attack": λ_A → 1.3, and λ_B (counters) → 1.2.
- Team B "draw suffices, game-manage": λ_B → 0.9; total nudged down.
- Net: a tight game, elevated draw chance, top scores around 1-1, 1-0 either
  way, 0-0 — exactly the cautious decider the context predicts, not the open
  game two 1.1-rated attacks would otherwise imply.
