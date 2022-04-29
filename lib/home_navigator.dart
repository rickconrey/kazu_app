import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/profile/profile_view.dart';
import 'package:kazu_app/views/scan_view.dart';
import 'package:kazu_app/views/today_view.dart';
import 'package:kazu_app/views/device_view.dart';

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
                switch (state) {
                  case HomeNavigatorState.profile:
                    context.read<HomeNavigatorCubit>().showHome();
                    break;
                  case HomeNavigatorState.device:
                    context.read<HomeNavigatorCubit>().showProfile();
                    break;
                  case HomeNavigatorState.scan:
                    context.read<HomeNavigatorCubit>().showProfile();
                    break;
                  case HomeNavigatorState.home:
                  default:
                    context.read<HomeNavigatorCubit>().showHome();
                    break;
                }
                //context.read<HomeNavigatorCubit>().showHome();
                return route.didPop(result);
              },
              pages: [
                const MaterialPage(child: (TodayView())),
                if (state == HomeNavigatorState.profile)
                  MaterialPage(child: ProfileView()),
                if (state == HomeNavigatorState.device)
                  MaterialPage(child: DeviceView()),
                if (state == HomeNavigatorState.scan)
                  MaterialPage(child: ScanView()),
              ],
            );
          }),
    );
  }
}