# gypsydave5.github.io

Personal blog by David Wickes. Built with `blawg` (a custom Go static site generator).

## Structure

- `posts/` — published blog posts (markdown with YAML front matter)
- `drafts/` — draft posts (same format, rendered to `site/drafts/`)
- `pages/` — static pages
- `templates/` — HTML templates
- `extras/` — lightning talk presentations (iA Presenter format)
- `images/` — blog images
- `site/` — generated output (do not edit directly)

## Publishing

1. `blawg` — generates the site from posts, drafts, pages, and templates into `site/`
2. `./publish.sh` — runs `blawg` then syncs `site/` to S3 via `aws s3 sync`

To publish: run `./publish.sh`. It handles both generation and deployment.

Posts with `published: false` in front matter are still generated but won't appear in the index. Anything in `drafts/` is rendered to `site/drafts/`.

## Front matter

```yaml
---
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS
published: true
description: "Short description"
tags:
  - tag1
  - tag2
---
```

## Writing style

See `.claude/memory/writing-style.md` for the comprehensive style guide. Key points: British English, conversational but rigorous, strong opinions, footnotes as endnotes at the bottom of the file.
