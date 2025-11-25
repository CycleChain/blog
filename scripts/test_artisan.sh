#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_PATH="${TMPDIR:-/tmp}"
WORKDIR="$(mktemp -d "$TMPDIR_PATH/cyclechain-artisan-test-XXXXXX")"

cleanup() {
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

rsync -a --exclude '.git' "$ROOT/" "$WORKDIR/"

cd "$WORKDIR"

echo "Running artisan script tests in $WORKDIR"

assert_file_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -q "$pattern" "$file"; then
    echo "Expected '$pattern' in $file" >&2
    exit 1
  fi
}

assert_file_not_contains() {
  local file="$1"
  local pattern="$2"
  if grep -q "$pattern" "$file"; then
    echo "Did not expect '$pattern' in $file" >&2
    exit 1
  fi
}

# make:series
./scripts/artisan.sh make:series test-series --title "Test Series" --langs tr,en --description "Desc" --summary "Summary"

SERIES_TR="content/series/test-series/_index.tr.md"
SERIES_EN="content/series/test-series/_index.en.md"

[[ -f "$SERIES_TR" ]] || { echo "Missing $SERIES_TR"; exit 1; }
[[ -f "$SERIES_EN" ]] || { echo "Missing $SERIES_EN"; exit 1; }

assert_file_contains "$SERIES_TR" 'title: "Test Series"'
assert_file_contains "$SERIES_EN" 'summary: "Summary"'

# make:post with series
./scripts/artisan.sh make:post test-post --lang en --title "Test Post" --series test-series --part 2 --date 2025-01-01T00:00:00Z
POST_EN="content/posts/test-post.en.md"
[[ -f "$POST_EN" ]] || { echo "Missing $POST_EN"; exit 1; }
assert_file_contains "$POST_EN" 'series: ["test-series"]'
assert_file_contains "$POST_EN" 'seriesPart: 2'

# make:post without series
./scripts/artisan.sh make:post standalone --lang tr --title "Standalone Post"
POST_TR="content/posts/standalone.tr.md"
[[ -f "$POST_TR" ]] || { echo "Missing $POST_TR"; exit 1; }
assert_file_not_contains "$POST_TR" 'series:'
assert_file_not_contains "$POST_TR" 'seriesPart:'

echo "All artisan tests passed."

