import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/cubit/chart_navigator_cubit.dart';
import 'package:kazu_app/cubit/home_navigator_cubit.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/widgets/chart_widgets.dart';
import 'package:kazu_app/widgets/event_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/ble_bloc.dart';
import '../blocs/chart_bloc.dart';
import '../blocs/feed_bloc.dart';
import '../repositories/data_repository.dart';
import '../session_cubit.dart';
import '../states/ble_state.dart';
import '../states/chart_state.dart';
import '../states/feed_state.dart';

class TodayView extends StatelessWidget{
  const TodayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    String _version = "22.06.00";
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
      child: BlocListener<BleBloc, BleState>(
        bloc: BlocProvider.of<BleBloc>(context),
        listener: (context, state) {
          //if (state.state == DeviceConnectionState.connected) {
          //bleConnected = true;
          //} else {
          //bleConnected = false;
          //}
        },
        child: BlocBuilder<ChartNavigatorCubit, int>(builder: (context, state) {
          var appBar = AppBar(
            title: const Text("Kazu"),
            leading: IconButton(
              onPressed: () async {
                await context
                    .read<SessionCubit>()
                    .selectUser(context.read<SessionCubit>().currentUser.id);
                BlocProvider.of<HomeNavigatorCubit>(context).showProfile();
              },
              icon: const Icon(Icons.person),
            ),
            actions: [Text(_version)],
          );
          double appBarHeight = appBar.preferredSize.height;
          double totalHeight = screenHeight - appBarHeight - statusBarHeight;
        //if (context.read<BleBloc>().state.state == DeviceConnectionState.disconnected) {
          if (context.read<BleBloc>().state.user == null) {
            context.read<BleBloc>().add(BleAttemptAutoConnect(user: context.read<SessionCubit>().currentUser));
          }
          return Scaffold(
            appBar: appBar,
            //appBar: AppBar(
            //    title: const Text("Kazu"),
            //    leading: IconButton(
            //      onPressed: () {
            //        context.read<SessionCubit>().selectUser(null);
            //        BlocProvider.of<HomeNavigatorCubit>(context).showProfile();
            //      },
            //      icon: const Icon(Icons.person),
            //    ),
            //  ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<ChartBloc, ChartState>(builder: (c, s) {
                  context.read<FeedBloc>().chartBloc =
                      context.read<ChartBloc>();
                  return IndexedStack(
                    index: state,
                    children: [
                      SizedBox(
                        height: totalHeight * 0.4,
                        //height: MediaQuery
                        //    .of(context)
                        //    .size
                        //    .height * 0.4,
                        child: s.todayData != null
                            ? buildTodayChart(s.todayData!, s.todayTicks!)
                            : const CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: totalHeight * 0.4,
                        //height: MediaQuery
                        //    .of(context)
                        //    .size
                        //    .height * 0.4,
                        child: s.weekData != null
                            ? buildWeekChart(s.weekData!, s.weekTicks!)
                            : const CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: totalHeight * 0.4,
                        //height: MediaQuery
                        //    .of(context)
                        //    .size
                        //    .height * 0.4,
                        child: s.monthData != null
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
                    onTap: (index) =>
                        context.read<ChartNavigatorCubit>().selectTab(index),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.calendarToday),
                        label: "Today",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.calendarWeek),
                        label: "Week",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.calendarMonth),
                        label: "Month",
                      ),
                    ]),
                _buildUserFeed(totalHeight),
                //_deviceButton(context),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _deviceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => BlocProvider.of<HomeNavigatorCubit>(context).showDevice(),
      child: const Text('Add Device'),
    );
  }

  Widget _buildUserFeed(double height) {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return SafeArea(
        child: SizedBox(
          height: height * 0.3,
          //height: MediaQuery.of(context).size.height * 0.3,
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