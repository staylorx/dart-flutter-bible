# 7. Builders: The One Exception That Proves the Rule

The doctrine is blunt: avoid codegen builders. Generated code hides logic, slows builds, breaks IDE navigation, and creates a second source of truth. Almost every builder fails the test the doctrine sets: does the generated code encode a contract we would otherwise hand-maintain and get wrong?

**freezed: unnecessary.** Dart 3 has sealed classes, records, and exhaustive `switch` built in. The value-class pattern freezed popularized — immutable data classes with generated `copyWith`, `==`, and `hashCode` — is now native language. The chapter 4 failure hierarchy is sealed classes + final fields + exhaustive switch; no annotation, no build_runner, no generated file. The language caught up, and the builder is retired.

**json_serializable: unnecessary.** Hand-written `toJson`/`fromJson` is short, explicit, and debuggable. The doctrine's models are small by design; the mapping code is part of the domain, not boilerplate to hide. When drift is present, it has its own serialization for rows — no double system.

**riverpod_generator: banned.** Plain providers (`Provider`, `FutureProvider`, `NotifierProvider`) suffice. The annotation-generated providers add a build step, a hidden file, and a second syntax to learn, for zero gain. Riverpod's own docs and fpdart's examples use plain providers; the integration is well-trodden without codegen.

**drift: sanctioned.** The one exception. `build_runner` + `drift_dev` generate DAOs, table mappings, and query builders from annotated classes. The contract — SQL table ↔ Dart row — is mechanical, high-stakes, and easy to get wrong by hand. Drift passes the test: it encodes a contract we would otherwise hand-maintain and get wrong. The doctrine is not anti-codegen; it is anti-unnecessary-codegen. Drift is necessary.

**The test is the rule.** When evaluating a builder, ask: does it generate a contract? Does it remove a source of error, or does it hide one? If the answer is "it saves typing," the answer is no. The doctrine's codebase is small enough to be hand-written; the only generated code is the code that must be generated to be correct.

This chapter is short because the rule is simple. The table says it all: one checkmark, four crosses. The doctrine is not ascetic; it is precise. Builders are tools, and tools earn their place by solving a problem the language cannot. Dart 3 solved most of them. Drift solved the one that remains.
