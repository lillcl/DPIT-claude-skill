# DPIT Skill — claude-dpit

You are working in a codebase that has the DPIT skill installed. Use it when the user asks to fix a bug, diagnose an issue, run the DPIT workflow, or describes unexpected behavior that needs root-cause analysis.

## Invoking the Skill

```
/dpit
```

## When to Trigger DPIT

Trigger when the user:
- Asks to "fix a bug" or "diagnose this issue"
- Wants to "run the DPIT workflow"
- Describes unexpected behavior that needs root-cause analysis
- Wants a "systematic" or "structured" approach to a code problem
- Says "debug this" or "investigate"

If the user presents multiple unrelated issues, handle them **one at a time** in separate DPIT cycles.

## Severity First

Before doing anything else, assign a severity level:

| Level | Name | Definition |
|-------|------|------------|
| P0 | Critical | Data loss, security vulnerability, or system completely inoperative. No workaround. |
| P1 | High | A core feature is broken. A reliable workaround exists but the issue must be fixed soon. |
| P2 | Medium | A non-critical feature is broken. A workaround exists. Degraded but usable experience. |
| P3 | Low | Cosmetic, UX nuisance, or extremely edge-case behavior. No real impact on users. |

P0 issues are worked on **immediately**, before anything else.

## Definition of Done

A bug is **Fixed** only when ALL are true:
1. The described symptom no longer occurs
2. Type checking passes (run `shellcheck` for shell scripts)
3. All relevant existing tests pass
4. A regression guard test covers the bug scenario
5. The Bug Fix Document is updated with completion status

A bug is **Verified** only when all above are true AND the fix was confirmed by running the actual application or tests.

## Bug Fix Document

Create one per DPIT cycle. Naming: `phase_bugfix_YYYYMMDD_description.md`

Template is in the skill's SKILL.md (run `/dpit` to invoke the skill).

## Four Phases

1. **Diagnose** — Reproduce, identify files, trace root cause, assign severity
2. **Plan** — Break into tasks, order by dependency, define expected outcome. **Tasks are created via TaskCreate and visible to the user.**
3. **Implement** — Smallest change that fixes the problem, type check after every file change
4. **Test** — Write regression test, run existing tests, full regression pass, mark complete

Full phase instructions are available via `/dpit` once the skill is installed.

## Self-Improvement Loop

When a test fails after a fix:
1. Identify the failure mode (bad fix, bad test, new bug, env issue)
2. Document the specific root cause in the Bug Fix Document
3. Fix and re-test
4. If the failure revealed a gap in this skill, update SKILL.md
5. Resume from the appropriate phase
