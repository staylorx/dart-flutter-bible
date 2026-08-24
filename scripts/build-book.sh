#!/usr/bin/env bash
# build-book.sh — assemble the Dart/Flutter Bible doctrine + book prose into EPUB (and optionally PDF).
#
# Usage: bash scripts/build-book.sh [--pdf]
#
# The docs/ folder stays the single source of truth. This script:
#   1. assembles book/front-matter.md + book/how-to-read.md
#      + book/chapters/NN-*.md (where present) + docs/NN-*.md + book/back-matter.md
#   2. renders with pandoc to EPUB3 (TOC, cover, CSS)
#   3. optionally renders PDF via typst (if installed)
#
# Dependencies: pandoc (static binary in ~/.local/bin is fine). PDF needs typst.
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$(pwd)"
BUILD="$ROOT/build"
PANDOC="${PANDOC:-pandoc}"
PDF=0
if [[ "${1:-}" == "--pdf" ]]; then PDF=1; fi

command -v "$PANDOC" >/dev/null || { echo "error: pandoc not found (put the static binary in ~/.local/bin)"; exit 1; }
mkdir -p "$BUILD"

# --- 1. Assemble manuscript -------------------------------------------------
MANUSCRIPT="$BUILD/manuscript.md"
: > "$MANUSCRIPT"
cat book/front-matter.md >> "$MANUSCRIPT"
printf '\n\n' >> "$MANUSCRIPT"
cat book/how-to-read.md >> "$MANUSCRIPT"
printf '\n\n' >> "$MANUSCRIPT"
for intro in book/chapters/00-*.md; do
  if [[ -f "$intro" ]]; then
    cat "$intro" >> "$MANUSCRIPT"
    printf '\n\n' >> "$MANUSCRIPT"
  fi
done
for f in docs/0[1-9]-*.md docs/1[0-2]-*.md; do
  num="$(basename "$f" | cut -c1-2)"
  printf '\n\n' >> "$MANUSCRIPT"
  for intro in book/chapters/${num}-*.md; do
    if [[ -f "$intro" ]]; then
      cat "$intro" >> "$MANUSCRIPT"
      printf '\n\n' >> "$MANUSCRIPT"
    fi
  done
  cat "$f" >> "$MANUSCRIPT"
done
printf '\n\n' >> "$MANUSCRIPT"
cat book/back-matter.md >> "$MANUSCRIPT"
echo "manuscript: $(wc -l < "$MANUSCRIPT") lines"

# --- 1b. Diagrams (re-render when graphviz is available; committed PNGs are the fallback)
if command -v dot >/dev/null 2>&1; then
  bash scripts/render-diagrams.sh
else
  echo "graphviz dot not found — using committed diagram PNGs"
fi

# --- 2. EPUB ----------------------------------------------------------------
EPUB="$BUILD/structuring-successful-dart-and-flutter-projects.epub"
"$PANDOC" "$MANUSCRIPT" \
  --from markdown+smart \
  --to epub3 \
  --metadata-file book/metadata.yaml \
  --toc --toc-depth=2 \
  --epub-cover-image book/diagrams/cover.png \
  --css book/style/epub.css \
  --resource-path "$ROOT" \
  -o "$EPUB"
echo "epub: $EPUB ($(du -h "$EPUB" | cut -f1))"

# --- 3. PDF (optional, needs typst) -----------------------------------------
if [[ "$PDF" == "1" ]]; then
  if command -v typst >/dev/null 2>&1; then
    PDF_OUT="$BUILD/structuring-successful-dart-and-flutter-projects.pdf"
    "$PANDOC" "$MANUSCRIPT" \
      --from markdown+smart \
      --pdf-engine=typst \
      --metadata-file book/metadata.yaml \
      --toc --toc-depth=2 \
      --resource-path "$ROOT" \
      -o "$PDF_OUT"
    echo "pdf: $PDF_OUT ($(du -h "$PDF_OUT" | cut -f1))"
  else
    echo "typst not installed — skipping PDF (download the static binary to ~/.local/bin to enable)"
  fi
fi
