# 6. Testing Doctrine

### The idiom: shouldly, "should be"

**`shouldly`** (yes, `shouldly` — pronounced "should-lee", package on pub.dev) is the assertion library. The idiom is plain-English: `value.should.be(...)`.

```dart
final result = await useCase.call(id: 'acct1');
result.isRight().should.be(true);
final account = result.getOrElse((_) => fail('expected Right'));
account.balance.should.be(1000);
account.id.should.be('acct1');
```

Rules:
- **Never mix `expect()` with shouldly in the same assertion or test file.** Pick one voice; we pick shouldly.
- `Should.throwError(() => ...)` for the rare code path that legitimately throws (UI-boundary code, third-party conversions).
- Conjunctions read nicely: `result.should.not.beNull.and.beOfType<Account>()`.
- Test names are **Given/When/Then**:

```dart
group('Given GetAccountUseCase', () {
  group('When the account exists', () {
    test('Then it returns the account', () async { ... });
  });
});
```

### Where tests live (layer matrix)

| Layer | Package | Technique |
|---|---|---|
| Domain | `thing_domain/test` | **Unit tests**, pure, no mocks — construct entities, exercise rules |
| Application | `thing_usecases/test` | **Mocking at the use-case seam** with `mocktail` (mock the repository/datasource *interface* only) |
| Datasource adapters | `*_datasource_*/test` | **In-memory real implementations** — drift `NativeDatabase.memory()`, sembast `databaseFactoryMemory` |
| Contract | shared test suite | Run the same assertions against **every** adapter |
| UI ring | `thing_flutter/test` | Widget tests; pump widgets, assert rendered state with shouldly |

### Mocktail

- **`mocktail`** for mocks — and only at the application layer, mocking interfaces we own (repository/datasource contracts). Never mock a third-party class; adapters exist to isolate those.
- Prefer real in-memory doubles over mocks when one exists (the second adapter *is* the double).
- `registerFallbackValue` when a mock receives objects.

### Coverage of failure paths

Every use case test asserts **both** sides of the Either: the `Right` happy path and each `Left` failure (missing entity, invalid input, repository error). A failure path without a test is a bug waiting for the UI to display it.

---
