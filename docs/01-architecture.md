# 1. The Bulls-Eye (Doctrine)

```
        ┌──────────────────────────────────────────┐
        │  UI / Presentation (Flutter)             │  outer ring
        │  exceptions ARE allowed here — ONLY here │
        │  ┌────────────────────────────────────┐  │
        │  │  Application / Use Cases           │  │  orchestration
        │  │  no I/O, no Flutter, no exceptions │  │  mock here in tests
        │  │  ┌──────────────────────────────┐  │  │
        │  │  │  Domain (entities)           │  │  │  THE CENTER
        │  │  │  pure: no I/O, no packages    │  │  │  unit-test here
        │  │  │  except equatable/fpdart      │  │  │
        │  │  └──────────────────────────────┘  │  │
        │  └────────────────────────────────────┘  │
        │  Datasource adapters live OUTSIDE        │
        │  (drift/sqlite, sembast, http, memory)   │
        └──────────────────────────────────────────┘
```

### The Four Laws

1. **Dependencies point inward. Always.** Domain knows nothing about application, UI, or datasources. Application knows domain. UI knows everything *through interfaces*. Nothing outside knows anything concrete about the center.
2. **Entities are the center.** Pure Dart classes: immutable (`const` constructors), value equality (`equatable`), zero I/O, zero Flutter imports. All operations return **new instances**.
3. **Flow is one direction:** UI → use case → repository interface → datasource adapter. No sideways jumps. No UI talking to a datasource. No use case instantiating a widget.
4. **Exceptions are a UI-boundary phenomenon.** Everywhere inside the bulls-eye, failure is a *value* (fpdart `Either`/`TaskEither`). Only the outermost ring may throw or catch. We are rust-like: failures are typed tuples, not jumps.

### The Two-Adapter Rule (the one we never skip)

**Every repository contract gets at least two datasource adapters.** One real persistence adapter is not enough — with only one adapter, the contract is whatever that adapter happens to do. Two adapters (e.g. drift/sqlite + in-memory, or drift + sembast) force the contract to be the *interface*, and a shared **contract test suite** runs against every adapter, so a deviation in any implementation fails CI.

In-memory adapters are legitimate second adapters, and they double as the test double for use-case tests — prefer them over mocking where feasible.

### The API surface (docs, params, style)

- **Terse docs:** every public member gets a `///` comment, 1–2 lines — *what* and *why*, never *how*. dartdoc/pub.dev-ready; the `public_member_api_docs` lint stays on. Use cases **must** be documented.
- **Business params:** a use case's `call()` takes discrete business inputs (`id`, `userName`, …), never a cargo object (`AddUserUseCase(UserBlockOfStuff(...))`). The signature is the documentation.
- **Named parameters** in Dart — sole exceptions: a single positional `ref` or `message`. Flutter widgets follow Flutter conventions.

---
