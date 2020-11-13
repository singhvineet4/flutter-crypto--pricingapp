import 'dart:math' as math;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cryptolist/data/remote/remote.dart';
import 'package:flutter/material.dart';

@immutable
class ChartWidget extends StatelessWidget {
  final List<charts.Series<TimedData, DateTime>> seriesList;
  final double min;
  final double max;

  const ChartWidget(this.seriesList, this.min, this.max);

  factory ChartWidget.create(List<TimedData> data) {
    final series = charts.Series<TimedData, DateTime>(
      id: 'Price',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimedData e, _) => e.time,
      measureFn: (TimedData e, _) => e.data,
      data: data,
    );

    final numbers = data.map((e) => e.data).toList();
    final min = numbers.reduce(math.min);
    final max = numbers.reduce(math.max);
    final dist = max - min;

    return ChartWidget(
      [
        series,
      ],
      min - dist / 5,
      max + dist / 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: false,
      dateTimeFactory: charts.LocalDateTimeFactory(),
      behaviors: [
        charts.PanAndZoomBehavior(),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents.fromValues([
          min,
          max,
        ]),
      ),
    );
  }
}
