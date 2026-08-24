# 4. The Functional Core: Failure as a Value

This is the chapter the whole doctrine has been circling since chapter 1.
The four laws say failure is a value and exceptions live only at the UI
ring; here is what that means in code, and why it is worth the ceremony.

**Exceptions are invisible control flow.** When code throws, the compiler
is not on your side anymore. Every function between the throw and the
catch is a hole in your understanding: the happy path is the only path
the type system checks, and the error path is whatever the runtime
decides. That is not error handling; that is archaeology. You find the
holes at 2 a.m., when the widget tree is on fire and the stack trace
points at a `Future` that swallowed the real exception two frames ago.

**Failure as a value makes the compiler a reviewer.** The signature
`Future<Either<AccountFailure, Account>>` says it plainly: this call can
fail, here is exactly how, and you cannot ignore that and walk away. The
type system forces the conversation that exceptions let you skip. The
bible's own doc for this section calls the failure style *rust-style* —
and that is the right word. Chapter 0 promised that Dart with FP is like
Rust for people who don't hate themselves; this is the chapter where the
promise gets kept. `Either<AccountFailure, Account>` is `Result<T, E>`
with a calmer personality, and a `sealed` failure hierarchy is a Rust
enum with the exhaustive match built in.

**Closed hierarchies, exhaustive switches.** Failures are defined in the
domain package, per layer, and closed: an abstract base with final or
`sealed` leaves. That one word — `sealed` — is the whole trick. A
`switch` over the failures must be exhaustive, so when you add a new
failure case, the compiler walks you through every call site that needs
to care. Adding a failure is a project-wide conversation, not a silent
gap. This is what chapter 1 meant by turning error handling into a
type-system feature; here is the mechanism.

**Where exceptions still exist.** The rule is stated once, loudly: no
`throw`, no `try/catch` inside the bulls-eye. Third-party libraries
throw — that is their convention, and we do not fight it — so the
adapter boundary converts their exceptions into a `Left`, exactly once,
at the door: `TaskEither.tryCatch(...)`. The UI ring is the only place
exceptions are raised or caught, and even there they are converted into
UI state as fast as possible. Datasource failures get their own low-level
hierarchy, mapped upward by the repository into domain failures. Nothing
leaks across layers; each layer speaks its own dialect, on purpose.

**The daily habit.** You write a use case; you document it; you handle
both sides from day one, and the tests cover both sides from day one.
The choreography stops being ceremony and becomes rhythm — the type
table (sync, async, absent, rarely absent) picks the tool, the signature
reads like the business operation, and `Either.Do` keeps multi-step
chains readable without a tower of `flatMap`s. The result is code where
"what can go wrong" is always one glance away, in the signature, instead
of one debugger session away, in the stack.
