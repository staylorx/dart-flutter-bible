# Book: Structuring Successful Dart and Flutter Projects

A code-generated book built from the doctrine. `docs/` stays the single
source of truth; this `book/` folder adds the narrative layer.

## Layout

- `front-matter.md`, `how-to-read.md`, `back-matter.md` — book-only prose
- `chapters/NN-*.md` — narrative intros prepended to doctrine section NN.
  Missing intros are fine: the section passes through raw.
- `diagrams/` — committed PNGs + `src/` graphviz DOT sources (rendered with
  the `dot` CLI via `scripts/render-diagrams.sh`)
- `cover.html` — cover source; `cover.png` is the rendered result
- `style/epub.css` — epub styling
- `metadata.yaml` — pandoc metadata (title, author, rights)

## Build

```bash
bash scripts/build-book.sh          # EPUB only
bash scripts/build-book.sh --pdf    # + PDF (requires typst in ~/.local/bin)
```

Output: `build/structuring-successful-dart-and-flutter-projects.epub`
(and `.pdf`).

## Verify

```bash
python3 scripts/verify-epub.py
```

Final gate before publishing: `epubcheck` (W3C validator).

## Re-rendering diagrams

Diagram sources are graphviz DOT (`.dot`). With graphviz installed,
`bash scripts/render-diagrams.sh` renders them straight to PNG via the
`dot` CLI (build-book.sh does this automatically when `dot` is found).
Rendered PNGs are committed, so the epub build works even on machines
without graphviz. The cover (`cover.html` → `cover.png`) still uses the
headless-Chromium screenshot route — see the `browser-diagram-rendering`
skill for that pipeline.
