import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final User? user;
  final Failure? failure;

  const LoginState({this.isLoading = false, this.user, this.failure});

  // Helper getters
  bool get isSuccess => user != null;
  bool get isError => failure != null;
  bool get isInitial => !isLoading && user == null && failure == null;

  // copyWith for state updates
  LoginState copyWith({bool? isLoading, User? user, Failure? failure}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  // Reset helpers
  LoginState toLoading() => copyWith(isLoading: true, failure: null);
  LoginState toSuccess(User user) =>
      copyWith(isLoading: false, user: user, failure: null);
  LoginState toError(Failure failure) =>
      copyWith(isLoading: false, failure: failure);

  @override
  List<Object?> get props => [isLoading, user, failure];
}
