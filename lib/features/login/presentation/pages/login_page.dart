import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:template_app/features/login/presentation/bloc/login_state.dart';
import 'package:template_app/features/login/presentation/widgets/login_form.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              context.router.replace(const HomeRoute());
            } else if (state.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure?.message ?? 'Login failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
