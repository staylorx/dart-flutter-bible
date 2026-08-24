# How to Read This Book

Three passes, in this order:

1. **The skim.** Read chapters 1–5 straight through. They are the
   foundation: architecture, toolchain, topology, the functional core, and
   persistence. You do not need to memorize the rules — you need the shape
   of them.
2. **The apply.** When you bootstrap a project, keep chapter 9 (the
   bootstrap checklist) open and read each section as you hit it. The
   doctrine is written to be consumed at the moment it matters.
3. **The review.** Before a code review, run chapter 10's checklist. Every
   question in it maps to a rule in an earlier chapter; if you can answer
   all ten, you have internalized the doctrine.

This book maps one-to-one onto the bible's twelve sections. Wherever the
two disagree, the standard wins — that is the whole point of having a
standard. Chapters 11 and 12 are the change record and the sources of
truth; skim them, but read them at least once so you know how the standard
grows without drifting.

One more thing: the examples in the doctrine are real — they are exercised
by CI in the bible's `examples/` package. When a rule looks arbitrary, go
read the code it produced. The rule is the *why* made repeatable.
