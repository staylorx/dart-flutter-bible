# 9. Bootstrap: The Checklist as a Growth Ritual

The bootstrap checklist is short, and that is the point. It is the minimum viable ceremony for a new project — the order of operations that makes the doctrine hold from day one, before habit has time to erode it. Chapter 1 promised the order; here it is.

**Read the bible first.** Step one is not a joke. The doctrine is a set of constraints that make sense together; skipping the reading is how teams end up with two topologies in one repo, or a freezed model next to a hand-written entity. The checklist is not a style guide; it is a sequence. Each step depends on the one before it.

**Scaffold the workspace.** Root `pubspec.yaml` with the `workspace:` list and the `melos:` key inline — no `melos.yaml`. The migration guide exists because melos predates the workspace feature; a `melos.yaml` in a new project means the setup copied an old pattern, not that the pattern is right. One file, one source of truth.

**Contracts before code.** Define the domain first: entities, failures, `I*Repository`, datasource interfaces. Nothing else compiles until these do. This is the architectural equivalent of TDD — the types are the test. The Two-Adapter Rule from chapter 5 starts here: the interface is written before the first adapter exists, and the contract test suite is sketched before the drift database is created.

**Wire the analyzer early.** `analysis_options.yaml` at root, `public_member_api_docs`, `todo: error`, `dart analyze --fatal-infos --fatal-warnings` — step seven, not step twenty. A new project with a dirty analyzer is a new project that will never be clean. The zero-tolerance rule is cheapest on day one; every day after that it costs more.

**The first use case is the proof.** Step eight: write the first use case with terse docs, both `Either` sides covered by a mocktail test, and commit it. This is the vertical slice — the smallest complete example of every rule the doctrine enforces. If the checklist ends here, the project has not bootstrapped; it has just started.

The checklist is not exhaustive — it does not mention CI, or READMEs, or the first real datasource. It stops at the point where the pattern is established and the team can follow it without a list. That is what a growth ritual is for: to make the first steps automatic so the interesting work can begin.
