import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/entities/user.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params);
  }
}
