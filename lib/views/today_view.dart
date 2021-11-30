import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/home_navigator_cubit.dart';
import 'package:kazu_app/widgets/event_widgets.dart';

import '../blocs/feed_bloc.dart';
import '../session_cubit.dart';
import '../states/feed_state.dart';

class TodayView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kazu"),
        leading: IconButton(
          onPressed: () => BlocProvider.of<HomeNavigatorCubit>(context).showProfile(),
          icon: const Icon(Icons.person),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Placeholder(
            fallbackHeight: 500,
          ),
          _buildUserFeed(),
          //buildEventStream(context),
          _deviceButton(context),
        ],
      ),
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
      return SizedBox(
        height: 400,
        child: ListView(
          children: state.userEvents != null
              ? state.userEvents!.map((item) {
            return buildEventCard(item);
          }).toList()
              : []
        )
      );
    });
  }
}