import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(LoginParams params);
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
