import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/repositories/data_repository.dart';

import '../events/chart_event.dart';
import '../states/chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final DataRepository dataRepository;

  ChartBloc({
    required this.dataRepository,
  }) : super (ChartState());

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {

  }

}