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

---
