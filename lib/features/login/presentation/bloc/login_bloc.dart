import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/login/presentation/bloc/login_event.dart';
import 'package:template_app/features/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.toLoading());

    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) => emit(state.toError(failure)),
      (user) => emit(state.toSuccess(user)),
    );
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
