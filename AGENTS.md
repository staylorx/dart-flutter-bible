# AGENTS.md — instructions for agents working in this repo

This is the **Dart/Flutter Bible**: a standards repo (doctrine docs + CI-tested examples), not an application. Doctrine wins over tutorials, package READMEs, and gut feelings; standards change by proposal, never by drift.

## Reading order

- **Read `docs/00-compact.md` first** — the token-cheap bot-ingest blob (~1K tokens). It is **bot-only: do not hand-edit it**.
- Human docs `docs/01-architecture.md` … `docs/12-sources.md` are authoritative. Load the full section only when its detail matters.
- If you edit any human doc, **regenerate `docs/00-compact.md`** afterwards (prompt: "regenerate docs/00-compact.md from the other docs/ files").

## Code lives in examples/

- Executable samples are in `examples/` (`bible_samples`), CI-tested by `dart analyze` + `dart test` (`.github/workflows/examples-ci.yml`) on every push/PR.
- Do **not** put code in READMEs or prose docs — samples belong in `examples/` or in tests. Small illustrative snippets inside the doctrine docs are the only exception (bible §2 "Code placement").

## Housekeeping

- The GitHub wiki auto-syncs from `docs/` on every push to `main` — no manual wiki step.
- Keep the working tree clean: `dart format` / `dart analyze` / `dart test` before committing.
