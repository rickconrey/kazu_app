import 'package:kazu_app/models/PuffEvent.dart';

abstract class ChartEvent {}

class ChartInitializeData extends ChartEvent {}

class ChartUpdateData extends ChartEvent {
  final PuffEvent event;

  ChartUpdateData({required this.event});
}