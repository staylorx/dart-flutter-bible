#!/usr/bin/env bash
# render-diagrams.sh — render graphviz DOT diagram sources to PNG.
#
# Preferred path: the LAN PlantUML server (dot graph support via Graphviz/DOT
# engine). Falls back to local `dot` CLI when the server is unreachable.
# Overwrites the committed PNGs in book/diagrams/.
#
# NOTE on fonts: the LAN server lacks Helvetica — sources must use
# fontname="sans-serif" server-side; this script translates on the fly.
set -euo pipefail
cd "$(dirname "$0")/.."

ENCODER="/home/installer/.hermes/skills/creative/browser-diagram-rendering/references/plantuml_encode.py"
# DNS 'plantuml' does not resolve from hermes1 — use the IP.
SERVER="${PLANTUML_SERVER:-http://192.168.1.126/plantuml}"

use_server=0
if [ -x "$(command -v curl)" ] && curl -sf --max-time 10 -o /dev/null "$SERVER/txt/~h407374656d707479"; then
  use_server=1
  echo "render-mode: plantuml server ($SERVER)"
elif command -v dot >/dev/null 2>&1; then
  echo "render-mode: local dot CLI (plantuml server unreachable)"
else
  echo "error: no renderer available (plantuml server unreachable, dot not found)" >&2
  exit 1
fi

for src in book/diagrams/src/*.dot; do
  name="$(basename "$src" .dot)"
  out="book/diagrams/${name}.png"
  # Translate fonts the LAN server lacks into sans-serif (server Graphviz
  # silently swaps otherwise; explicit is nicer than an error PNG).
  sed 's/fontname="Helvetica[^"]*"/fontname="sans-serif"/g' "$src" > "/tmp/${name}.clean.dot"
  if [ "$use_server" = "1" ]; then
    # Wrap raw dot graph in @startdot ... @enddot for the DOT engine.
    printf '@startdot\n%s\n@enddot\n' "$(cat "/tmp/${name}.clean.dot")" > "/tmp/${name}.puml"
    python3 "$ENCODER" --file "/tmp/${name}.puml" --fmt png --out "$out"
    # Verify the output is really a PNG, not an error message.
    magic="$(head -c 8 "$out" | od -An -tx1 | tr -d ' \n')"
    if [ "$magic" != "89504e470d0a1a0a" ]; then
      echo "error: server returned non-PNG for $src:" >&2
      head -c 200 "$out" >&2
      echo >&2
      exit 1
    fi
  else
    # pad expands the PNG canvas past the computed bounding box (cluster
    # labels / nested borders can overflow); margin alone does not for PNG
    dot -Tpng -Gdpi=144 -Gbgcolor=white -Gpad=0.3 "/tmp/${name}.clean.dot" -o "$out"
  fi
  echo "rendered $out ($(du -h "$out" | cut -f1))"
done
