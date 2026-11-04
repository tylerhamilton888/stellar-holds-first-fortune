#!/usr/bin/env bash
# Reuse only a complete passing native gate for byte-identical source.
set -euo pipefail
VERIFIED=""
# A release-only/documentation commit may reuse the existing full gate
# only when every other tracked file is byte-identical to its source.
for SOURCE in $(git log -64 --format=%H); do
  if ! git diff --quiet "$SOURCE" HEAD -- . ':(exclude)docs/**' ':(exclude)SESSION_HANDOFF.md' ':(exclude).github/workflows/windows-release.yml'; then
    continue
  fi
  CHECK=$(gh api -X GET "repos/$GITHUB_REPOSITORY/actions/runs" -f head_sha="$SOURCE" -f event=pull_request --jq '[.workflow_runs[] | select(.path == ".github/workflows/validate.yml")][0] // empty')
  test -n "$CHECK" || continue
  # Wait for that exact source instead of launching a duplicate suite.
  for ATTEMPT in $(seq 1 240); do
    test "$(echo "$CHECK" | jq -r .status)" = completed && break
    sleep 15
    CHECK=$(gh api "repos/$GITHUB_REPOSITORY/actions/runs/$(echo "$CHECK" | jq -r .id)")
  done
  if test "$(echo "$CHECK" | jq -r .conclusion)" != success; then
    echo "The identical source gate did not pass; release remains blocked."
    exit 1
  fi
  RUN=$(echo "$CHECK" | jq -r .html_url)
  if test -n "$RUN"; then
    VERIFIED="$SOURCE $RUN"
    break
  fi
done
if test -n "$VERIFIED"; then
  mkdir -p test-results
  echo "Identical source passed full native gameplay: $VERIFIED" | tee test-results/release-source.txt
else
  echo "No identical-source validation found. Open/validate the source PR before releasing."
  exit 1
fi
