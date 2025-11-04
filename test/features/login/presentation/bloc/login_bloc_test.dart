import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/login/domain/entities/user.dart';
import 'package:template_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:template_app/features/login/presentation/bloc/login_event.dart';
import 'package:template_app/features/login/presentation/bloc/login_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

const tUser = User(
  id: 1,
  username: 'testuser',
  email: 'test@example.com',
  token: 'test_token_123',
  firstName: 'Test',
  lastName: 'User',
);

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(mockLoginUseCase);
  });

  setUpAll(() {
    registerFallbackValue(const LoginParams(username: '', password: ''));
  });

  tearDown(() {
    loginBloc.close();
  });

  const tParams = LoginParams(username: 'testuser', password: 'password123');

  test('initial state should be LoginState with default values', () {
    expect(loginBloc.state, const LoginState());
    expect(loginBloc.state.isInitial, true);
  });

  blocTest<LoginBloc, LoginState>(
    'emits loading then success when login succeeds',
    build: () {
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => const Right(tUser));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(username: 'testuser', password: 'password123'),
    ),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(isLoading: false, user: tUser),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(tParams)).called(1);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'emits loading then error when login fails with ServerFailure',
    build: () {
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
      return loginBloc;
    },
    act: (bloc) =>
        bloc.add(const LoginSubmitted(username: 'testuser', password: 'wrong')),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(
        isLoading: false,
        failure: ServerFailure('Server error'),
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits loading then error when login fails with UnauthorizedFailure',
    build: () {
      when(() => mockLoginUseCase(any())).thenAnswer(
        (_) async => const Left(UnauthorizedFailure('Invalid credentials')),
      );
      return loginBloc;
    },
    act: (bloc) =>
        bloc.add(const LoginSubmitted(username: 'testuser', password: 'wrong')),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(
        isLoading: false,
        failure: UnauthorizedFailure('Invalid credentials'),
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits initial state when LoginReset is added',
    build: () => loginBloc,
    seed: () =>
        const LoginState(isLoading: false, failure: ServerFailure('Error')),
    act: (bloc) => bloc.add(LoginReset()),
    expect: () => [const LoginState()],
  );
}
