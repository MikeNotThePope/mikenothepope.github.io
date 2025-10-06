# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static blog built with Tableau, an Elixir-based static site generator. The site uses Temple (Elixir-based templating), TailwindCSS, and deploys to GitHub Pages via GitHub Actions.

## Common Commands

### Development
- `mix deps.get` - Install dependencies
- `mix tableau.server` - Start dev server at http://localhost:4999 with live reload
- `mix blog.gen.post "Post Title"` - Generate new blog post in `_posts/`

### Building
- `MIX_ENV=prod mix build` - Build site for production (runs `tableau.build` + `tailwind --minify`)
- `mix tableau.build` - Build static site to `_site/` directory
- `mix tailwind default --minify` - Compile and minify CSS

## Architecture

### Content Organization
- `_posts/` - Published blog posts (Markdown with YAML frontmatter)
- `_drafts/` - Draft posts (dev-only, excluded from prod builds)
- `_pages/` - Static pages (Markdown with YAML frontmatter)
- `_wip/` - Work-in-progress pages (dev-only, excluded from prod builds)

### Template System
The site uses **Temple**, which is pure Elixir code (not EEx/HEEx):

- **Layouts** (`lib/layouts/`) - Template wrappers for pages/posts
  - `RootLayout` - Base HTML structure with head/body
  - `PostLayout` - Wraps blog post content, nested inside RootLayout
- **Pages** (`lib/pages/`) - Static pages like HomePage
- **Components** (`lib/component.ex`) - Base module that imports Temple helpers

All templates use `use Blog.Component` to get Temple's DSL. Layouts can nest via `layout: ParentLayout` option.

### Configuration
Environment-specific configs control which directories are included:

- **Dev** (`config/dev.exs`): Includes `_drafts` and `_wip`, shows future-dated posts
- **Prod** (`config/prod.exs`): Excludes drafts/wip, hides future-dated posts, sets production URL

### Post Frontmatter Format
```yaml
---
layout: Blog.PostLayout
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS TZ
permalink: /:title/
---
```

### Markdown Configuration
MDEx is configured with extensions: tables, header IDs, tasklists, strikethrough, autolink, alerts, footnotes. Syntax highlighting uses "neovim_dark" theme with inline HTML styles.

### Deployment
GitHub Actions workflow (`.github/workflows/deploy.yml`) builds the site with Elixir 1.18.4/OTP 27.2 and deploys to GitHub Pages on push to main.

## Important Notes

- **Temple syntax**: Use `temple do ... end` blocks, not `~H` sigils or `<%= %>` tags
- **Live reload**: Watches `lib/*.ex`, `_posts/*.md`, `_pages/*.md`, and `assets/*.(css|js)`
- **RSS feed**: Enabled via `Tableau.RSSExtension`, configure title/description in `config/config.exs`
- **Blog module**: The app is named `:blog` - all modules are namespaced under `Blog.*`
