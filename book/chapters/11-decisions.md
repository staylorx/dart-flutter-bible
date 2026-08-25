# 11. Decisions: The Change Record Is the Doctrine's Memory

Chapter 1 called the doctrine the current stop on a long road; chapter 0 showed where the road came from. This chapter is the map of the forks taken on purpose — the settled decisions that narrow the practice to a doctrine that can be remembered.

**The doctrine lives in §1–§10.** This chapter does not repeat it. It records *that* a decision was made, *where* it is written down, and *why*. If a section changes, the doctrine wins and this table points at the new reality. The change record is not a parallel index; it is the audit trail that keeps the standard honest.

**Riverpod, plain providers, no generator.** The settled row points at §8 and the reason: codegen-free state, manual wiring, the no-builders rule intact. When a team member asks "why not riverpod_generator," the answer is not "because we said so" — it is "here is the trade-off we made, and here is why it holds."

**fpdart ^1.2.0 pinned.** The row records the constraint and the reason: 2.0-dev is a pre-release Effect rewrite, and the stable API is what the examples and CI test. When fpdart 3.0 ships, the row will be updated, and the doctrine will change on purpose — not by drift, but by proposal.

**The proposals section is the future.** When a new idea arrives — a different failure style, a new adapter, a lint that should be automated — it goes here first. A proposal is a PR that changes the doctrine and adds a row. If the proposal is rejected, the row never lands, but the PR is still the record of why. The doctrine grows by deliberate forks, not by silent erosion.

**The row is the why.** Every settled decision has a one-line reason. "Drift for sqlite3: typed ORM, testable with `NativeDatabase.memory()`." The reason is not exhaustive — the section carries the detail — but it is enough to answer "why this and not that?" The change record is the doctrine's memory, and the memory is what makes the standard a standard instead of a preference.

Chapter 0 promised that when a rule looks arbitrary, trace it back — the lineage is usually talking. This chapter is one place the lineage speaks. The other is the code.
