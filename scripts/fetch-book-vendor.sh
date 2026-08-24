#!/usr/bin/env bash
# fetch-book-vendor.sh — restore pinned diagram-renderer vendor files into
# book/diagrams/src/vendor/. Normally NOT needed: vendor files are committed.
# Run this only when a vendor file is missing or corrupt.
set -euo pipefail
cd "$(dirname "$0")/.."
VENDOR="book/diagrams/src/vendor"
mkdir -p "$VENDOR"

# viz.js 3.8.0 (graphviz WASM, pinned — the ONLY renderer the diagrams use)
URL="https://cdn.jsdelivr.net/npm/@viz-js/viz@3.8.0/lib/viz-standalone.js"
OUT="$VENDOR/viz-standalone.js"
echo "fetching $URL"
curl -sL "$URL" -o "$OUT.tmp"
# sanity: header + size
HEAD="$(head -c 12 "$OUT.tmp")"
SIZE="$(wc -c < "$OUT.tmp")"
if [[ "$HEAD" != "/*!Viz.js 3.8" ]] || [[ "$SIZE" -lt 1000000 ]]; then
  echo "error: downloaded file looks wrong (header=$HEAD size=$SIZE) — not replacing vendor file"
  rm -f "$OUT.tmp"
  exit 1
fi
mv "$OUT.tmp" "$OUT"
echo "ok: $OUT ($SIZE bytes)"
