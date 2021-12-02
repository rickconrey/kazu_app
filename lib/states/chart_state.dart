import '../widgets/chart_widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartState {
  final List<TimeSeriesAmount>? todayData;
  final List<charts.TickSpec<String>>? todayTicks;
  final List<TimeSeriesAmount>? weekData;
  final List<charts.TickSpec<String>>? weekTicks;
  final List<TimeSeriesAmount>? monthData;
  final List<charts.TickSpec<String>>? monthTicks;
  ChartState({
    this.todayData,
    this.todayTicks,
    this.weekData,
    this.weekTicks,
    this.monthData,
    this.monthTicks,
  });

  ChartState copyWith({
    List<TimeSeriesAmount>? todayData,
    List<charts.TickSpec<String>>? todayTicks,
    List<TimeSeriesAmount>? weekData,
    List<charts.TickSpec<String>>? weekTicks,
    List<TimeSeriesAmount>? monthData,
    List<charts.TickSpec<String>>? monthTicks,
  }) {
    return ChartState(
      todayData: todayData ?? this.todayData,
      todayTicks: todayTicks ?? this.todayTicks,
      weekData: weekData ?? this.weekData,
      weekTicks: weekTicks ?? this.weekTicks,
      monthData: monthData ?? this.monthData,
      monthTicks: monthTicks ?? this.monthTicks,
    );
  }
}