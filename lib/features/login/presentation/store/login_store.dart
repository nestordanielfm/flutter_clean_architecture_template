import 'package:mobx/mobx.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/login/domain/entities/user.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final LoginUseCase loginUseCase;

  _LoginStore(this.loginUseCase);

  @observable
  bool isLoading = false;

  @observable
  User? user;

  @observable
  Failure? failure;

  @computed
  bool get isSuccess => user != null;

  @computed
  bool get isError => failure != null;

  @computed
  bool get isInitial => !isLoading && user == null && failure == null;

  @action
  Future<void> login(String username, String password) async {
    isLoading = true;
    failure = null;

    final result = await loginUseCase(
      LoginParams(username: username, password: password),
    );

    result.fold(
      (fail) {
        failure = fail;
        isLoading = false;
      },
      (userData) {
        user = userData;
        isLoading = false;
      },
    );
  }

  @action
  void reset() {
    isLoading = false;
    user = null;
    failure = null;
  }
}
