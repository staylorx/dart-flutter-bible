# 8. Flutter: The Outer Ring (1/3 of the bible)

Flutter is delivery. All the doctrine above applies *behind* it; this section is about the boundary.

### Exceptions live here

- This is the **only** place `throw` and `try/catch` appear.
- A use case returns `Either<AccountFailure, Account>`; the widget/controller layer `fold`s it into UI state (loaded / error message / empty). The error message text is derived from the failure type at the boundary — domain failures never carry display strings.
- Third-party UI/plugin exceptions (image decode, platform channel) get caught here, converted to a user-visible state, and logged. Never swallowed.

### State management

**Riverpod with plain providers** (`flutter_riverpod`) — settled doctrine, no generator (`riverpod_annotation` is banned, §7). Use cases are exposed as providers; widgets reach use cases through providers and never see repositories, datasources, or entity construction. fpdart's own docs and examples use Riverpod, so the integration is well-trodden.

### The only seam: use cases

**Widgets interact with exactly one thing: use cases** (normally reached through providers). Hard rule, not a preference:

- No widget imports a repository, a datasource, or an entity-construction factory.
- No widget reads a database, HTTP client, or platform storage — directly, or through a provider that skips the use-case seam.
- Providers wrap use cases and expose derived state (loading / data / failure). A widget's job: call use case → render state.

### Widget conventions

- **Dumb widgets:** widgets render state and emit events; they do not contain business rules, validation, or storage logic.
- One-direction flow: event → provider → use case → state → widget rebuild.
- Keep `build` methods small; extract `StatelessWidget`/`const` sub-widgets.
- No `BuildContext` passed into use cases or repositories, ever.

### Flutter tests

- Widget tests at `apps/thing_flutter/test` — pump with a test provider container (real in-memory adapters, not mocks, where possible), assert with shouldly.
- `NativeDatabase.memory()` and `databaseFactoryMemory` work in widget tests too — no platform-channel stubbing needed for the persistence path.

---
