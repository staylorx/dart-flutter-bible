import 'package:fpdart/fpdart.dart';

import 'account.dart';
import 'account_failure.dart';
import 'i_account_repository.dart';

/// Creates an account from discrete business params — never a cargo object.
class CreateAccountUseCase {
  final IAccountRepository _repository;

  /// Wraps the [repository] the use case delegates to.
  const CreateAccountUseCase(this._repository);

  /// Creates the account, or [AccountAlreadyExists].
  Future<Either<AccountFailure, Account>> call({
    required String id,
    required String holder,
  }) =>
      _repository.create(id: id, holder: holder);
}
