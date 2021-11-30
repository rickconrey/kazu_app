import 'package:flutter_bloc/flutter_bloc.dart';

class ChartNavigatorCubit extends Cubit<int>{
  ChartNavigatorCubit() : super(0);

  void selectTab(int index) => emit(index);
}