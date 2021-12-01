import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class TimeSeriesAmount {
  final String time;
  final int amount;

  TimeSeriesAmount({required this.time, required this.amount});
}

Widget _buildChart({required List<charts.Series<TimeSeriesAmount, String>> series, required List<charts.TickSpec<String>> ticks, bool animate=false}) {
  return charts.BarChart(
    series,
    animate: animate,
    domainAxis: charts.OrdinalAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: const charts.TextStyleSpec(
          color: charts.MaterialPalette.black,
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.MaterialPalette.gray.shadeDefault,
        ),
      ),
      tickProviderSpec: charts.StaticOrdinalTickProviderSpec(ticks),
    ),
    primaryMeasureAxis: charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: const charts.TextStyleSpec(
          color: charts.MaterialPalette.black,
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.MaterialPalette.gray.shadeDefault,
        ),
      ),
    ),
  );
}

Widget buildTodayChart() {
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

  List<TimeSeriesAmount> data = [];
  for (int i = 0; i < 24; i++) {
    data.add(TimeSeriesAmount(time: i.toString(), amount: i));
  }

  var chartData = [
    charts.Series<TimeSeriesAmount, String>(
      id: 'Amount',
      colorFn: ((TimeSeriesAmount amount, _) {
        return charts.MaterialPalette.gray.shadeDefault;
      }),
      domainFn: (TimeSeriesAmount amount, _) => amount.time,
      measureFn: (TimeSeriesAmount amount, _) => amount.amount,
      labelAccessorFn: ((TimeSeriesAmount amount, _) {
        return "";
      }),
      data: data,
    ),
  ];
  return _buildChart(series: chartData, ticks: chartTicks);
}

Widget buildWeekChart() {
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

  List<charts.TickSpec<String>> chartTicks = [
    charts.TickSpec(
      '0',
      label: DateFormat("E").format(dateList[0]),
    ),
    charts.TickSpec(
      '1',
      label: DateFormat("E").format(dateList[1]),
    ),
    charts.TickSpec(
      '2',
      label: DateFormat("E").format(dateList[2]),
    ),
    charts.TickSpec(
      '3',
      label: DateFormat("E").format(dateList[3]),
    ),
    charts.TickSpec(
      '4',
      label: DateFormat("E").format(dateList[4]),
    ),
    charts.TickSpec(
      '5',
      label: DateFormat("E").format(dateList[5]),
    ),
    charts.TickSpec(
      '6',
      label: DateFormat("E").format(dateList[6]),
    ),
  ];

  List<TimeSeriesAmount> data = [
    TimeSeriesAmount(time: "0", amount: 0),
    TimeSeriesAmount(time: "1", amount: 10),
    TimeSeriesAmount(time: "2", amount: 20),
    TimeSeriesAmount(time: "3", amount: 0),
    TimeSeriesAmount(time: "4", amount: 30),
    TimeSeriesAmount(time: "5", amount: 0),
    TimeSeriesAmount(time: "6", amount: 50),
  ];
  var chartData = [
    charts.Series<TimeSeriesAmount, String>(
      id: 'Amount',
      colorFn: ((TimeSeriesAmount amount, _) {
        return charts.MaterialPalette.gray.shadeDefault;
      }),
      domainFn: (TimeSeriesAmount amount, _) => amount.time,
      measureFn: (TimeSeriesAmount amount, _) => amount.amount,
      labelAccessorFn: ((TimeSeriesAmount amount, _) {
        return "";
      }),
      data: data,
    ),
  ];
  return _buildChart(series: chartData, ticks: chartTicks);
}

Widget buildMonthChart() {
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

  List<TimeSeriesAmount> data = [];
  for (int i = 0; i < 30; i++) {
    data.add(TimeSeriesAmount(time: i.toString(), amount: i));
  }

  var chartData = [
    charts.Series<TimeSeriesAmount, String>(
      id: 'Amount',
      colorFn: ((TimeSeriesAmount amount, _) {
        return charts.MaterialPalette.gray.shadeDefault;
      }),
      domainFn: (TimeSeriesAmount amount, _) => amount.time,
      measureFn: (TimeSeriesAmount amount, _) => amount.amount,
      labelAccessorFn: ((TimeSeriesAmount amount, _) {
        return "";
      }),
      data: data,
    ),
  ];
  return _buildChart(series: chartData, ticks: chartTicks);
}
