# Managing Post Series

This project now supports Hugo’s `series` taxonomy so you can publish multi-part stories and link them from the Projects page. This guide walks through the workflow end to end.

## 1. Create a Series Term

1. Pick a slug (e.g. `cyclechain-cloud`).
2. Create localized term files under `content/series/<slug>/_index.<lang>.md`.
3. Include front matter fields (`title`, `description`, `summary`) and optional prose describing the series itself.

Example (`content/series/cyclechain-cloud/_index.en.md`):

```markdown
---
title: "Cyclechain Cloud Journals"
description: "What we learn while building Cyclechain Cloud."
summary: "A multi-part look behind the curtain."
---

Intro paragraph…
```

Repeat for `._tr.md` (or any other language) to localize the title/description.

## 2. Associate Posts with a Series

Each post that belongs to the series needs two front-matter values:

```yaml
series: ["cyclechain-cloud"]
seriesPart: 1
```

- `series` is an array so a post can appear in multiple series.
- `seriesPart` is the display order. If omitted, posts fall back to publication order.

Once added, the post detail page automatically renders a “Series” block at the bottom that lists every part, highlights the current entry, and links back to the series index.

## 3. Browse Series Pages

- `/series/` shows every defined series with the number of posts per series.
- `/series/<slug>/` lists the parts for that specific series in order, along with dates and descriptions.

Hugo builds these pages automatically from the taxonomy templates in `layouts/taxonomy/`.

## 4. Link From Projects (Optional)

Projects can expose their related series by adding a `series` slug inside `params.projects.items` in `hugo.toml`:

```toml
[[params.projects.items]]
  name = "Cyclechain Cloud"
  series = "cyclechain-cloud"
```

When present, the projects shortcode renders a “Follow the build series” link pointing to `/series/<slug>/`, localized per language.

## Tips

- Keep `seriesPart` sequential (1, 2, 3…) to avoid confusing readers.
- Update the term `_index` content when the series evolves; it appears at the top of the series page.
- If you add new languages, create matching `_index.<lang>.md` files and ensure each post has translations for its front matter.

## Bonus: Artisan-Style Helper

Run the helper from the repo root to scaffold posts and series quickly:

```bash
./scripts/artisan.sh make:series cyclechain-cloud --title "Cyclechain Cloud" --langs tr,en
./scripts/artisan.sh make:post merhaba-dunya --lang tr --title "Merhaba Dünya" --series cyclechain-cloud --part 1
```

Use `./scripts/artisan.sh --help` to see every option (custom dates, summaries, etc.).

You can verify that the generator works the same way in a clean copy by running:

```bash
./scripts/test_artisan.sh
```

