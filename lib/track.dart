import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MealsByDateChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MealsByDateChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      behaviors: [charts.SeriesLegend()]  // add series legend to top of chart
    );
  }
}

class MealsByDate {
  final DateTime date;
  final int meals;

  MealsByDate(this.date, this.meals);
}