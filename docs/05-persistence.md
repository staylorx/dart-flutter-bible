# 5. Persistence Doctrine

### Contracts live in the domain

`thing_domain` defines `IAccountRepository` and `IAccountDatasource` (if the repository needs a datasource seam). The domain package owns the *contract*; it owns no implementation.

### The Two-Adapter Rule in practice

For every repository:

1. **Primary adapter** — drift/sqlite (or the platform-appropriate store).
2. **Second adapter** — in-memory (fast, hermetic tests) or a different store (sembast) when the deployment needs a portable file store.
3. **Contract test suite** — one `test/` file that takes any adapter implementation and asserts the full contract, run against **every** adapter in CI. A contract is only real when two implementations agree on it.

### sqlite3: drift is the ORM, always

- **`drift`** (+ `drift_dev`, `build_runner`) for any sqlite3 persistence. This is the **sanctioned exception to the no-builders rule** (§7) — the ORM layer earns codegen.
- Tables are `@DataClassName`-annotated Dart classes; DAOs and queries are generated.
- **Tests use `NativeDatabase.memory()`** — no files, no platform channels, fast:

```dart
final db = ThingDatabase(NativeDatabase.memory());
```

- If a second file-based adapter is needed and it can share the drift data layer (a custom `QueryExecutor`), use it — but don't force it. A plain sembast adapter behind the same datasource contract is fine and often simpler.

### File-based stores: sembast

- **sembast** is the default pure-Dart embedded file store (1 file = 1 database, works on every platform, no plugin).
- **Tests use `databaseFactoryMemory`** from `package:sembast/sembast_memory.dart`:

```dart
final db = await databaseFactoryMemory.openDatabase(inMemoryDatabasePath);
```

- Use sembast when a NoSQL document store is the right shape, or when "one file, zero plugins" matters. SQL-shaped data goes to drift.

### UnitOfWork: optional transactions at the contract

Some stores are transactional (drift, sembast, isar); some aren't (plain JSON files). The contract treats transactions as a first-class, optional thing:

```dart
abstract interface class IAccountRepository {
  /// Returns the account with [id]; pass [uow] to read consistently inside a
  /// transaction — most reads won't need it.
  Future<Either<AccountFailure, Account>> get({
    required String id,
    IUnitOfWork? uow,
  });

  /// Creates an account; pass [uow] to join a larger transaction.
  Future<Either<AccountFailure, Account>> create({
    required String id,
    required String holder,
    IUnitOfWork? uow,
  });
}
```

- **`IUnitOfWork`** is a domain-package contract (`run<T>(Future<T> Function() work)`); transactional adapters implement it over their native transaction (`db.transaction(...)`).
- **Write methods** (`create`, `update`, `delete`, …) take `IUnitOfWork? uow` — optional at the seam, so callers can join a transaction when they need atomicity. **Reads** (`get`, `list`) *may* take one too: usually they don't, but a read inside a transaction (consistency, read-your-writes) should accept it. Reads never *require* it.
- **Every adapter does the honest thing:** drift/sembast/isar wrap their real transaction; JSON and other non-transactional stores gracefully emulate or sink it (best-effort single load-modify-persist, or `NoOpUnitOfWork`). The contract still declares `uow`, so the seam is uniform — callers who need atomicity get it where the store can provide it, and nothing silently breaks where it can't.

### General rules

- Repositories orchestrate and validate; datasources do mechanical I/O. No business logic in a datasource, no I/O in a repository.
- All datasource methods return `Either`/`TaskEither` with the datasource failure hierarchy. `tryCatch` lives here.

---
