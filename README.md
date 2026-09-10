# claude-skills

A portable collection of [Claude](https://claude.com) skills. Each folder under `skills/`
is a self-contained skill: a `SKILL.md` with YAML frontmatter, plus any reference files it
loads on demand.

Everything here is general-purpose — nothing is tied to a particular company, dataset, or
file layout.

## What's inside

| Skill | What it does |
|---|---|
| [`design-mode`](skills/design-mode) | Forces a structured design conversation *before* anything gets built — document, deck, schema, API, UI, or another skill. Interviews you about the output, proposes a design grounded in domain principles, and refuses to implement until you accept it. |
| [`grill-me`](skills/grill-me) | Interviews you relentlessly about a plan, one question at a time, walking down each branch of the decision tree with a recommended answer for every question. Use it to stress-test a design. |
| [`one-shot`](skills/one-shot) | Run a task to completion with no human in the loop. Key questions get 2–3 candidate answers, a chosen one, and a note in the transcript — so you can step away and review the whole thing afterwards. |
| [`sports-score-prediction`](skills/sports-score-prediction) | Predicts *scorelines* (not just winners) with probabilities, combining prediction markets, expert analysts, last-5-match form, and a motivation model that reads what each team is actually playing for. |
| [`teach-me`](skills/teach-me) | A 20–30 minute Socratic session that leaves you with both a map (where a topic sits, how its parts relate) and a mechanism (how it works from first principles). No memorization, no homework. Has a non-interactive briefing mode. |

## Installing

### Claude Code

Personal skills, available in every project:

```bash
git clone https://github.com/ewaugh2/claude-skills.git
cp -r claude-skills/skills/* ~/.claude/skills/
```

Or scoped to one project — commit them alongside the code:

```bash
mkdir -p .claude/skills
cp -r /path/to/claude-skills/skills/* .claude/skills/
```

To track upstream instead of copying, add this repo as a submodule and symlink the
individual skill folders into `~/.claude/skills/`.

### Claude app / Cowork

Skills are uploaded one at a time as a zip of the skill folder. Build the zips with:

```bash
./make-zips.sh          # writes dist/<skill>.zip for each skill
```

Then, in the Claude app, go to **Settings → Capabilities → Skills** and upload each zip.
The zip must contain the skill folder itself (`design-mode/SKILL.md`, not a bare
`SKILL.md`) — `make-zips.sh` handles that.

## Skill anatomy

```
skills/<name>/
  SKILL.md          # required: YAML frontmatter (name, description) + instructions
  references/       # optional: loaded only when the skill needs them
  scripts/          # optional: executable helpers
```

Two rules matter more than the rest:

1. **The folder name must equal the `name` in the frontmatter.** A mismatch means the
   skill won't load.
2. **The `description` is the whole trigger.** It is the only part Claude sees before
   deciding whether to open the skill, so it has to say both *what* the skill does and
   *when* to reach for it. Everything below the frontmatter is loaded only after that
   decision.

Avoid naming a skill after a built-in one (`design`, `docx`, `pdf`, `pptx`, `xlsx`,
`skill-creator`, …) — it will collide.

## Contributing / forking

Fork it, drop skills you don't want, add your own. Nothing here depends on anything else
in the repo, so skills can be lifted individually.

## License

MIT — see [LICENSE](LICENSE).
