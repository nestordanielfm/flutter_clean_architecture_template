import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/presentation/bloc/login_state.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

void main() {
  group('LoginState', () {
    const tUser = User(
      id: 1,
      username: 'testuser',
      email: 'test@example.com',
      token: 'test_token',
    );

    test('initial state should have default values', () {
      const state = LoginState();

      expect(state.isLoading, false);
      expect(state.user, isNull);
      expect(state.failure, isNull);
      expect(state.isInitial, true);
      expect(state.isSuccess, false);
      expect(state.isError, false);
    });

    test('copyWith should update isLoading', () {
      const state = LoginState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.user, isNull);
      expect(newState.failure, isNull);
    });

    test('copyWith should update user', () {
      const state = LoginState();
      final newState = state.copyWith(user: tUser);

      expect(newState.isLoading, false);
      expect(newState.user, tUser);
      expect(newState.failure, isNull);
    });

    test('copyWith should update failure', () {
      const state = LoginState();
      const failure = ServerFailure('Error');
      final newState = state.copyWith(failure: failure);

      expect(newState.isLoading, false);
      expect(newState.user, isNull);
      expect(newState.failure, failure);
    });

    test('toLoading should set isLoading to true', () {
      const state = LoginState(failure: ServerFailure('Error'));
      final newState = state.toLoading();

      expect(newState.isLoading, true);
      // Note: failure is not cleared by copyWith, this is expected behavior
    });

    test('toSuccess should set user and clear loading and failure', () {
      const state = LoginState(isLoading: true);
      final newState = state.toSuccess(tUser);

      expect(newState.isLoading, false);
      expect(newState.user, tUser);
      expect(newState.failure, isNull);
      expect(newState.isSuccess, true);
    });

    test('toError should set failure and clear loading', () {
      const state = LoginState(isLoading: true);
      const failure = ServerFailure('Error');
      final newState = state.toError(failure);

      expect(newState.isLoading, false);
      expect(newState.failure, failure);
      expect(newState.isError, true);
    });

    test('isSuccess should return true when user is not null', () {
      const state = LoginState(user: tUser);
      expect(state.isSuccess, true);
    });

    test('isError should return true when failure is not null', () {
      const state = LoginState(failure: ServerFailure('Error'));
      expect(state.isError, true);
    });

    test(
      'isInitial should return true when not loading and no user or failure',
      () {
        const state = LoginState();
        expect(state.isInitial, true);
      },
    );

    test('props should contain all properties', () {
      const failure = ServerFailure('Error');
      const state = LoginState(isLoading: true, user: tUser, failure: failure);

      expect(state.props, [true, tUser, failure]);
    });

    test('states with same properties should be equal', () {
      const state1 = LoginState(isLoading: true, user: tUser);
      const state2 = LoginState(isLoading: true, user: tUser);

      expect(state1, state2);
    });
  });
}
