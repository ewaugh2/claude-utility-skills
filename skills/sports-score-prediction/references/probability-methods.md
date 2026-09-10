# Probability & scoreline methods

Turn market prices into probabilities, and turn goal expectations into a top-3
scoreline distribution. Read the section you need.

## 1. Odds → implied probability

- **American** `-O` (favorite): `p = O/(O+100)` — e.g. `-205` → ≈ 67%.
- **American** `+O` (underdog): `p = 100/(O+100)` — e.g. `+600` → ≈ 14%.
- **Decimal** `D`: `p = 1/D` — e.g. `1.50` → 67%.
- **Fractional** `a/b`: `p = b/(a+b)` — e.g. `4/6` → 60%.
- **Polymarket / Kalshi** cents: the price *is* the probability (`64¢` → 64%).

Polymarket and Kalshi can differ — report both. If they diverge materially,
treat the gap as genuine uncertainty rather than averaging silently.

## 2. De-vig (remove the overround)

Bookmaker (and sometimes market) prices sum to >100%; the excess is margin.
Normalize: `p_fair(i) = p_raw(i) / Σ p_raw(all outcomes)`. Always de-vig before
comparing the market to your own number or calling something "value."

## 3. Baseline goal expectations (λ)

Estimate each side's expected goals from the market and form:
- From the win/draw/loss probabilities and the over/under total, back out an
  expected total and expected margin; then roughly
  `λ_fav ≈ (total + margin)/2`, `λ_other ≈ (total − margin)/2`.
- Cross-check against last-5 scoring and conceding rates (goals for / against
  per game), and against team-total markets if available.

Then **adjust λ via the motivation model** (`motivation-model.md` §4) before
computing scores. The motivation adjustment is the step that makes this a
tournament-aware model rather than a generic one.

## 4. Top-3 scorelines — Poisson (football, hockey)

With adjusted λ_A, λ_B treated as independent Poisson:
`P(k) = e^(−λ) · λ^k / k!`, and `P(score A–B = i,j) = P_A(i)·P_B(j)`.
Rank the i–j cells for the top 3.

Worked example (λ_A = 1.5, λ_B = 0.7):

| A–B | P | | A–B | P |
|---|---|---|---|---|
| 1–0 | 16.6% | | 0–0 | 11.1% |
| 2–0 | 12.5% | | 2–1 | 8.7% |
| 1–1 | 11.7% | | 3–0 | 6.3% |

Top 3: **1–0, 2–0, 1–1**. Note the modal score is still only ~1-in-6 — exact
scorelines are inherently high-variance; always say so. Independence and a fixed
rate are simplifying assumptions; fine for a top-3 sketch, not for precise tails.

## 5. High-scoring sports (basketball, NFL)

Don't predict an exact integer pair. Instead take the market spread and total,
then express the likely result as a **band** (e.g. "home by 4–8", "around
110–105"). Lean more on the market and expert lenses than on a score model. State
that you used a band, not an exact score.

## 6. Combining lenses into final probabilities

- Anchor on the de-vigged market probability for each candidate scoreline.
- Shade toward experts/history/motivation where they plausibly catch something
  the market lags (late team news, a pure dead rubber, mutual draw-suffices).
  Keep shades modest.
- Internal consistency: mutually exclusive scorelines shouldn't exceed 100%
  combined; across a large score space the top 3 sum well under 100% (correct).
- **Value pick** = the scoreline where your probability most exceeds the
  market's implied probability — often not your single most-likely score.
