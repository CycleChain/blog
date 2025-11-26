#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_DIR="$ROOT_DIR/content"

usage() {
  cat <<'EOF'
Cyclechain Hugo helper (artisan-style)

Usage:
  ./scripts/artisan.sh make:post <slug> [--lang tr] [--title "Title"] [--date 2025-01-01T00:00:00Z] [--series slug] [--part 1]
  ./scripts/artisan.sh make:series <slug> [--title "Title"] [--langs tr,en] [--description "..."] [--summary "..."]

Examples:
  ./scripts/artisan.sh make:post merhaba-dunya --lang tr --title "Merhaba Dünya"
  ./scripts/artisan.sh make:series cyclechain-cloud --title "Cyclechain Cloud" --langs tr,en
EOF
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-+|-+$//g'
}

ensure_lang() {
  local lang="$1"
  case "$lang" in
    tr|en) ;;
    *) echo "Unsupported lang: $lang (use tr or en)" >&2; exit 1 ;;
  esac
}

make_post() {
  if [[ $# -lt 1 ]]; then
    echo "make:post requires a slug" >&2
    exit 1
  fi
  local slug
  slug="$(slugify "$1")"
  shift
  local lang="tr"
  local title=""
  local date="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local series=""
  local part="1"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --lang)
        lang="$2"; shift 2;;
      --title)
        title="$2"; shift 2;;
      --date)
        date="$2"; shift 2;;
      --series)
        series="$2"; shift 2;;
      --part)
        part="$2"; shift 2;;
      -h|--help)
        usage; exit 0;;
      *)
        echo "Unknown option: $1" >&2; exit 1;;
    esac
  done

  ensure_lang "$lang"

  if [[ -z "$title" ]]; then
    title="$(echo "$slug" | sed -E 's/-/ /g' | sed -E 's/\b(.)/\U\1/g')"
  fi

  local filename="$CONTENT_DIR/posts/${slug}.${lang}.md"
  if [[ -e "$filename" ]]; then
    echo "Post already exists: $filename" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$filename")"

  {
    echo "---"
    echo "title: \"$title\""
    echo "date: $date"
    echo "draft: true"
    echo "description: \"\""
    echo "tags: []"
    echo "categories: []"
    echo "slug: \"$slug\""
    if [[ -n "$series" ]]; then
      echo "series: [\"$series\"]"
      echo "seriesPart: $part"
    fi
    echo "---"
    echo
    echo "Write your content here."
    echo
  } > "$filename"

  echo "Created $filename"
}

make_series() {
  if [[ $# -lt 1 ]]; then
    echo "make:series requires a slug" >&2
    exit 1
  fi
  local slug
  slug="$(slugify "$1")"
  shift
  local title=""
  local description=""
  local summary=""
  local langs="tr,en"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --title)
        title="$2"; shift 2;;
      --description)
        description="$2"; shift 2;;
      --summary)
        summary="$2"; shift 2;;
      --langs)
        langs="$2"; shift 2;;
      -h|--help)
        usage; exit 0;;
      *)
        echo "Unknown option: $1" >&2; exit 1;;
    esac
  done

  if [[ -z "$title" ]]; then
    title="$(echo "$slug" | sed -E 's/-/ /g' | sed -E 's/\b(.)/\U\1/g')"
  fi

  IFS=',' read -r -a lang_array <<< "$langs"
  local dir="$CONTENT_DIR/series/$slug"
  mkdir -p "$dir"

  for lang in "${lang_array[@]}"; do
    ensure_lang "$lang"
    local localized_title="$title"
    local file="$dir/_index.$lang.md"
    if [[ -e "$file" ]]; then
      echo "Series file already exists: $file" >&2
      continue
    fi
    cat > "$file" <<EOF
---
title: "$localized_title"
description: "$description"
summary: "$summary"
---

Describe the $localized_title series here.

EOF
    echo "Created $file"
  done
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

command="$1"
shift

case "$command" in
  make:post)
    make_post "$@"
    ;;
  make:series)
    make_series "$@"
    ;;
  *)
    usage
    exit 1
    ;;
esac

