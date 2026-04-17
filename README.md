# claude-dpit

**A systematic bug-fix workflow for Claude Code.**

DPIT (Diagnose-Plan-Implement-Test) is a skill that forces discipline at every stage of bug fixing — from understanding the root cause to writing a regression guard.

## What It Does

When invoked, DPIT walks through four phases:

1. **Diagnose** — Understand the bug completely before writing any code
2. **Plan** — Define exactly what will change and in what order
3. **Implement** — Execute the plan with minimal, surgical changes
4. **Test** — Verify the fix, run regressions, write a regression guard

It also produces a structured **Bug Fix Document** (`phase_bugfix_YYYYMMDD_description.md`) as a single source of truth for the entire fix cycle.

## Installation

### Option A — Plugin (recommended)

From within Claude Code:

```
/plugin marketplace add <your-username>/claude-dpit
/plugin install <your-username>/claude-dpit@dpit
```

This installs the skill globally, making it available in all projects.

### Option B — Clone and run install script

```bash
git clone https://github.com/<your-username>/claude-dpit.git
cd claude-dpit
./install.sh        # Unix/macOS
# or
.\install.ps1       # Windows
```

### Option C — Manual copy

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

| Level | Name | Definition |
|-------|------|------------|
| P0 | Critical | Data loss, security vulnerability, or system completely inoperative |
| P1 | High | A core feature is broken — workaround exists but must be fixed soon |
| P2 | Medium | A non-critical feature is broken — workaround exists |
| P3 | Low | Cosmetic or edge-case — no real impact on users |

P0 issues are worked on **immediately**, before anything else.

## The Bug Fix Document

A structured markdown file created for every DPIT cycle. Named:

```
phase_bugfix_YYYYMMDD_description.md
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
├── CLAUDE.md                # Project-level instructions (for Claude Code)
├── README.md                # This file
├── install.sh               # Unix/macOS install script
├── install.ps1              # Windows install script
└── LICENSE                 # MIT
```

## License

MIT — see [LICENSE](LICENSE)
