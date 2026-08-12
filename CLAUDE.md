# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A single presentation deck — "HỘI NGHỊ ĐÀO TẠO FPTU 2026" (an FPT University education conference deck, Cần Thơ, 11.08.2026) — authored in the **`.dc.html` ("Design Components") format**. This is a static-asset export, not an application: there is no `package.json`, no build/lint/test tooling, and nothing to install. Slides are opened directly as HTML files (a local static server is needed only so the CDN-loaded `pdf.js` script and Google Fonts can fetch normally, and so `fetch()` of the `uploads/*.pdf` files works).

## Repository layout

- **`HNDT 2026.dc.html`** — the authored source of truth. Custom-built title/agenda slides (1–2) are hand-coded absolutely-positioned HTML; slides 3–35 are thin `<section data-pdf="uploads/<range>.pdf|<page>">` wrappers that get live-rendered from the source PDFs via `pdf.js` (vector, crisp at any resolution) with the matching `slides/<n>.jpg` underneath as a fallback/thumbnail/print image. Slide 24 embeds `slides/video.mp4`.
- **`HNDT 2026 - ban chia se.dc.html`** ("share version") and **`HNDT 2026 - offline.dc.html`** — derived variants with the `data-pdf` attributes and the `pdf.js` CDN `<script>` stripped out, so slides render from the static `slides/*.jpg` only (no live PDF fetch/render, no dependency on the PDFs being reachable). The offline variant also loads `deck-stage.js` via a plain `<script src="./deck-stage.js">` instead of the `<x-import>` host-integration form, so it can run fully standalone outside the authoring platform.
- **`HNDT 2026 - CTHD (offline).html`** — a single fully self-contained bundled export (~11 MB) of the deck for opening with zero other files present.
- **`deck-stage.js`** — the `<deck-stage>` web component: slide navigation (keyboard/touch), the thumbnail rail, auto-scaling to a 1920×1080 design canvas, print-to-PDF layout, and speaker-notes postMessage. It is a vendored "omelette starter" scaffold (see the file's own header comment) — re-running the platform's `copy_starter_component` overwrites it, so avoid hand-editing it for anything deck-specific; the intended extension points are the `<x-import>` usage and the deck's own script/props block instead.
- **`support.js`** — the `dc-runtime`, generated output (`GENERATED from dc-runtime/src/*.ts — do not edit`) providing the `<x-dc>`/`<x-import>` parsing, prop-schema handling, and the `DCLogic` base class that per-deck component scripts extend. Its TypeScript source is not part of this repo, so it can't be rebuilt here — treat it as a vendored dependency.
- **Per-deck logic** lives inline at the bottom of each `.dc.html` file, in `<script type="text/x-dc" data-dc-script data-props="...">`, as a `class Component extends DCLogic`. In this deck it: mounts a countdown-ring widget (props: `durationMinutes`, `ringColor`, `thickness`, `inset`, `cornerRadius`, `trackColor`), wires the slide-24 `<video>` ref, and (`_initPdf`/`_syncPdf`) keeps the live PDF.js render in sync with `deck-stage`'s `slidechange` events for whichever slide is active.
- **`media/`** — image/SVG assets used by the hand-built slides 1–2 (logos, decorative blocks, photos).
- **`slides/`** — full-resolution per-slide JPEG fallbacks (`1.jpg`…`36.jpg`) plus `video.mp4`, used as the underlay/print image beneath the live PDF render and as the source for the three static-only deck variants.
- **`slides-min/`** — compressed/lower-resolution copies of the same JPEGs (e.g. for the thumbnail rail or faster preview loads).
- **`uploads/`** — source materials the deck was assembled from: the split source PDFs (`1-7.pdf`, `8-15.pdf`, `16-23.pdf`, `25-35.pdf`, referenced by the `data-pdf` page-range|page syntax), the original `.pptx`, the source `.mp4`, and a `HNĐT 2026/` subfolder.
- **`.thumbnail`** — deck thumbnail image used by the authoring platform.

## Working in this repo

- There is no build step. Edits to slide content happen directly in the `.dc.html` files' inline HTML/CSS (absolute-positioned `<div>`/`<img>` elements against the fixed 1920×1080 canvas declared on `<x-import>`/`deck-stage`).
- Keep the three `.dc.html` variants (`HNDT 2026.dc.html`, `... - ban chia se.dc.html`, `... - offline.dc.html`) in mind when editing slide markup shared across them — they're near-duplicates that diverge only in the PDF-live-render wiring described above, not in slide content, so a content edit generally needs to be mirrored across all three (and, if kept in sync, the bundled offline `.html` export) rather than made in just one.
- Do not hand-edit `deck-stage.js` or `support.js` for deck-specific behavior — they're vendored/generated; deck-specific logic belongs in each `.dc.html` file's own `<script data-dc-script>` block.
