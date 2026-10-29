#!/usr/bin/env bash
# Structural checks for the AI-DLC skills. Exit non-zero on any failure.
set -u
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

for dir in skills/*/; do
  name="$(basename "$dir")"
  f="$dir/SKILL.md"
  [ -f "$f" ] || { err "$name: missing SKILL.md"; continue; }
  [ "$(sed -n 1p "$f")" = "---" ] || err "$name: SKILL.md must start with frontmatter"
  fm_name="$(sed -n '2,/^---$/p' "$f" | sed -n 's/^name: *//p' | head -1)"
  [ "$fm_name" = "$name" ] || err "$name: frontmatter name '$fm_name' != folder name"
  sed -n '2,/^---$/p' "$f" | grep -q '^description: .\{40,\}' || err "$name: missing/short description"
  # every `references/<file>.md` mentioned must exist in some skill's references folder
  while read -r ref; do
    ls skills/*/"$ref" >/dev/null 2>&1 || err "$name: dangling reference $ref"
  done < <(grep -oh 'references/[A-Za-z0-9_.-]*\.md' "$f" "$dir"references/*.md 2>/dev/null | sort -u)
done

# installer must list exactly the skill folders
for dir in skills/*/; do
  grep -q "$(basename "$dir")" install.sh || err "install.sh does not install $(basename "$dir")"
done
bash -n install.sh || err "install.sh syntax"

# no stale layout names
if grep -rnE 'aidlc-state\.md|aidlc/intents' skills README.md | grep -v '\.aidlc/' | grep -v 'claude/skills/aidlc'; then
  err "stale layout reference found"
fi

[ "$fail" -eq 0 ] && echo "OK: all checks passed"
exit "$fail"
