# HỘI NGHỊ ĐÀO TẠO FPTU 2026 — deck

A slide deck for the FPT University education conference (Cần Thơ). It's plain HTML/CSS — no build step, no `npm install` — so editing is just "open the file, change the text/image, save."

**Live site:** https://hndt-2026.nguyennhathuy2110.workers.dev

## What's in here

| Path | What it is |
|---|---|
| `HNDT 2026.dc.html` | The main/authoring version. |
| `HNDT 2026 - ban chia se.dc.html` | "Share version" — **this is the one deployed to the live site.** |
| `HNDT 2026 - offline.dc.html` | Standalone version, doesn't depend on the authoring platform. |
| `HNDT 2026 - CTHD (offline).html` | A single giant self-contained file (~11 MB) — everything bundled inline. Not used for the live site; keep for reference/backup only. |
| `media/` | Images used on the hand-built slides 1–2 (logos, decorative blocks, photos). |
| `slides/` | Full-resolution JPEG of every slide (`1.jpg`…`36.jpg`) + `video.mp4` (slide 24). |
| `slides-min/` | Compressed/low-res copies of the same JPEGs. Only used for the thumbnail rail — don't use these for the main slide image, they look blurry. |
| `uploads/` | Source PDFs/PPTX the deck was built from. Only `HNDT 2026.dc.html` (the main version) reads these directly. |
| `deck-stage.js`, `support.js` | The slide viewer engine. **Don't edit these** — they're vendored/generated. All deck-specific behavior (countdown timer, video, fullscreen button, etc.) lives in the `<script data-dc-script>` block at the bottom of each `.dc.html` file instead. |
| `cf-pages-deploy/` | The exact folder that gets uploaded to Cloudflare when you deploy. It's a copy of the "ban chia sẻ" file (as `index.html`) plus `support.js`, `deck-stage.js`, `media/`, `slides/`. |
| `wrangler.jsonc` | Cloudflare deploy config (project name, which folder to upload). |

## Previewing locally

These files use relative fetches (fonts, the deck engine, PDFs), so opening a `.dc.html` file directly by double-clicking it (`file://...`) will not work correctly — you need a local web server. Open **Terminal** (Applications → Utilities → Terminal, or `⌘+Space` → "Terminal"), `cd` into this folder, and run whichever you have:

```bash
npx serve .
# or (macOS ships with python3, not python)
python3 -m http.server 8000
```

Then open the printed URL in your browser and click through to the `.dc.html` file you want to preview.

> If `npx` isn't found, you need Node.js — install it from [nodejs.org](https://nodejs.org) or via Homebrew: `brew install node`.

## Editing content

Each slide is a `<section>` with absolutely-positioned `<div>`/`<img>` elements against a fixed **1920×1080** canvas. To edit:

- **Text on slides 1–2** (the two hand-built slides): find the text in the `.dc.html` file and just change it — it's plain readable HTML.
- **Slides 3–35**: these are just images (`slides/3.jpg` … `slides/35.jpg`). To change one, replace the corresponding JPEG file with a new image saved under the *same filename*, ideally 1920×1080. If you edit them elsewhere (Figma, PowerPoint, Photoshop), export at full resolution — anything smaller will look blurry when scaled up.
- **The video** (slide 24): replace `slides/video.mp4`, keeping the same filename, or update the `src="slides/video.mp4"` reference if you rename it.

### ⚠️ Important: edit all three `.dc.html` files the same way

`HNDT 2026.dc.html`, `HNDT 2026 - ban chia se.dc.html`, and `HNDT 2026 - offline.dc.html` are three near-identical copies of the same deck. A content change (text, image swap, date, etc.) needs to be made in **all three** — they don't share content automatically. The easiest way: make the edit in one, then copy the same change into the other two.

(The one exception: `HNDT 2026.dc.html` alone does *live* PDF rendering from `uploads/*.pdf` — the other two just show the static `.jpg`. That's an intentional difference, not something to "fix.")

### Toolbar controls (already built in)

Hovering near the bottom of the screen while viewing the deck shows a small toolbar: **◀ Prev · count · Next ▶ | Reset | ⛶ Fullscreen | ▤ Show/hide slide list**. Fullscreen also has a keyboard shortcut: **F**.

## Deploying to Cloudflare

The live site is a Cloudflare Worker (static assets), deployed with [Wrangler](https://developers.cloudflare.com/workers/wrangler/) — no install needed, `npx` downloads it on demand.

### 1. One-time: get a Cloudflare API token

In the Cloudflare dashboard: **My Profile → API Tokens → Create Token** (a token with "Edit Cloudflare Workers" permissions is enough). Copy it somewhere safe — treat it like a password, never commit it to git.

### 2. Update the deploy folder

After editing the deck, copy your updated **"ban chia sẻ"** file into the deploy folder (this is the version that's actually live):

```bash
cp "HNDT 2026 - ban chia se.dc.html" cf-pages-deploy/index.html
```

If you also changed anything in `media/`, `slides/`, `deck-stage.js`, or `support.js`, copy those into `cf-pages-deploy/` too (or just re-copy the whole folders):

```bash
cp -r media cf-pages-deploy/media
cp -r slides cf-pages-deploy/slides
cp support.js deck-stage.js cf-pages-deploy/
```

### 3. Deploy

```bash
CLOUDFLARE_API_TOKEN="paste-your-token-here" npx wrangler pages deploy cf-pages-deploy --project-name=hndt-2026
```

Wrangler uploads only the files that changed, and prints the live URL when done — it should always be https://hndt-2026.nguyennhathuy2110.workers.dev.

> **Note:** you may see a Wrangler message about "the latest version of Cloudflare Pages, now part of Cloudflare Workers" — that's expected/normal, just informational.

## Saving your changes to git

This repo is connected to `https://github.com/tranthienquy/HNDT_CTHD.git`. To save your edits with history (recommended before/after deploying):

```bash
git add -A
git commit -m "describe what you changed"
git push
```
