# 2. Toolchain & SDK

| Thing | Doctrine |
|---|---|
| Dart SDK | `sdk: '>=3.10.0 <4.0.0'` — floor 3.10, never 4.x |
| Package manager | pub (Dart 3.5+ **pub workspaces**) |
| Monorepo | **melos 7** — configured entirely in root `pubspec.yaml` |
| Formatter | `dart format` only |
| Analyzer | `dart analyze` clean before any commit |
| Docs | Terse `///` on every public member (1–2 lines, what+why) — dartdoc/pub.dev-ready |
| Tests | `dart test` |

### Melos: the modern way (and the bad smell)

**A `melos.yaml` file is a bad smell.** Modern melos (6.x, and definitively 7.x) has no `melos.yaml` at all. It uses native pub workspaces and puts all config in the **root `pubspec.yaml`** under a `melos:` key. If you see a repo with a `melos.yaml`, it is running a legacy setup and should be migrated.

Root `pubspec.yaml`:

```yaml
name: my_workspace
publish_to: none
environment:
  sdk: '>=3.10.0 <4.0.0'
workspace:
  - packages/thing_domain
  - packages/thing_usecases
  - packages/thing_datasource_drift
  - packages/thing_datasource_sembast
  - apps/thing_flutter
dev_dependencies:
  melos: ^7.0.0

melos:
  scripts:
    analyze: dart analyze
    test: dart test
```

Each package `pubspec.yaml`:

```yaml
name: thing_domain
environment:
  sdk: '>=3.10.0 <4.0.0'
resolution: workspace
```

Notes:
- The `workspace:` list is explicit — globs are not supported yet; list every package.
- `melos bootstrap` links local packages without `pubspec_overrides.yaml` (workspaces replaced that mechanism).
- Scripts live in the `melos:` key; run with `melos run <name>`.

### Dart-first editing

We are a Dart shop. Structural changes to `.dart` files are made with Dart tooling (`dart format`, targeted edits), never with Python/shell text-munging scripts. This is non-negotiable and applies to agent workflows too.

### Docs: terse, always

Every public class, method, and field gets a `///` doc comment — **at least one line, never more than two**. Say *what* it is and *why* it exists; never restate the implementation. This is a hard requirement: pub.dev scores on doc coverage (`public_member_api_docs`) and every dartdoc-style generator needs real comments to produce anything useful.

- **Use cases are the priority.** Every `*UseCase` documents what it does and what it returns.
- Enforce it: enable `public_member_api_docs` in `analysis_options.yaml`; keep `dart analyze` clean.

### Dart parameter style

**Named parameters, always** — with exactly two exceptions: a single positional parameter named `ref` or `message`. **Flutter widgets follow Flutter's own conventions** (framework-mandated named params, positional `child`/`key`-style usage, etc.), not these rules.

### Barrel files: one public door per package

Each package exposes **exactly one public entry point**: `lib/<package_name>.dart`, a hand-written barrel that re-exports the public API from `lib/src/`. Everything else under `lib/` is private.

- Consumers import the barrel only — **never** `package:thing/src/...` paths. `src/` is an implementation detail.
- Barrels are **hand-maintained** (part of the one-class-per-file discipline): one export line per public class. No codegen, no wildcard exports.
- What's exported *is* the public API: nothing gets into the barrel until it's deliberate. Private-by-default beats doc-marking later.
- Melos/publishing and the wiki rendering all assume this: the barrel is the contract a package ships. Melos manages *packages*; it does not write your barrels.

### Enforcement: lint vs. review

Not every rule in this bible can be automated. Know which is which:

**Lint-enforced (self-enforcing — `dart analyze` is the gate):**
- `public_member_api_docs` — missing `///` on any public member fails the build. Note: stricter than pub.dev's scoring floor (≥20% coverage earns full points); we hold the harder line on purpose.
- `implementation_imports` — cross-package `package:thing/src/...` imports fail. Already on by default via `package:lints/recommended`.

**Review-enforced (no lint exists — don't invent one):**
- Cargo/business params — that's intent, not syntax. No rule can tell a container from a cohesive value object.
- Barrel freshness — nothing catches a stale barrel or a class added to `src/` without an export. A custom analyzer plugin *could*, but that's over-engineering for something review catches in seconds.

The review checklist (§10) is the gate for the second group.

---
