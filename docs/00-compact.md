> Derived from `docs/01`–`docs/12`. The full sections are authoritative. If you edit the bible,
> REGENERATE this blob (ask an agent: "regenerate docs/00-compact.md from the other docs/ files").

# DART/FLUTTER BIBLE — COMPACT (bot ingest)

## IDENTITY
- Repo: staylorx/dart-flutter-bible (fork of taybiz/dart-flutter-bible). Authoritative. License: MIT.
- Framing: "our standard — open to change by proposal", not "the law".
- Reference impl: banking_cli (dart-clean-architecture skill walkthrough only).

## RULES (non-negotiable)
- Bulls-eye clean architecture: entities at center; dependencies point INWARD; flow one direction UI -> usecase -> repository -> datasource.
- Exceptions ONLY at the UI ring. Everywhere else, failure is a VALUE.
- fpdart ALWAYS: Either (sync), TaskEither (async), Option (absence). Pin ^1.2.0; NEVER 2.0-dev (Effect rewrite, pre-release).
- equatable on every entity/value object: immutable, const constructors, props list.
- Failures: sealed hierarchies PER LAYER (domain / datasource). Datasource failures mapped upward at the repository. switch over failures is exhaustive.
- tryCatch ONLY at adapter boundaries, converting third-party exceptions -> Left. No throw/try/catch in domain or usecases.
- TWO-ADAPTER RULE: every repository contract gets >=2 datasource adapters + a shared contract suite run against ALL of them.
- WIDGETS -> USECASES ONLY: no widget imports repository, datasource, or entity factory; providers wrap use cases.
- melos.yaml = BAD SMELL. Modern melos 7 + native pub workspaces.
- SDK constraint: '>=3.10.0 <4.0.0' in every pubspec.
- One class per file; barrel exports. dart format / dart analyze / dart test only. Dart-first editing: no Python/sed rewriting .dart files.

## STACK (pinned)
- fpdart ^1.2.0 · equatable ^2.x · shouldly (assertions, "should be" idiom) · mocktail (mocks, usecase seam only) · drift + drift_dev + build_runner (sqlite3 ORM; SANCTIONED codegen) · sembast (pure-Dart file store) · melos ^7.0.0 · flutter_riverpod (plain providers) · go_router (nav).

## BANNED
- freezed, json_serializable, riverpod_generator, retrofit, get_it/injectable, raw sqlite3 without drift.
- throw/try/catch inside domain/usecases. expect() mixed with shouldly. Any builder except drift. melos.yaml files.

## WORKSPACE / MELOS
- Root pubspec: `workspace:` lists packages; `melos:` key holds scripts. Every package sets `resolution: workspace`.
- `melos bootstrap`, then `melos run <script>`. Workspaces are per-repo; melos does NOT span repos.

## TOPOLOGY
- A) One workspace repo — small / single-delivery (CLI only). B) Core repo (domain + usecases + datasource adapters + CLI, pure Dart, NO Flutter) + separate UI repo (Flutter; git dep on core + dependency_overrides for dev; platform bits like path_provider resolved in UI composition root).
- The application layer (use cases) IS the facade — one seam served by CLI and UI alike. Optional thin facade class = wiring convenience only, never a logic layer.

## PERSISTENCE
- sqlite3 -> drift. Tests: NativeDatabase.memory().
- File store -> sembast. Tests: databaseFactoryMemory.
- Repository + datasource CONTRACTS live in the domain package. Repos orchestrate/validate; datasources do mechanical I/O. Contract tests live in core, never the UI repo.

## TESTING
- shouldly: `x.should.be(...)`; never mix expect(). Names: Given/When/Then.
- Layer matrix: domain = unit, no mocks; usecases = mocktail on interfaces we own; adapters = real in-memory doubles; contract suite on every adapter; widget tests at UI.
- Every usecase test covers BOTH Either sides (Right happy path + each Left).

## FLUTTER
- Riverpod plain providers, NO generator. Manual constructor injection; composition root in the app.
- Widget job: call usecase -> render state. Exceptions caught at the boundary, converted to UI state, never swallowed.

## BOOTSTRAP (new project)
1 read compact (or full) bible; 2 root pubspec with workspace + melos keys (no melos.yaml); 3 packages: domain / usecases / 2 datasource adapters / app; 4 resolution: workspace + melos bootstrap; 5 contracts first (entities, failures, I*Repository, datasource interfaces); 6 two adapters + contract suite from day one; 7 dart analyze clean; 8 first usecase + both-sides test; 9 CI runs analyze + test.

## REVIEW (checklist)
- Inward dependencies? Throw/try/catch outside UI ring? Entities immutable + equatable? >=2 adapters + contract suite? Failure layers mapped, no leakage? drift the only ORM? Unapproved builders? shouldly only, GWT names, both Either sides? No melos.yaml? analyze + test green?

## DECISIONS (settled)
- State: Riverpod (plain providers). DI: manual constructor injection. Nav: go_router. JSON codegen: banned for now. License: MIT. Wiki: auto-synced by wiki-sync GitHub Action on every push to main.

## LINKS
- Repo: https://github.com/staylorx/dart-flutter-bible · Wiki: https://github.com/staylorx/dart-flutter-bible/wiki
- Full docs: docs/01-architecture.md .. docs/12-sources.md (this blob = docs/00-compact.md)
