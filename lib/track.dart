import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/auth.dart';

class Track extends StatelessWidget {

  /// Routename for Navigation
  static const String routeName = "/track";

  /// Authenticator with user information.
  final BaseAuth auth;

  /// Constructor for Track.
  Track({this.auth});

  /// Builds the Track page
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TrackPage(auth: auth),
    );
  }
}

class TrackPage extends StatefulWidget {
  
  final BaseAuth auth;

  TrackPage({Key key, this.auth}) : super(key: key);

  @override
  TrackPageState createState() => TrackPageState(auth: auth);
}

class TrackPageState extends State<TrackPage> {

  final BaseAuth auth;

  TrackPageState({this.auth});

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

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