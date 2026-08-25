# 0. Why Dart, and Where This Comes From

Every team that hears "one architecture, one error-handling style, one
language, no exceptions" asks the same question, and it is a fair one:
*why not Rust?* Rust + Flutter works — it works great, and plenty of
production apps prove it. This chapter answers that question first,
because it is the one this book has to earn the right to dismiss — and
then it goes further back, because the doctrine itself is not new either.

**What Rust is for.** Rust is the systems language of our generation:
memory safety without a garbage collector, fearless concurrency,
zero-cost abstractions. When your program is a device driver, a protocol
hot path, or a game engine, that is not a preference — it is the job
requirement. The borrow checker is the price of admission, and for that
class of software it is a bargain.

**What business software is for.** Business software is different. It
moves records, enforces rules, talks to other systems, and renders user
interfaces. Its failure modes are not segfaults and data races; they are
logic errors, integration drift, and the slow decay of an architecture
that nobody can change safely. Its bottleneck is not cycles per second —
it is iteration speed and the number of mental models a team can hold at
once. Garbage collection is a feature. Hot reload is a feature. One
language from the API server to the widget tree is a feature.

**Dart gives you the safety culture without the tax.** This is the
throughline. Dart is sound, null-safe, statically typed, and AOT-compiled
to native — and the doctrine adds the rest of the safety culture: sealed
failure hierarchies, `Either` as a failure value, immutable equatable
entities, one class per file. The compiler catches the class of bugs that
business software actually has, without the ownership grammar. fpdart's
`Either` is `Result`'s calmer cousin — and `TaskEither` is `Result` that
understands async, which is where the real profit lies in a UI-driven
world. You keep type-checked failure handling, exhaustive switches, and
the discipline of immutable state — and you lose the borrow checker
arguing with you about everything.

**Rust + Flutter works — and that is the trap.** The FFI bridge is real,
fast, and well-trodden. But the bridge is also a new failure surface and
a second mental model: two toolchains, two error philosophies (panics on
one side, exceptions or values on the other), serialization at the
boundary, and every developer holding both languages in their head. For a
systems product with a thin UI, that is the right trade. For business
software, it is a tax on every future change — and the tax compounds
with team size.

**The place for each.** The doctrine's own topology keeps the boundary
honest. The bulls-eye stays pure Dart; if a genuine hot path ever shows
up, the adapter pattern is the door — native code behind an interface is
exactly what adapters are for. Rust for the metal, Dart for the business.
If you came here from Rust, welcome: the failure philosophy will feel
familiar, and the borrow checker will not follow you. The one profit that
lies for those who embrace `TaskEither` is that async stays in the type —
`Result` with a `Future` already inside it, no wraps, no unwraps at every
call site.

**The road behind the doctrine.** Before the bulls-eye was our diagram,
it was somebody else's. That is not a disclaimer — it is the point. The
doctrine in this book is not a house style invented in a meeting; it is
the current stop on a long road, and the bulls-eye is the signpost. If
you know where the road came from, the rules stop looking arbitrary.

Software used to be a flat file of instructions, and then OOP gave us
objects, and layered architecture gave us the first real answer to
"where does this code go?": presentation on top, business in the middle,
data at the bottom. It worked — until it didn't. Layers leaked. The
shape of the database crept into the business objects. The UI decided
what the domain meant.

Alistair Cockburn's Hexagonal Architecture — ports and adapters, 2005 —
made the decisive move: the application sits in the center, and the
outside world connects through *ports*. Databases, UIs, APIs: all
adapters, interchangeable at the edges. The center does not know what is
outside it.

Robert C. Martin drew the same idea as circles in 2012 and named it Clean
Architecture. The bulls-eye: entities at the center, use cases wrapped
around them, adapters outside, frameworks at the rim. Two rules carry the
whole picture: dependencies point inward, and the center knows nothing
about the outside.

**What we keep, what we add.** The bulls-eye in chapter 1 is Martin's
diagram. What the bible contributes is a Dart/Flutter instantiation with
the loose ends tied: the two-adapter rule makes "interchangeable
adapters" enforceable instead of aspirational; fpdart's `Either` makes
"failure is a value" a type you cannot ignore; sealed per-layer failures,
terse docs, one barrel per package, no builders except drift — those are
the sharp edges that turn a diagram into a discipline.

**What this means for the rest of the book.** When a rule looks
arbitrary, trace it back — this lineage is usually talking. When this
book says "the standard wins," it means the standard wins until a better
idea comes up the road; chapter 11 is the record of those forks, made on
purpose.
