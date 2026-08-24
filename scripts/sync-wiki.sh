#!/usr/bin/env bash
# Regenerate the GitHub wiki from docs/ and push.
# Usage: scripts/sync-wiki.sh [wiki-clone-dir]   (default: /tmp/dart-flutter-bible.wiki)
set -euo pipefail

REPO="staylorx/dart-flutter-bible"
WIKI_DIR="${1:-/tmp/dart-flutter-bible.wiki}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Clone the wiki repo if we don't have it yet (wiki repos use branch master)
if [ ! -d "$WIKI_DIR/.git" ]; then
  git clone "git@github.com:${REPO}.wiki.git" "$WIKI_DIR"
fi
cd "$WIKI_DIR"
git checkout master 2>/dev/null || git checkout -b master
git pull --ff-only origin master 2>/dev/null || true

# docs file -> wiki page name
copy_page() {
  cp "$ROOT_DIR/docs/$1.md" "$2.md"
  printf '\n---\n[Home](Home) · [README](https://github.com/%s)\n' "$REPO" >> "$2.md"
}

# Home comes from the repo README (intro + why + contents)
cp "$ROOT_DIR/README.md" Home.md
printf '\n---\n[Back to the repo](https://github.com/%s)\n' "$REPO" >> Home.md

copy_page 01-architecture         Architecture
copy_page 02-toolchain            Toolchain-and-Melos
copy_page 03-topology             Repository-Topology
copy_page 04-functional-core      Functional-Core
copy_page 05-persistence          Persistence
copy_page 06-testing              Testing
copy_page 07-builders             Builders-and-Codegen
copy_page 08-flutter-ring         Flutter-Ring
copy_page 09-bootstrap-checklist  Bootstrap-Checklist
copy_page 10-review-checklist     Review-Checklist
copy_page 11-decisions            Decisions-and-Roadmap
copy_page 12-sources              Sources-of-Truth

cat > _Sidebar.md <<'SIDEBAR'
**Dart/Flutter Bible**
- [Home](Home)
- [Architecture](Architecture)
- [Toolchain & Melos](Toolchain-and-Melos)
- [Repository Topology](Repository-Topology)
- [Functional Core](Functional-Core)
- [Persistence](Persistence)
- [Testing](Testing)
- [Builders & Codegen](Builders-and-Codegen)
- [Flutter Ring](Flutter-Ring)
- [Bootstrap Checklist](Bootstrap-Checklist)
- [Review Checklist](Review-Checklist)
- [Decisions & Roadmap](Decisions-and-Roadmap)
- [Sources of Truth](Sources-of-Truth)
SIDEBAR

git add -A
if git diff --cached --quiet; then
  echo "wiki: no changes"
  exit 0
fi
git commit -m "docs: sync wiki from docs/"
git push origin master
echo "wiki: pushed"
