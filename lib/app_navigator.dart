import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/session_cubit.dart';
import 'package:kazu_app/session_state.dart';
import 'package:kazu_app/views/auth_navigator.dart';
import 'package:kazu_app/views/bottom_navigation_view.dart';

import 'cubit/auth_cubit.dart';
import 'loading_view.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),

          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) => AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: AuthNavigator(),
              ),
            ),
          if (state is Authenticated)
            const MaterialPage(child: BottomNavigationView()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}