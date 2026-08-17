#!/usr/bin/env bash
# Install the tracked communication-style instructions for Claude Code.
#
#   install-global.sh memory          symlink the file to ~/.claude/CLAUDE.md
#                                     (default; the only option in web sessions)
#   install-global.sh system-prompt   wrap the `claude` command so the file is
#                                     appended to the system prompt every launch
#
# One source file backs both modes. Installing both loads the text twice.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/CLAUDE.global.md"
MODE="${1:-memory}"
MARKER="claude-global-style"

[ -f "$SRC" ] || { echo "missing source: $SRC" >&2; exit 1; }
mkdir -p "$HOME/.claude"

link() {
  local dest="$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    cp "$dest" "$backup"
    echo "backed up $dest -> $backup"
  fi
  ln -sfn "$SRC" "$dest" 2>/dev/null || cp -f "$SRC" "$dest"
  echo "installed: $dest -> $SRC"
}

default_rc() {
  case "$(basename "${SHELL:-}")" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bashrc" ;;
    *)    echo "" ;;
  esac
}

case "$MODE" in
  memory)
    link "$HOME/.claude/CLAUDE.md"
    ;;

  system-prompt)
    STYLE="$HOME/.claude/claude-style.md"
    link "$STYLE"

    RC="${2:-$(default_rc)}"
    SNIPPET=$(cat <<'EOF'
# >>> claude-global-style >>>
claude() {
  local _sp="$HOME/.claude/claude-style.md"
  if [ -r "$_sp" ]; then
    command claude --append-system-prompt-file "$_sp" "$@"
  else
    command claude "$@"
  fi
}
# <<< claude-global-style <<<
EOF
)

    if [ -z "$RC" ]; then
      echo "unrecognized shell (${SHELL:-unset}); add this to your shell rc by hand:"
      printf '\n%s\n' "$SNIPPET"
      exit 0
    fi

    if grep -q "$MARKER" "$RC" 2>/dev/null; then
      echo "wrapper already present in $RC — nothing to do"
    else
      printf '\n%s\n' "$SNIPPET" >> "$RC"
      echo "appended wrapper to $RC (open a new shell, or: source $RC)"
    fi

    if [ -e "$HOME/.claude/CLAUDE.md" ]; then
      echo
      echo "note: ~/.claude/CLAUDE.md also exists, so the text loads twice."
      echo "      remove it to keep the system-prompt copy only."
    fi
    ;;

  *)
    echo "usage: $(basename "$0") [memory|system-prompt] [rc-file]" >&2
    exit 2
    ;;
esac
