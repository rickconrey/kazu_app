import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/chart_navigator_cubit.dart';
import 'package:kazu_app/cubit/home_navigator_cubit.dart';
import 'package:kazu_app/widgets/chart_widgets.dart';
import 'package:kazu_app/widgets/event_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/feed_bloc.dart';
import '../session_cubit.dart';
import '../states/feed_state.dart';

class TodayView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(create: (context) => ChartNavigatorCubit(),
      child: BlocBuilder<ChartNavigatorCubit, int>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Kazu"),
            leading: IconButton(
              onPressed: () =>
                  BlocProvider.of<HomeNavigatorCubit>(context).showProfile(),
              icon: const Icon(Icons.person),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IndexedStack(
                index: state,
                children: [
                  SizedBox(
                    height: 500,
                    child: buildTodayChart(),
                  ),
                  SizedBox(
                    height: 500,
                    child: buildWeekChart(),
                  ),
                  SizedBox(
                    height: 500,
                    child: buildMonthChart(),
                  ),
                  //Placeholder(
                  //  fallbackHeight: 500,
                  //),
                ],
              ),
              BottomNavigationBar(
                currentIndex: state,
                onTap: (index) => context.read<ChartNavigatorCubit>().selectTab(index),
                items: const [
                  BottomNavigationBarItem(icon: Icon(MdiIcons.calendarToday), label: "Today",),
                  BottomNavigationBarItem(icon: Icon(MdiIcons.calendarWeek), label: "Week",),
                  BottomNavigationBarItem(icon: Icon(MdiIcons.calendarMonth), label: "Month",),
                ]
              ),
              _buildUserFeed(),
              _deviceButton(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _deviceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => BlocProvider.of<HomeNavigatorCubit>(context).showDevice(),
      child: const Text('Add Device'),
    );
  }

  Widget _buildUserFeed() {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return SafeArea(
          child: SizedBox(
        height: 340,
        child: ListView(
          children: state.userEvents != null
              ? state.userEvents!.map((item) {
            return buildEventCard(item);
          }).toList()
              : []
        )
      ),
      );
    });
  }

}