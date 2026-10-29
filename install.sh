#!/usr/bin/env sh
# Install the five AI-DLC skills (ai-dlc, ai-dlc-inception, ai-dlc-codekb, ai-dlc-construction, ai-dlc-operations).
#   ./install.sh            -> user-level   (~/.claude/skills/<skill>, symlinks)
#   ./install.sh --project  -> project-level (./.claude/skills/<skill>; run from the target repo)
#   ./install.sh --copy     -> copy instead of symlink
# All four must live in the same skills directory (they share ai-dlc/references).
set -eu

SRC="$(cd "$(dirname "$0")/skills" && pwd)"
DEST_ROOT="$HOME/.claude/skills"
MODE=link

for arg in "$@"; do
  case "$arg" in
    --project) DEST_ROOT="$PWD/.claude/skills" ;;
    --copy) MODE=copy ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

mkdir -p "$DEST_ROOT"
for s in ai-dlc ai-dlc-inception ai-dlc-codekb ai-dlc-construction ai-dlc-operations; do
  dest="$DEST_ROOT/$s"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "skip $s: $dest already exists (remove it to reinstall)" >&2
    continue
  fi
  if [ "$MODE" = copy ]; then cp -R "$SRC/$s" "$dest"; else ln -s "$SRC/$s" "$dest"; fi
  echo "installed $s -> $dest ($MODE)"
done
echo "Start a new Claude Code session and run /ai-dlc <what to build>"
