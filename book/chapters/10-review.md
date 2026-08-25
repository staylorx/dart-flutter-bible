# 10. Review: The Checklist as the Enforcement

Chapter 1 called the review checklist the enforcement. Here it is: a list of questions that make the doctrine's constraints observable. The rules matter; this is how we know they held.

**The machine catches what it can.** `dart analyze --fatal-infos --fatal-warnings` is the first gate — zero diagnostics, no errors, no warnings, no infos. The toolchain from chapter 2 makes this cheap: the analyzer runs in CI, and a TODO comment is a compile error. The review checklist does not waste human attention on what the machine verifies; it asks the questions the machine cannot answer.

**Dependencies point inward?** The first question is architectural: does the domain import the application layer, or vice versa? The reviewer traces imports, not behavior. A widget that reaches for a datasource fails here, even if it works. The rule is structural, not functional — working code with wrong boundaries is still wrong.

**Two adapters per repository?** This is the Two-Adapter Rule made concrete. The reviewer checks that the contract test suite runs against every adapter in CI. One adapter is a rumor; two adapters with a shared suite is a contract. The question is not "does it work?" but "does the suite prove it?"

**Failures are values?** The reviewer scans for `throw`, `try/catch` outside the UI ring, and `Either` types that never get `fold`ed. Chapter 4's promise — failure as a value, exceptions only at the boundary — is checked here. A use case that throws is a bug the compiler missed and the review must catch.

**Builders are justified?** Freezed, json_serializable, riverpod_generator — any unapproved codegen is a flag. The reviewer asks: does this encode a contract (like drift), or does it hide logic? The table from chapter 7 is the reference; the review is the audit.

**The list is the standard.** The checklist is not exhaustive — it is the minimum set of questions that catch the drift before it becomes doctrine. A review that passes this list is a review where the standard held. A review that fails is a signal: either the code is wrong, or the standard needs a fork. Chapter 11 is where those forks get recorded.
