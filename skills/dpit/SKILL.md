---
name: dpit
description: A systematic bug-fix workflow for Claude Code — Diagnose, Plan, Implement, Test
---

# DPIT — Diagnose-Plan-Implement-Test

A systematic, repeatable workflow for fixing bugs and improving code quality in Claude Code. Every phase has specific, unambiguous instructions. No hand-waving.

## The Problem

Bug fixes often spiral into wasted time because of:
- Jumping straight to code without understanding the root cause
- Fixing symptoms instead of causes
- No regression guard to catch the same bug later
- Missing a step and discovering it after the PR is merged

## The Solution

DPIT is a four-phase workflow that forces discipline at every stage. It's designed to be invoked the moment a bug is reported or discovered.

## Quick Start

```
/dpit
```

Then follow the four phases:
1. **Diagnose** — Understand the bug completely before writing any code
2. **Plan** — Define exactly what will change and in what order
3. **Implement** — Execute the plan with minimal, surgical changes
4. **Test** — Verify the fix, run regressions, write a regression guard

## Severity Matrix

Assign severity **before** doing anything else. This drives all downstream decisions.

| Level | Name | Definition |
|-------|------|------------|
| P0 | Critical | Data loss, security vulnerability, or system completely inoperative. No workaround. |
| P1 | High | A core feature is broken. A reliable workaround exists but the issue must be fixed soon. |
| P2 | Medium | A non-critical feature is broken. A workaround exists. Degraded but usable experience. |
| P3 | Low | Cosmetic, UX nuisance, or extremely edge-case behavior. No real impact on users. |

**Rules:**
- P0 issues are worked on **immediately**, before anything else.
- If unsure between two levels, pick the **higher** one.
- If two P0s conflict, pick one and flag the other for parallel investigation.

## Definition of Done

A bug is considered **Fixed** only when ALL of the following are true:

1. The described symptom no longer occurs in the codebase.
2. All new or modified code passes type checking (`npm run type-check` or equivalent).
3. All relevant existing tests pass (`npm test` or equivalent).
4. A new or updated test covers the bug scenario (regression guard).
5. The Bug Fix Document has been updated with completion status and change notes.

A bug is considered **Verified** only when all of the above are true AND the fix was confirmed by running the actual application or tests (not just by code review).

> **Note for skill-only repositories:** Criteria #3 (existing tests) and #4 (regression guard) apply to projects with test suites. For skill-only repos that have no test infrastructure, these criteria are waived, but a smoke test should be added to verify the skill installs and loads correctly.

## Bug Fix Document

Every DPIT cycle produces one Bug Fix Document. This is the single source of truth for the cycle.

**Location:** All Bug Fix Documents are stored in `phase/bugfix/` (relative to your project root). Ensure this directory exists before creating any document. Create it if missing.

### Naming Convention

```
phase_bugfix_YYYYMMDD_description.md
```

- `YYYYMMDD` = date the cycle started
- `description` = 1-3 word summary in kebab-case (e.g., `memory-leak`, `auth-token-expiry`)
- If multiple bug fix documents exist for the same date, append `_0`, `_1`, etc.

**Examples:**
```
phase_bugfix_20260417_memory-leak.md
phase_bugfix_20260417_api-timeout_0.md
phase_bugfix_20260417_api-timeout_1.md
```

### Document Template

```markdown
# Bug Fix: [Short Description]

- **Started**: YYYY-MM-DD
- **Severity**: P0 | P1 | P2 | P3
- **Status**: In Progress | Completed | Verified

## Diagnosis

### Symptom
What the user reports or what you observed.

### Root Cause
The underlying cause (not the symptom). If unknown at this point, write "Under investigation".

### Files Involved
- `path/to/file.ts` (lines XX-XX) — brief description of the issue

## Plan

### Tasks
- [ ] Task 1 description
- [ ] Task 2 description

### Expected Outcome
What "fixed" looks like.

## Implementation

### Changes Made
| File | Change | Rationale |
|------|--------|-----------|
| `path/file.ts` | What changed | Why |

## Verification

### Test Results
Paste test output here.

### Regression Status
- [ ] Existing tests pass
- [ ] New test added: `tests/path/test-file.test.ts`

### Sign-off
- [ ] Fix confirmed working
- [ ] All Definition of Done criteria met
```

---

## Phase 1 — Diagnose

**Goal:** Understand the bug completely before writing any code.

### Step 1.1 — Observe the Symptom
- Reproduce the bug if possible (run the code, trigger the condition, capture the error).
- If it cannot be reproduced, document exactly what conditions were attempted.
- Capture the exact error message, stack trace, or unexpected output.

### Step 1.2 — Identify Affected Files
- List every file involved in the failure path.
- Do not guess. If unsure whether a file is involved, say "possibly" and flag for investigation.

### Step 1.3 — Determine Root Cause
- Trace backwards from the failure point to the source of the problem.
- Ask: "Why does this happen?" repeatedly until you reach a cause that cannot be broken down further.
- Common root causes: wrong assumption, missing null check, incorrect state, race condition, incorrect boundary, typo, wrong variable, missing await, type coercion.

### Step 1.4 — Assess Impact
- Who/what is affected? (user, system, data integrity, security)
- Is there a workaround? Can the user continue working?

### Step 1.5 — Assign Severity
- Use the Severity Matrix above.
- If severity is P0 or P1, notify the user immediately before proceeding.

### Step 1.6 — Log the Diagnosis
- Ensure `phase/bugfix` directory exists. If not present, create it before proceeding.
- Fill in the **Diagnosis** section of the Bug Fix Document.
- Be specific. "it crashes" is not a root cause. "it crashes because `user` is null when `authMiddleware` does not handle an unauthenticated request" is a root cause.

---

## Phase 2 — Plan

**Goal:** Define exactly what will change and in what order.

### Step 2.1 — Define Tasks
- Break the fix into discrete, reviewable tasks.
- Each task should be: implement feature X, add validation Y, refactor Z, add test for scenario W.
- Do not mix unrelated fixes into one task.

### Step 2.2 — Order Tasks
- Order by dependency, not severity.
- Tasks that other tasks depend on must come first.
- Flag any task that might unexpectedly break other things ("risky change — verify X after").

### Step 2.3 — Write the Plan
- Ensure `phase/bugfix` directory exists. If not present, create it before proceeding.
- Fill in the **Plan** section of the Bug Fix Document.
- Include expected outcome — what will be true after the fix that is not true now?

### Step 2.4 — Create Todo List (REQUIRED — must be demonstrated to user)

**This step is mandatory and must be visible to the user.** The DPIT workflow relies on transparency — you MUST create tasks so the user can see what is being worked on.

- After writing the plan, create a Task for each task item using TaskCreate.
- Use the Bug Fix Document filename as the task subject prefix (e.g., `[phase_bugfix_YYYYMMDD_description] Task 1: description`).
- Mark each task as `pending` status.
- Report the task IDs back to the user so they can track progress.

---

## Phase 3 — Implement

**Goal:** Execute the plan, make the fix, leave the code cleaner than you found it.

### Pre-Flight Checklist

Before touching any file, confirm:
- [ ] You understand the root cause (Step 1.3 complete).
- [ ] The fix is in the Bug Fix Document's Plan section.
- [ ] No code will be changed outside the identified files unless the plan explicitly calls for it.

### Implementation Rules

1. **Make the smallest change that fixes the problem.** Do not refactor adjacent code unless it directly contributes to the fix. Scope creep creates bugs.
2. **Do not introduce new `any` types.** If a type is unknown, define it properly.
3. **If you need to temporarily use `any` to unblock progress, remove it before marking the task done.**
4. **Run type checking after every file change.** `npm run type-check`. Fix errors before continuing.
5. **Write a regression test before or immediately after the fix.** Tests written after the fact are often written to make the fix pass, not to catch regressions.

### Per-Task Steps

For each task in the plan:
1. Read the relevant file(s) in full before editing.
2. Make the change.
3. Run type checking.
4. If a test exists for this area, run it.
5. Update the Bug Fix Document's **Implementation** table.

### Completion Check

After all tasks are done, verify:
- [ ] All files changed are listed in the Bug Fix Document.
- [ ] No debug code (`console.log`, `TODO` comments left from debugging) remains.
- [ ] Type checking passes with zero errors.
- [ ] The fix addresses the root cause, not just the symptom.

---

## Phase 4 — Test

**Goal:** Confirm the fix works, does not regress existing behavior, and has a regression guard.

### Step 4.1 — Create or Update Tests
- For every bug, write or update at least one test that would fail before the fix and pass after.
- Place tests in `tests/phase_X/` or alongside the relevant feature tests.
- If no existing test file exists for the affected area, create one.
- Test the **root cause scenario**, not just the symptom.

### Step 4.2 — Run Existing Tests
- Run all tests that could be affected by the change.
- If tests are slow or the suite is large, run only the relevant tests.
- If any existing test fails and it is **not** caused by the intentional fix, that is a regression. Fix it before continuing.

### Step 4.3 — Run the New Test
- Confirm the new/updated test passes.
- Confirm it would have failed before the fix by reading the test logic to confirm it tests the right scenario.

### Step 4.4 — Full Regression Run
- After all targeted tests pass, run the full test suite if it completes in under 5 minutes.
- If the suite is long, run at minimum the module-level tests for the affected area.

### Step 4.5 — Final Verification
- Confirm the application runs and the original symptom is gone.
- If possible, manually trigger the scenario that previously caused the bug.

### Step 4.6 — Mark Complete
- Fill in the **Verification** section of the Bug Fix Document.
- Mark status as `Completed` in the document header.
- If all Definition of Done criteria are met, mark status as `Verified`.

---

## Self-Improvement Loop

Trigger this loop whenever a test fails after a fix attempt.

### Step S1 — Identify the Failure Mode
- Is the test failing because the fix was applied incorrectly? (go back to Implement)
- Is the test failing because the fix was correct but the test is wrong? (fix the test)
- Is the test failing because a different bug was exposed? (new DPIT cycle)
- Is the test failing due to environment or dependency issue? (resolve that first)

### Step S2 — Document the Root Cause
- Write in the Bug Fix Document what caused the test to fail.
- Be specific: not "test failed" but "test failed because the mock did not cover the null branch of `user.name`, which was the actual failure path in production."

### Step S3 — Fix and Re-Test
- Apply the corrective action from Step S1.
- Re-run tests until they pass.

### Step S4 — Update This Workflow
- If the failure revealed a gap in the DPIT skill (missing step, ambiguous instruction, missing example), update the SKILL.md file to prevent the same class of failure.
- Document what changed and why in the Revision History below.
- This is not optional — every failure is an opportunity to make the workflow more robust.

### Step S5 — Resume
- Continue from the appropriate DPIT phase.

---

## Revision History

| Revision | Date | Changes | Author |
|----------|------|---------|--------|
| 1.0 | 2026-04-17 | Initial release | Claude |
| 1.1 | 2026-04-18 | TaskCreate emphasis — Step 2.4 now explicitly requires TaskCreate to be used and visible to user | Claude |
| 1.2 | 2026-04-18 | README install fixes — Option A plugin commands corrected, Options B/D paths fixed, descriptions aligned across plugin manifests | Claude |
| 1.3 | 2026-04-18 | Production readiness — Revision History updated, Definition of Done clarified for skill-only repos, smoke test added | Claude |
