import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/data/datasources/auth_api.dart';
import 'package:template_app/features/login/data/models/login_request.dart';
import 'package:template_app/features/login/domain/entities/user.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;

  AuthRepositoryImpl(this.authApi);

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      final request = LoginRequest(
        username: params.username,
        password: params.password,
      );
      final response = await authApi.login(request);
      return Right(response.toEntity());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure('Invalid credentials'));
      }
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        return const Left(ServerFailure('Server error'));
      }
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
