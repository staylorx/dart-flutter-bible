# 11. Decisions — Change Record

Doctrine lives in §1–§10 — that is the single source of truth. This section only records *that* a decision was settled, *where* it is written down, and *why*. It is deliberately not a parallel doctrine index; if a section changes, the doctrine wins and this table points at the new reality.

### Settled

| Decision | Documented in | Why |
|---|---|---|
| Riverpod, plain providers, no generator | §8 Flutter Ring | Codegen-free state; manual wiring keeps the no-builders rule intact |
| Manual constructor injection (no get_it/injectable) | §8 Flutter Ring | Codegen-free; composition root in the app |
| go_router for navigation | §8 Flutter Ring | Boring, one file, works |
| drift for sqlite3 (only sanctioned builder) | §5 Persistence, §7 Builders | Typed ORM; testable with `NativeDatabase.memory()` |
| shouldly + mocktail, Given/When/Then names | §6 Testing | "should be" idiom; mocks only at the use-case seam |
| fpdart ^1.2.0 pinned everywhere | §4 Functional Core | Failure is a value; 2.0-dev is a pre-release Effect rewrite |
| Terse `///` docs on every public member | §2 Toolchain | dartdoc/pub.dev-ready; `public_member_api_docs` gates it |
| Use-case `call()` takes discrete business params | §4 Functional Core | Signature is the documentation; no cargo objects |
| Named params (sole exceptions: `ref`/`message`); Flutter follows Flutter | §2 Toolchain | Readable call sites; don't fight the framework |
| One hand-written barrel per package | §2 Toolchain | `src/` is private; what's exported *is* the public API |
| UnitOfWork | §5 Persistence | Optional `IUnitOfWork? uow` on write methods, never reads; adapters wrap real transactions or gracefully sink |
| Lint-enforced vs review-enforced split | §2 Toolchain | Self-enforce what's automatable; taste rules stay in review |

### Proposals

_None open. Propose in a PR; when settled, add a row above and update the section it documents._

### Roadmap

- **Team promotion:** this bible is destined for a team-facing git wiki. Vault doc stays canonical; the wiki is a published rendering.
