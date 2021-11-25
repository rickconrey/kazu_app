import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/profile/profile_view.dart';
import 'package:kazu_app/views/scan_view.dart';
import 'package:kazu_app/views/today_view.dart';

import 'cubit/home_navigator_cubit.dart';

class HomeNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeNavigatorCubit(),
      child: BlocBuilder<HomeNavigatorCubit, HomeNavigatorState>(
          builder: (context, state) {
            return Navigator(
              onPopPage: (route, result) {
                context.read<HomeNavigatorCubit>().showHome();
                return route.didPop(result);
              },
              pages: [
                MaterialPage(child: (TodayView())),
                if (state == HomeNavigatorState.profile)
                  MaterialPage(child: ProfileView()),
                if (state == HomeNavigatorState.device)
                  MaterialPage(child: ScanView())
              ],
            );
          }),
    );
  }
}