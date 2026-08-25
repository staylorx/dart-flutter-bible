# 5. Persistence: Where the Contract Earns Its Keep

Chapter 4 made failure a value; this chapter makes the boundary a contract you can test. The persistence doctrine is the Two-Adapter Rule in its full weight — the reason chapter 1 called it self-enforcing.

**The contract lives in the domain.** `IAccountRepository` and `IAccountDatasource` are defined in `thing_domain`, not in the adapter. The domain owns the interface; the outside world implements it. This is the inversion that makes the bulls-eye real: the center does not know storage exists, yet it dictates what storage must do.

**Two adapters, one suite.** A repository without a second adapter is a rumor. The drift-backed sqlite adapter proves the store works; the in-memory adapter proves the contract is not an accident of one implementation. The contract test suite is the referee: it runs against every adapter in CI, and a deviation in any one of them fails the build. You do not trust the team to keep the interface honest; you write a test that does not care who wrote the adapter.

**Drift is the exception that proves the rule.** Chapter 7 will ban codegen builders across the board — except drift. The ORM earns it because the generated SQL-to-Dart mapping is a contract hand-maintained code routinely gets wrong. Tables are classes, DAOs are generated, and tests run on `NativeDatabase.memory()` so the suite is fast and hermetic. The rest of the doctrine is hand-written; this one piece is allowed to be generated because the mapping is mechanical and the cost of error is high.

**UnitOfWork is optional, never required.** Write methods expose `IUnitOfWork? uow` so transactions can compose when they need to, but reads may take one and never demand it. The adapter wraps a real transaction or gracefully sinks — the use case does not care. This is the seam that lets a CLI script and a Flutter form share the same repository without either knowing the other's transaction model.

The result is persistence that is boring in the best way: the contract is the star, the adapters are interchangeable, and the tests are the proof. When a new store arrives — postgres, a network cache, a file-based sembast — it does not change the domain. It implements the contract and runs the suite. That is what it means for the boundary to hold.
