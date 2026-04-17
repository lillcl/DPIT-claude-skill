#!/bin/bash
# claude-dpit install script (Unix/macOS/Linux)
#
# This script installs the DPIT skill to your Claude Code skills directory.
# Usage: ./install.sh [--uninstall]

set -e

SKILL_DIR="$HOME/.claude/skills/dpit"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$1" = "--uninstall" ]; then
    if [ -d "$SKILL_DIR" ]; then
        rm -rf "$SKILL_DIR"
        echo "Uninstalled DPIT skill from $SKILL_DIR"
    else
        echo "DPIT skill not found at $SKILL_DIR"
    fi
    exit 0
fi

echo "Installing claude-dpit skill..."

if [ -d "$SKILL_DIR" ]; then
    echo "Warning: $SKILL_DIR already exists."
    read -p "Overwrite? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
    rm -rf "$SKILL_DIR"
fi

mkdir -p "$HOME/.claude/skills"
cp -r "$REPO_DIR/skills/dpit" "$SKILL_DIR"

echo "Installed DPIT skill to $SKILL_DIR"
echo ""
echo "To use, restart Claude Code or start a new session, then run:"
echo "  /dpit"
