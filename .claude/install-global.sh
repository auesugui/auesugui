#!/usr/bin/env bash
# Install this repo's global Claude Code instructions to ~/.claude/CLAUDE.md.
# Symlinks by default so edits to the tracked file take effect immediately;
# falls back to a copy on filesystems without symlink support.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/CLAUDE.global.md"
DEST="$HOME/.claude/CLAUDE.md"

[ -f "$SRC" ] || { echo "missing source: $SRC" >&2; exit 1; }

mkdir -p "$HOME/.claude"

if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
  BACKUP="$DEST.bak.$(date +%Y%m%d%H%M%S)"
  cp "$DEST" "$BACKUP"
  echo "backed up existing global CLAUDE.md -> $BACKUP"
fi

ln -sfn "$SRC" "$DEST" 2>/dev/null || cp -f "$SRC" "$DEST"
echo "installed: $DEST -> $SRC"
