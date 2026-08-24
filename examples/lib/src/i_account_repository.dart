import 'package:fpdart/fpdart.dart';

import 'account.dart';
import 'account_failure.dart';
import 'i_unit_of_work.dart';

/// Repository contract — lives in the domain package; adapters implement it.
abstract interface class IAccountRepository {
  /// Returns the account with [id] — reads never need a unit of work.
  Future<Either<AccountFailure, Account>> get({required String id});

  /// Creates an account; pass [uow] to join a larger transaction.
  Future<Either<AccountFailure, Account>> create({
    required String id,
    required String holder,
    IUnitOfWork? uow,
  });
}
