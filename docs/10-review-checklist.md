# 10. Review Checklist

- [ ] Dependencies point inward? (No domain → application/UI imports.)
- [ ] Any `throw`/`try`/`catch`/`on Exception` inside domain, use cases, or datasource *business* code? (Allowed: adapter-boundary `tryCatch`, UI ring.)
- [ ] Entities immutable + equatable? Operations return new instances?
- [ ] Every repository has **≥2 datasource adapters** and runs the contract suite against all of them?
- [ ] Failures typed, layer-mapped (datasource failure ≠ domain failure leaked)?
- [ ] sqlite3 done with drift? Any other ORM/raw sqlite3 in the tree?
- [ ] Any unapproved builder/codegen (freezed, json_serializable, riverpod_generator)? If yes — why?
- [ ] Tests: shouldly only (no `expect()` mixing), Given/When/Then names, both Either sides covered, mocks only at the use-case seam with mocktail?
- [ ] Every public member carries a terse `///` doc comment (1–2 lines, what+why)? Use cases documented?
- [ ] Use-case `call()` takes discrete business params (`id`, `userName`, …), never cargo/container objects?
- [ ] Dart named parameters everywhere (sole exceptions: single positional `ref`/`message`)? Flutter widgets follow Flutter conventions?
- [ ] `melos.yaml` anywhere? (Bad smell — migrate.)
- [ ] `dart analyze` and `dart test` green across the workspace?
