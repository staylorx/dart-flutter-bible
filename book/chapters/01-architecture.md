# 1. The Bulls-Eye: Why Structure Is the Product

Every Flutter shop has seen the same ghost story: a widget that fetches
data, formats it, decides what to show, and — somewhere in the middle —
writes a file. It works. It ships. Six months later, the third developer
to touch it opens the file and quietly wonders who hurt them.

The bulls-eye exists so that file never happens. It is the doctrine's
answer to a simple question: *what is the part of your app you can least
afford to re-learn?*

![The bulls-eye: dependencies point inward; exceptions live only in the UI ring](book/diagrams/bulls-eye.png)

The answer is the center: the entities and rules that decide what your
business means. That center has no I/O, no Flutter, no packages beyond
equatable and fpdart. It is pure. And because it is pure, it is
unit-testable in milliseconds, portable to any delivery mechanism, and
immune to the framework churn that eats most apps.

The Four Laws are just that answer, stated as constraints:

1. **Dependencies point inward.** The center must not know the outside
   exists. This is what makes the center cheap to test and cheap to keep.
2. **Entities are the center.** Immutable, equatable; operations return
   new instances. Mutable state is where "it worked yesterday" lives.
3. **Flow is one direction.** UI → use case → repository → datasource.
   No sideways jumps; no widget reaching for a datasource.
4. **Exceptions are a UI-boundary phenomenon.** Inside the bulls-eye,
   failure is a value. This is the rule that turns "error handling" from
   a chore into a type-system feature.

![One-direction flow, with two adapters sharing one contract suite](book/diagrams/dependency-flow.png)

The two-adapter rule is the one the team never skips, because it is the
only rule that is *self-enforcing*. One adapter means the contract is
whatever that adapter happens to do. Two adapters — say, drift and
in-memory — plus a shared contract suite mean the interface is the thing
being tested, and a deviation in any implementation fails CI. The rule
doesn't ask you to trust the team; it asks the test suite to do the
watching.

None of this is new. Uncle Bob drew the circles decades ago. What this
chapter adds is the part the original drawings leave out: the order in
which the layers get built, and the failure modes that make each law
worth the ceremony. The bootstrap checklist (chapter 9) is that order;
the review checklist (chapter 10) is the enforcement.
