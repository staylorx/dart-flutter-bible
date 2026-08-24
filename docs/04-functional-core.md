# 4. The Functional Core (fpdart)

**`fpdart: ^1.2.0` — pinned, everywhere, always.** Never the `2.0.0-dev` line (the Effect-based rewrite is still pre-release and off-limits).

### Which type, when

| Situation | Type |
|---|---|
| Sync, can fail | `Either<Failure, T>` |
| Async, can fail | `TaskEither<Failure, T>` |
| Value may be absent | `Option<T>` |
| Sync, may be absent | `IOOption<T>` (rare) |

### Failures are typed values, rust-style

Failure hierarchies are per-layer, defined in the domain package, and **closed** (abstract base + final/`sealed` leaves where the language allows — a `switch` over them must be exhaustive, which is the point):

```dart
sealed class AccountFailure {
  const AccountFailure();
}
final class AccountNotFound extends AccountFailure {
  final String id;
  const AccountNotFound(this.id);
}
final class InsufficientFunds extends AccountFailure {
  final String id;
  final double balance;
  const InsufficientFunds({required this.id, required this.balance});
}
final class RepositoryError extends AccountFailure {
  final String message;
  const RepositoryError(this.message);
}
```

Datasources get their own low-level hierarchy (`DatasourceFailure` → `SerializationFailure`, `StorageFailure`, …) that repositories **map upward** into domain failures. Never leak `DatasourceFailure` past the repository; never leak `AccountFailure` into the datasource.

### Signatures

```dart
abstract class IAccountRepository {
  Future<Either<AccountFailure, Account>> get(String id);
  Future<Either<AccountFailure, List<Account>>> list();
  Future<Either<AccountFailure, Account>> deposit({required String id, required double amount});
}
```

Use cases return the same shape:

```dart
class GetAccountUseCase {
  final IAccountRepository _repository;
  const GetAccountUseCase(this._repository);

  Future<Either<AccountFailure, Account>> call(String id) => _repository.get(id);
}
```

### Composition

- Chain with `flatMap` / `map` / `mapLeft`.
- For readability, use the **Do notation** (`fpdart` supports it) instead of nested flatMaps:

```dart
final result = await Either.Do(
  ($) async {
    final account = await $(repository.get(id));
    final updated = await $(repository.deposit(id: account.id, amount: 100));
    return updated;
  },
);
```

- Convert third-party exceptions *at the adapter boundary only*: `TaskEither.tryCatch(() => ..., (e, st) => DatasourceFailure(...))`. The instant a third-party call throws, it becomes a `Left` and never propagates as an exception.

### Equality: equatable

Every entity and value object `extends Equatable` with `List<Object?> get props => [...]`. This gives value semantics for `==` and `hashCode`, which fpdart pattern matching, testing, and drift row mapping all rely on. Hand-written, no codegen.

### The exception rule, stated once, loudly

**Inside the bulls-eye: no `throw`, no `try/catch` (except `tryCatch` conversion at adapter boundaries), no `on Exception`.** The UI ring is the *only* place exceptions are raised or caught, and even there they should be converted into UI state as fast as possible.

---
