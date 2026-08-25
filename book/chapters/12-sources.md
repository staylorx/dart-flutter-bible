# 12. Sources of Truth: Where the Doctrine Lives

The last chapter is the shortest, because the answer is simple: the doctrine lives here. This document is canonical; everything else is a pointer, a derivation, or a convenience.

**The bible is the source.** The `docs/` folder in the dart-flutter-bible repo is the single source of truth. The skill loads it, the examples exercise it, and this book expands it — but the doctrine itself is the twelve sections you just read. When two sources disagree, this one wins. That is the whole point of having a standard.

**The skill is the loader.** `dart-clean-architecture` is the operational companion — the procedures, pitfalls, and reference files that make the doctrine actionable. It loads this document on bootstrap and review, so the agent (or the human) does not have to remember where the rules live. The skill is not the source; it is the index to the source.

**The examples are the proof.** `bible_samples` in the repo's `examples/` package is CI-tested executable code: `dart analyze --fatal-infos --fatal-warnings` plus `dart test` on every push. The doctrine's code snippets are small because the examples are real. When a rule looks arbitrary, go read the code it produced — the rule is the why made repeatable.

**The links are the context.** Melos migration guide, drift docs, fpdart pub.dev page, shouldly, mocktail, equatable, sembast — these are the upstream references the doctrine depends on. They are not the source; they are the context that makes the source possible. When melos changes its workspace syntax, the doctrine updates, and the link stays.

This book is a derived source. It takes the doctrine and adds narrative, examples, and the why behind the rules. It is generated from the same repo, and it stays in sync because the build script reads `docs/` and prepends the chapter intros. If this book and the bible disagree, the bible is right — fix the book, not the doctrine.

That is the last rule, and it is the first one too: the standard wins. Not because it is perfect, but because it is the one place where the team agreed to put the truth. Everything else — the skill, the examples, this book — is a way to keep that truth close at hand.
