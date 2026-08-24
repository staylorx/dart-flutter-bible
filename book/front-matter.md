# Why This Book

The Dart/Flutter Bible started as a team standard: one architecture, one
error-handling style, one testing idiom, so that a developer who has seen
one of our repos has seen them all. It was written to be a reference —
compact, rule-shaped, and deliberately cold. Standards should be cold.
They get cited in code reviews and enforced by CI, and nobody wants a
poem in the middle of a review.

But a standard that only says *what* to do leaves out the part that makes
it stick: *why*. Why does the domain layer not know the word "Flutter"?
Why are failures values instead of exceptions? Why do we refuse to ship a
repository contract with only one adapter, no matter how small the app?

This book answers those questions. It walks the same doctrine, section by
section, rule by rule, but it fills in the reasoning, the failure modes
each rule exists to prevent, and the order in which to apply it. The repo
stays the source of truth; this is the guided tour.

**Who this is for:** a developer joining a codebase built on the doctrine
and wondering why it's shaped this way; a lead who has to argue for it in
front of a room; and anyone who has ever been told "dependencies point
inward" and wanted to ask, *fine, but why does that matter at 2 a.m. when
the widget tree is on fire?*

The short answer is that structure is what makes software cheap to change,
and the bulls-eye is the cheapest structure we know.
