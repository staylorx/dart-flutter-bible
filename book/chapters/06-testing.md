# 6. Testing: The Idiom Is the Architecture

The testing doctrine is the quiet enforcer. It is not a section about coverage percentages or pyramid metaphors — it is about the specific voice tests use, and why that voice matters.

**`shouldly` is the assertion library.** `value.should.be(...)` reads like English because the test is documentation. The doctrine is explicit: never mix `expect()` with shouldly in the same file. One voice per test, and the voice is chosen. This is not pedantry; it is the same instinct that made the toolchain zero-tolerance. A test suite with two assertion styles is a codebase with two dialects — the reader has to translate, and translation is where errors hide.

**Given/When/Then is the structure.** `group('Given GetAccountUseCase')` / `when('the account exists')` / `test('Then it returns the account')` — the test name is a sentence, and the sentence is the specification. The structure matters because it forces the test to be about behavior, not implementation. A Given/When/Then test cannot be a tautology; it has to describe a real business rule.

**Mocks live at the use-case seam.** mocktail mocks the repository interface, not the implementation. The use case is the unit under test; everything inward is real, everything outward is mocked. This is the testing version of the Two-Adapter Rule: the contract is what gets verified, and the seam is where the verification happens. A test that mocks a datasource is testing the mock, not the code.

**Both sides, every time.** Because failure is a value (chapter 4), every use case returns `Either<Failure, Success>`, and every test covers both sides. The happy path proves the feature works; the failure path proves the contract holds. A test suite that only asserts `isRight()` is a suite that will discover the `Left` in production.

The testing doctrine is short because the rules are few. But they are the rules that make the rest of the doctrine inspectable. When chapter 10's review checklist asks "both Either sides covered?", it is asking whether this chapter got followed. The idiom is the architecture: if you can read the test, you can trust the code.
