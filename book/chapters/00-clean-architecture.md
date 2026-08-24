# 0. Clean Architecture: Where This Comes From

Before the bulls-eye was our diagram, it was somebody else's. That is not
a disclaimer — it is the point. The doctrine in this book is not a house
style invented in a meeting; it is the current stop on a long road, and
the bulls-eye is the signpost. If you know where the road came from, the
rules stop looking arbitrary.

**The road.** Software used to be a flat file of instructions, and then
OOP gave us objects, and layered architecture gave us the first real
answer to "where does this code go?": presentation on top, business in
the middle, data at the bottom. It worked — until it didn't. Layers
leaked. The shape of the database crept into the business objects. The UI
decided what the domain meant.

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
the loose ends tied: the two-adapter rule makes "interchangeable adapters"
enforceable instead of aspirational; fpdart's `Either` makes "failure is a
value" a type you cannot ignore; sealed per-layer failures, terse docs,
one barrel per package, no builders except drift — those are the sharp
edges that turn a diagram into a discipline.

**The Rust parallel.** The failure rule deserves a moment, because it is
quietly Rust-flavored. Rust has no exceptions; failure is a value —
`Result<T, E>` is a type, not a jump. Panics are reserved for the
boundary, where continuing would be lying. The bible's rule — exceptions
only at the UI ring, failure as a value everywhere inside — is the same
philosophy, and fpdart's `Either` is `Result`'s calmer cousin. In some
ways, Dart with FP is like Rust for people who aren't commited to wedding the borrow checker: you
get the type-checked failure handling without arguing about everything. And unlike Rust, TaskEither is Result with Futures and async, and one much profit lies for those who embrace async and TaskEither.

**What this means for the rest of the book.** When a rule looks
arbitrary, trace it back — this lineage is usually talking. When this book
says "the standard wins," it means the standard wins until a better idea
comes up the road; chapter 11 is the record of those forks, made on
purpose.
