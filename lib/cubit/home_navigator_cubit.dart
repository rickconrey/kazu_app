import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeNavigatorState {home, profile, device, scan}

class HomeNavigatorCubit extends Cubit<HomeNavigatorState> {
  HomeNavigatorCubit() : super(HomeNavigatorState.home);

  void showProfile() => emit(HomeNavigatorState.profile);
  void showDevice() => emit(HomeNavigatorState.device);
  void showHome() => emit(HomeNavigatorState.home);
  void showScan() => emit(HomeNavigatorState.scan);
}