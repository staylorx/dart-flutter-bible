#!/usr/bin/env bash
# render-diagrams.sh — render graphviz DOT diagram sources to PNG via the dot CLI.
# Requires graphviz (`dot`). Overwrites the committed PNGs in book/diagrams/.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v dot >/dev/null || { echo "error: graphviz dot not found (apt install graphviz)"; exit 1; }
for src in book/diagrams/src/*.dot; do
  name="$(basename "$src" .dot)"
  # pad expands the PNG canvas past the computed bounding box (cluster
  # labels / nested borders can overflow); margin alone does not for PNG
  dot -Tpng -Gdpi=144 -Gbgcolor=white -Gpad=0.3 "$src" -o "book/diagrams/${name}.png"
  echo "rendered book/diagrams/${name}.png ($(du -h "book/diagrams/${name}.png" | cut -f1))"
done
