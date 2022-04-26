import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import '../events/chart_event.dart';
import '../models/User.dart';
import '../states/chart_state.dart';
import '../widgets/chart_widgets.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final DataRepository dataRepository;
  final User user;

  updatePuffEvents(PuffEvent event) {
    add(ChartUpdateData(event: event));
  }

  ChartBloc({
    required this.dataRepository,
    required this.user,
  }) : super (ChartState()) {
    if (state.todayTicks == null && state.todayData == null) {
      add(ChartInitializeData());
    }

  }

  List<charts.TickSpec<String>> _buildTodayTicks() {
    List<charts.TickSpec<String>> chartTicks = [];
    chartTicks.add(const charts.TickSpec('0', label: 'AM'));
    for (int i = 1; i < 12; i++) {
      chartTicks.add(charts.TickSpec(i.toString(), label: ''));
    }
    chartTicks.add(const charts.TickSpec('12', label: 'NOON'));
    for (int i = 13; i < 23; i++) {
      chartTicks.add(charts.TickSpec(i.toString(), label: ''));
    }
    chartTicks.add(const charts.TickSpec('23', label: 'PM'));

    return chartTicks;
  }

  List<charts.TickSpec<String>> _buildWeekTicks() {

    DateTime dt = DateTime.now();
    List<DateTime> dateList = [
      dt.subtract(const Duration(days: 6)),
      dt.subtract(const Duration(days: 5)),
      dt.subtract(const Duration(days: 4)),
      dt.subtract(const Duration(days: 3)),
      dt.subtract(const Duration(days: 2)),
      dt.subtract(const Duration(days: 1)),
      dt.subtract(const Duration(days: 0)),
    ];

    List<charts.TickSpec<String>> chartTicks = [];
    for (int i = 0; i < 7; i++) {
      charts.TickSpec(
        i.toString(),
        label: DateFormat('E').format(dateList[i]),
      );
    }

    return chartTicks;
  }

  List<charts.TickSpec<String>> _buildMonthTicks() {
    DateTime dt = DateTime.now();
    List<DateTime> dateList = [];

    for (int i = 0; i < 30; i++) {
      dateList.add(dt.subtract(Duration(days: 29 - i)));
    }

    List<charts.TickSpec<String>> chartTicks = [];
    chartTicks.add(charts.TickSpec('0', label: DateFormat("MMMd").format(dateList[0])));
    for (int i = 1; i < 15; i++) {
      chartTicks.add(charts.TickSpec(i.toString(), label: ''));
    }
    chartTicks.add(charts.TickSpec('15', label: DateFormat("MMMd").format(dateList[15])));
    for (int i = 16; i < 29; i++) {
      chartTicks.add(charts.TickSpec(i.toString(), label: ''));
    }
    chartTicks.add(const charts.TickSpec('29', label: 'TODAY'));
    return chartTicks;
  }

  Future<List<TimeSeriesAmount>> _buildTodayData(DateTime now) async {
    int startTime = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;
    int endTime = DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch ~/ 1000;
    String userId = user.id;

    List<PuffEvent>? events = await dataRepository.getPuffEventsByDateRange(userId, startTime, endTime);

    List<TimeSeriesAmount> todayData = [];
    for (int i = 0; i < 24; i++) {
      todayData.add(TimeSeriesAmount(time: i.toString(), amount: 0));
    }

    if (events != null) {
      for (PuffEvent e in events) {
        if (e.time == null) {
          continue;
        }
        int hour = DateTime.fromMillisecondsSinceEpoch(e.time!.toSeconds() * 1000).hour;
        todayData[hour].amount += (e.amount ?? 0);
      }
    }
    return todayData;
  }

  Future<List<TimeSeriesAmount>> _buildWeekData(DateTime now) async {
    int startTime = DateTime(now.year, now.month, now.day - 7).millisecondsSinceEpoch ~/ 1000;
    int endTime = DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch ~/ 1000;
    String userId = user.id;

    List<PuffEvent>? events = await dataRepository.getPuffEventsByDateRange(userId, startTime, endTime);

    List<TimeSeriesAmount> weekData = [];
    for (int i = 0; i < 7; i++) {
      weekData.add(TimeSeriesAmount(time: i.toString(), amount: 0));
    }

    return weekData;
  }

  Future<List<TimeSeriesAmount>> _buildMonthData(DateTime now) async {
    int startTime = DateTime(now.year, now.month, now.day - 30).millisecondsSinceEpoch ~/ 1000;
    int endTime = DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch ~/ 1000;
    String userId = user.id;

    List<PuffEvent>? events = await dataRepository.getPuffEventsByDateRange(userId, startTime, endTime);

    List<TimeSeriesAmount> monthData = [];
    for (int i = 0; i < 30; i++) {
      monthData.add(TimeSeriesAmount(time: i.toString(), amount: 0));
    }

    return monthData;
  }

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    if (event is ChartInitializeData) {
      //TemporalDateTime now = TemporalDateTime.now();
      DateTime now = DateTime.now();

      List<charts.TickSpec<String>> todayTicks = _buildTodayTicks();
      List<TimeSeriesAmount> todayData = await _buildTodayData(now);

      List<charts.TickSpec<String>> weekTicks = _buildWeekTicks();
      List<TimeSeriesAmount> weekData = await _buildWeekData(now);

      List<charts.TickSpec<String>> monthTicks = _buildMonthTicks();
      List<TimeSeriesAmount> monthData = await _buildMonthData(now);

      yield state.copyWith(
        todayData: todayData,
        todayTicks: todayTicks,
        weekData: weekData,
        weekTicks: weekTicks,
        monthData: monthData,
        monthTicks: monthTicks,
      );
    } else if (event is ChartUpdateData) {
      List<TimeSeriesAmount> todayData = state.todayData ?? [];

      if (event.event.time != null) {
        int hour = DateTime.fromMillisecondsSinceEpoch(event.event.time!.toSeconds() * 1000).hour;
        todayData[hour].amount += (event.event.amount ?? 0);
      }
      yield state.copyWith(todayData: todayData);
    }
  }
}