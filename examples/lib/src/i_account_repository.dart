import 'package:fpdart/fpdart.dart';

import 'account.dart';
import 'account_failure.dart';

/// Repository contract — lives in the domain package; adapters implement it.
abstract interface class IAccountRepository {
  /// Returns the account with [id], or [AccountNotFound].
  Future<Either<AccountFailure, Account>> get({required String id});

  /// Creates an account, or [AccountAlreadyExists].
  Future<Either<AccountFailure, Account>> create({
    required String id,
    required String holder,
  });
}
