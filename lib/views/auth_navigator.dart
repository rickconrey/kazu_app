import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/auth_cubit.dart';
import 'package:kazu_app/views/sign_up_view.dart';

import 'confirmation_view.dart';
import 'login_view.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            if (state == AuthState.login) MaterialPage(child: LoginView()),

            if (state == AuthState.signUp ||
                state == AuthState.confirmSignUp) ...[

                  MaterialPage(child: SignUpView()),
                  if (state == AuthState.confirmSignUp) MaterialPage(child: ConfirmationView())
            ]
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      }
    );
  }
}