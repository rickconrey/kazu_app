import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/profile/profile_view.dart';
import 'package:kazu_app/views/comments_view.dart';
import 'package:kazu_app/views/feed_view.dart';

import 'cubit/feed_navigator_cubit.dart';

class FeedNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedNavigatorCubit(),
      child: BlocBuilder<FeedNavigatorCubit, FeedNavigatorState>(
          builder: (context, state) {
            return Navigator(
              onPopPage: (route, result) {
                context.read<FeedNavigatorCubit>().showHome();
                return route.didPop(result);
              },
              pages: [
                MaterialPage(child: (FeedView())),
                if (state == FeedNavigatorState.profile)
                  MaterialPage(child: ProfileView()),
                if (state == FeedNavigatorState.comments)
                  MaterialPage(child: CommentsView())
              ],
            );
          }),
    );
  }
}