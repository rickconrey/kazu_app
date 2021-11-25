import 'package:flutter_bloc/flutter_bloc.dart';

enum FeedNavigatorState {home, profile, comments }

class FeedNavigatorCubit extends Cubit<FeedNavigatorState> {
  FeedNavigatorCubit() : super(FeedNavigatorState.home);

  void showProfile() => emit(FeedNavigatorState.profile);
  void showComments() => emit(FeedNavigatorState.comments);
  void showHome() => emit(FeedNavigatorState.home);
}