import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/chart_navigator_cubit.dart';
import 'package:kazu_app/cubit/home_navigator_cubit.dart';
import 'package:kazu_app/widgets/chart_widgets.dart';
import 'package:kazu_app/widgets/event_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/chart_bloc.dart';
import '../blocs/feed_bloc.dart';
import '../repositories/data_repository.dart';
import '../session_cubit.dart';
import '../states/chart_state.dart';
import '../states/feed_state.dart';

class TodayView extends StatelessWidget{
  const TodayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChartNavigatorCubit()),
        BlocProvider(
          create: (context) => ChartBloc(
            dataRepository: context.read<DataRepository>(),
            user: context.read<SessionCubit>().currentUser,
          ),
        ),
      ],
      child: BlocBuilder<ChartNavigatorCubit, int>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Kazu"),
            leading: IconButton(
              onPressed: () {
                context.read<SessionCubit>().selectUser(null);
                BlocProvider.of<HomeNavigatorCubit>(context).showProfile();
              },
              icon: const Icon(Icons.person),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<ChartBloc, ChartState>(builder: (c, s) {
                context.read<FeedBloc>().chartBloc = context.read<ChartBloc>();
                return IndexedStack(
                  index: state,
                  children: [
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      child: s.todayData != null
                          ? buildTodayChart(s.todayData!, s.todayTicks!)
                          : const CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      child: s.weekData != null
                          ? buildWeekChart(s.weekData!, s.weekTicks!)
                          : const CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      child: s.todayData != null
                          ? buildMonthChart(s.monthData!, s.monthTicks!)
                          : const CircularProgressIndicator(),
                    ),
                    //Placeholder(
                    //  fallbackHeight: 500,
                    //),
                  ],
                );
              }),
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
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(
            children: state.userEvents != null
              ? state.userEvents!.map((item) {
                  return buildEventCard(item);
                }).toList()
              : []
          ),
        ),
      );
    });
  }

}