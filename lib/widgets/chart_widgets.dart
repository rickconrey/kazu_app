import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class TimeSeriesAmount {
  final String time;
  int amount;

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

Widget buildTodayChart(List<TimeSeriesAmount> data, List<charts.TickSpec<String>> chartTicks) {
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

Widget buildWeekChart(List<TimeSeriesAmount> data, List<charts.TickSpec<String>> chartTicks) {
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

Widget buildMonthChart(List<TimeSeriesAmount> data, List<charts.TickSpec<String>> chartTicks) {
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
