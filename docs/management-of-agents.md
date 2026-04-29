# Managing AGENTS.md

This file documents how to create, maintain, and evolve the AGENTS.md file for your project.

## What is AGENTS.md?

AGENTS.md is a **static reference file** that gives OpenCode (and other AI agents) context about your project. It's a one-time investment that pays dividends across sessions.

## What it does

- Stores project context persistently (survives between sessions)
- Reduces repetitive onboarding explanations
- Captures hard-earned knowledge
- Enables smarter, context-aware suggestions

## What it does NOT do

- Auto-update (you must maintain it manually)
- Replace documentation (README.md handles what AGENTS.md would duplicate)
- Replace code comments (inline docs explain implementation details)

---

## When to Update

Update AGENTS.md when:

| Trigger | Example |
|---------|---------|
| New service added | Add Redis for caching |
| Port changes | mongo-express moves from 8080 to 9090 |
| New commands learned | `./scripts/migrate.sh` |
| Workflow changes | New test sequence |
| Gotchas discovered | "Always export env vars before docker-compose" |
| Non-obvious prerequisites | "Run `aws sso login` first" |

Update frequency: **Only when something important changes** — not every session.

---

## What to Include

Include only what an agent would **likely miss without help**:

- Exact commands (not "run the tests" but `npm test -- --testNamePattern="profile"`)
- Command order (lint → typecheck → test)
- Environment setup (exports required before compose)
- Port mappings specific to your project
- Non-obvious dependencies

Exclude:
- Generic language/framework conventions
- Information easily discoverable from config files
- Long tutorials or file trees
- What the README already says

---

## How to Update

### Method 1: Manual Edit

```sh
# Directly edit the file
open AGENTS.md
```

Edit in place — preserve verified content, delete stale claims.

### Method 2: Create a Draft First

If you're learning and want to track potential updates:

1. Keep notes during session
2. At session end, review notes
3. Add high-signal items to AGENTS.md

### Example Update Flow

```
You discover: "Oh right, I need to run 'chmod +x scripts/*.sh' before executing"

Add to AGENTS.md under Docker & K8s:
  chmod +x scripts/*.sh    # make scripts executable first
```

---

## Maintaining Over Time

### Keep it Lean

Every line should answer: "Would an agent likely miss this without help?"

If not, leave it out.

### Reference, Don't Duplicate

AGENTS.md → pointers to files + commands + gotchas  
README.md → comprehensive documentation

If content belongs in README, reference it instead of duplicating.

### Version-Aware Updates

When project structure changes significantly:

| Situation | Action |
|-----------|-------|
| New service | Add port, dependency notes |
| Old service removed | Remove stale references |
| Major refactor | Rewrite relevant sections |

### Quality Checks

Periodically review AGENTS.md for:
- Stale commands (still work?)
- Removed files (still exist?)
- Changed ports (still accurate?)

---

## Best Practices

1. **One AGENTS.md per project root** — not per directory
2. **Keep it compact** — if lengthy, summarize more
3. **Use copy-paste commands** — don't make agents guess
4. **Include learning gotchas** — things that caused issues
5. **Let it evolve** — it's a living document, not carved in stone

---

## Alternative: Use opencode.json

For repo-specific settings (not project context), consider `opencode.json` with an `instructions` field:

```json
{
  "instructions": "./MANAGEMENT.md"
}
```

This directs OpenCode to read your management guide for operational guidance.

See: https://opencode.ai/docs/configuration