import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/bottom_navigation_cubit.dart';
import 'package:kazu_app/feed_navigator.dart';
import 'package:kazu_app/profile/profile_view.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/session_cubit.dart';
import 'package:kazu_app/views/scan_view.dart';
import 'package:kazu_app/views/today_view.dart';

import '../blocs/feed_bloc.dart';
import '../home_navigator.dart';
import 'feed_view.dart';

class BottomNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationCubit()),
        BlocProvider(create: (context) => FeedBloc(
          dataRepository: context.read<DataRepository>(),
          user: context.read<SessionCubit>().currentUser,
        )),
      ],
      child: BlocBuilder<BottomNavigationCubit, int>(builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state,
            children: [
              //ScanView(),
              HomeNavigator(),
              FeedNavigator(),
              //ProfileView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            onTap: (index) => context.read<BottomNavigationCubit>().selectTab(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: "Feed",
              ),
            ],
          ),
        );
      })
    );
  }
}