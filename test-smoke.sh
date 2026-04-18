#!/bin/bash
# Smoke test for DPIT skill installation
# Verifies the skill is correctly structured and installable

set -e

errors=0

echo "=== DPIT Smoke Test ==="

# Test 1: SKILL.md exists
if [ -f "skills/dpit/SKILL.md" ]; then
    echo "[PASS] skills/dpit/SKILL.md exists"
else
    echo "[FAIL] skills/dpit/SKILL.md not found"
    errors=$((errors + 1))
fi

# Test 2: SKILL.md has YAML frontmatter with name
if grep -q "^name: dpit" skills/dpit/SKILL.md 2>/dev/null; then
    echo "[PASS] SKILL.md has 'name: dpit' in frontmatter"
else
    echo "[FAIL] SKILL.md missing 'name: dpit' in frontmatter"
    errors=$((errors + 1))
fi

# Test 3: SKILL.md has YAML frontmatter with description
if grep -q "^description:" skills/dpit/SKILL.md 2>/dev/null; then
    echo "[PASS] SKILL.md has 'description:' in frontmatter"
else
    echo "[FAIL] SKILL.md missing 'description:' in frontmatter"
    errors=$((errors + 1))
fi

# Test 4: README.md has all 4 install options
for option in "Option A" "Option B" "Option C" "Option D"; do
    if grep -q "$option" README.md 2>/dev/null; then
        echo "[PASS] README.md contains '$option'"
    else
        echo "[FAIL] README.md missing '$option'"
        errors=$((errors + 1))
    fi
done

# Test 5: Revision History is not empty
if grep -q "Revision History" skills/dpit/SKILL.md 2>/dev/null; then
    echo "[PASS] SKILL.md has Revision History section"
else
    echo "[FAIL] SKILL.md missing Revision History"
    errors=$((errors + 1))
fi

# Test 6: Bug Fix Document template exists in SKILL.md
if grep -q "phase_bugfix_YYYYMMDD" skills/dpit/SKILL.md 2>/dev/null; then
    echo "[PASS] SKILL.md contains Bug Fix Document template"
else
    echo "[FAIL] SKILL.md missing Bug Fix Document template"
    errors=$((errors + 1))
fi

echo ""
if [ $errors -eq 0 ]; then
    echo "All smoke tests passed."
    exit 0
else
    echo "$errors test(s) failed."
    exit 1
fi
