import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const tUser = User(
  id: 1,
  username: 'testuser',
  email: 'test@example.com',
  token: 'test_token_123',
  firstName: 'Test',
  lastName: 'User',
);

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tParams = LoginParams(username: 'testuser', password: 'password123');

  test('should return User when repository call is successful', () async {
    // Arrange
    when(
      () => mockRepository.login(tParams),
    ).thenAnswer((_) async => const Right(tUser));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Right(tUser));
    verify(() => mockRepository.login(tParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure('Server error');
    when(
      () => mockRepository.login(tParams),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.login(tParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return UnauthorizedFailure on invalid credentials', () async {
    // Arrange
    const tFailure = UnauthorizedFailure('Invalid credentials');
    when(
      () => mockRepository.login(tParams),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.login(tParams));
  });
}
