# claude-dpit

**Author:** Isaac Leong  
**Email:** isaacleong12345@gmail.com

**A systematic bug-fix workflow for Claude Code.**

DPIT (Diagnose-Plan-Implement-Test) is a skill that forces discipline at every stage of bug fixing — from understanding the root cause to writing a regression guard.

## What It Does

When invoked, DPIT walks through four phases:

1. **Diagnose** — Understand the bug completely before writing any code
2. **Plan** — Define exactly what will change and in what order
3. **Implement** — Execute the plan with minimal, surgical changes
4. **Test** — Verify the fix, run regressions, write a regression guard

It also produces a structured **Bug Fix Document** (`/phase/bugfix/phase_bugfix_YYYYMMDD_description.md`) as a single source of truth for the entire fix cycle. After planning, tasks are automatically converted to a todo list for tracking.

## The Problem

Most developers fix bugs by guessing → coding → testing quickly → moving on. This fails.

| Issue                  | Consequence                         |
| ---------------------- | ----------------------------------- |
| No root cause analysis | Same bug returns next week          |
| No regression tests    | Fixes break other features          |
| No documentation       | Nobody knows why code changed       |
| No severity system     | Typos get same urgency as data loss |

**Result:** Teams spend 40-50% of time fixing the same bugs repeatedly.

## The Solution

DPIT forces discipline through four phases:

```
DIAGNOSE → PLAN → IMPLEMENT → TEST
```

| Phase         | Action                                                    |
| ------------- | --------------------------------------------------------- |
| **Diagnose**  | Write root cause. Prove you understand why it breaks.     |
| **Plan**      | Define exactly what changes, in what order.               |
| **Implement** | Execute plan. No scope creep. Type checking passes.       |
| **Test**      | Verify fix. Write a regression guard that keeps bug dead. |

**Output:** `phase_bugfix_YYYYMMDD_description.md` — a single document capturing symptom, root cause, plan, changes, and verification.

**Priority matrix:** P0 (Critical — stop everything) → P1 (High) → P2 (Medium) → P3 (Low)

## Principles

- **Fix root cause, not symptom** — If you can't explain why it breaks, you can't proceed.
- **Regression test first** — No fix is complete without a guard that proves it stays fixed.
- **Smallest change possible** — Scope creep creates bugs.
- **Type checking passes** — No exceptions.
- **Document every fix** — Unwritten fixes are unfixed fixes.

## Installation

### Option A — Plugin (recommended)

From within Claude Code:

```
/plugin marketplace add lillcl/DPIT-claude-skill

then

/plugin marketplace update dpit

then

/plugin install claude-dpit@dpit
```

This installs the skill globally, making it available in all projects.

### Option B — One-line install (git)

**Unix/macOS:**
```bash
bash -c "mkdir -p ~/.claude/skills && git clone --depth 1 https://github.com/lillcl/DPIT-claude-skill.git /tmp/dpit-clone && cp -r /tmp/dpit-clone/skills/dpit ~/.claude/skills/dpit && rm -rf /tmp/dpit-clone"
```

**Windows (PowerShell):**
```powershell
git clone --depth 1 https://github.com/lillcl/DPIT-claude-skill.git $env:TEMP\dpit-clone
Copy-Item -Recurse $env:TEMP\dpit-clone\skills\dpit $env:USERPROFILE\.claude\skills\dpit
Remove-Item -Recurse -Force $env:TEMP\dpit-clone
```

### Option C — Clone and run install script

```bash
git clone https://github.com/lillcl/DPIT-claude-skill.git
cd DPIT-claude-skill
./install.sh        # Unix/macOS
# or
.\install.ps1       # Windows
```

### Option D — Manual copy

```bash
# Clone anywhere, then copy the skills/dpit folder to your Claude skills directory
cp -r skills/dpit ~/.claude/skills/

# Or on Windows (PowerShell)
Copy-Item -Recurse skills\dpit $env:USERPROFILE\.claude\skills\dpit
```

After installation, restart Claude Code or start a new session.

## Usage

```
/dpit
```

Then follow the prompts. The skill will:

- Ask you to describe the bug
- Walk through the Diagnose → Plan → Implement → Test phases
- Create a Bug Fix Document in the current directory
- Enforce the Definition of Done before marking any bug as "Fixed"

## The Severity Matrix

Every bug is classified before work begins:

| Level | Name     | Definition                                                          |
| ----- | -------- | ------------------------------------------------------------------- |
| P0    | Critical | Data loss, security vulnerability, or system completely inoperative |
| P1    | High     | A core feature is broken — workaround exists but must be fixed soon |
| P2    | Medium   | A non-critical feature is broken — workaround exists                |
| P3    | Low      | Cosmetic or edge-case — no real impact on users                     |

P0 issues are worked on **immediately**, before anything else.

## The Bug Fix Document

A structured markdown file created for every DPIT cycle. Stored in `/phase/bugfix/`:

```
/phase/bugfix/phase_bugfix_YYYYMMDD_description.md
```

Contains: Symptom → Root Cause → Plan → Implementation Changes → Verification Results.

See the [full skill documentation](skills/dpit/SKILL.md) for the complete template.

## Key Principles

- **Fix the root cause, not the symptom.** If you don't know why it breaks, you don't know if it's fixed.
- **Write the regression test first.** A bug without a regression test is a bug waiting to come back.
- **Make the smallest change that solves the problem.** Scope creep creates bugs.
- **Type checking passes before you continue.** No exceptions.

## Files

```
claude-dpit/
├── .claude-plugin/
│   ├── marketplace.json     # Plugin marketplace manifest
│   └── plugin.json          # Plugin manifest
├── skills/
│   └── dpit/
│       └── SKILL.md         # The skill itself
├── phase/
│   └── bugfix/              # Bug Fix Documents created during DPIT cycles
├── CLAUDE.md                # Project-level instructions (for Claude Code)
├── README.md                # This file
├── install.sh               # Unix/macOS install script
├── install.ps1              # Windows install script
└── LICENSE                 # MIT
```

## License

MIT — see [LICENSE](LICENSE)
