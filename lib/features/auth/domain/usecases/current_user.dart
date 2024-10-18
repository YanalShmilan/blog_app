import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, void> {
  final AuthRepository repository;

  CurrentUser(this.repository);
  @override
  Future<Either<Failure, User>> call(void params) async {
    return await repository.getCurrentUser();
  }
}
