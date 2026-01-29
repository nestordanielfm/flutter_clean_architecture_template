import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/features/login/presentation/store/login_store.dart';
import 'package:template_app/features/login/presentation/widgets/login_form.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginStore _loginStore;
  late final List<ReactionDisposer> _disposers;

  @override
  void initState() {
    super.initState();
    _loginStore = getIt<LoginStore>();
    _disposers = [
      reaction(
        (_) => _loginStore.isSuccess,
        (bool isSuccess) {
          if (isSuccess) {
            context.router.replace(const HomeRoute());
          }
        },
      ),
      reaction(
        (_) => _loginStore.failure,
        (failure) {
          if (failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    ];
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: LoginForm(loginStore: _loginStore),
    );
  }
}
