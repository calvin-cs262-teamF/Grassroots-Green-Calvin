import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Scope of time series chart being displayed.
  String _scope = 'Week';

  /// This will set the time series chart in TRACK to 'week' scope
  void _setWeek() {
    _scope = 'Week';
    // TODO: Change the time series chart to this scope
  }
  /// This will set the time series chart in TRACK to 'month' scope
  void _setMonth() {
    _scope = 'Month';
    // TODO: Change the time series chart to this scope
  }

  /// Placeholder meal data for time series chart
  static final List<MealsByDate> placeholderVegetarian = [
    MealsByDate(DateTime(2019, 10, 26), 0),
    MealsByDate(DateTime(2019, 10, 27), 2),
    MealsByDate(DateTime(2019, 10, 28), 1),
    MealsByDate(DateTime(2019, 10, 29), 0),
    MealsByDate(DateTime(2019, 10, 30), 0),
    MealsByDate(DateTime(2019, 10, 31), 2),
    MealsByDate(DateTime(2019, 11, 1), 0),
  ];
  static final List<MealsByDate> placeholderVegan = [
    MealsByDate(DateTime(2019, 10, 26), 0),
    MealsByDate(DateTime(2019, 10, 27), 0),
    MealsByDate(DateTime(2019, 10, 28), 0),
    MealsByDate(DateTime(2019, 10, 29), 1),
    MealsByDate(DateTime(2019, 10, 30), 0),
    MealsByDate(DateTime(2019, 10, 31), 0),
    MealsByDate(DateTime(2019, 11, 1), 0),
  ];

  /// Series array in order to build time series chart
  static final List<charts.Series<MealsByDate, DateTime>> placeholderSeries = [
    charts.Series(
      id: 'Vegetarian',
      domainFn: (MealsByDate meals, _) => meals.date,
      measureFn: (MealsByDate meals, _) => meals.meals,
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      data: placeholderVegetarian,
    ),
    charts.Series(
      id: 'Vegan',
      domainFn: (MealsByDate meals, _) => meals.date,
      measureFn: (MealsByDate meals, _) => meals.meals,
      colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
      data: placeholderVegan,
    ),
  ];

  Future<double> _getPlantPercent() async {
    DocumentSnapshot doc = await _getUserData();
    int count = 0;
    int veg = 0;
    if (doc['Count'] != null) {
      count = doc['Count'];
    }
    if (doc['Vegetarian'] != null) {
      veg += doc['Vegetarian'];
    }
    if (doc['Vegan'] != null) {
      veg += doc['Vegan'];
    }

    if(count == 0 || veg > count ) { return 0; }
    else { return veg / count; }
  }

  /// Gets user data from Firestore.
  Future<DocumentSnapshot> _getUserData() async {
    try {
      String user = await auth.getCurrentUser();
      return await Firestore.instance.collection('users').document(user).get();
    } catch(e) {
      return null;
    }
    //return Firestore.instance.collection('users').document(await auth.getCurrentUser()).get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            alignment: Alignment(0.0, 0.0),
            child: FutureBuilder<double>(
              future: _getPlantPercent(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                double percent = 0;
                if ( !snapshot.hasError && snapshot.connectionState == ConnectionState.done ) {
                  percent = snapshot.data;
                }
                return CircularPercentIndicator(
                  radius: 180.0,
                  animation: true,
                  animationDuration: 1000,
                  lineWidth: 10.0,
                  percent: percent,
                  header: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      'Plant-Based Meals',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  center: Text(
                    (percent * 100).round().toString() + '%',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Theme.of(context).accentColor,
            );},),),

          Padding(  // time series chart for meals, by date
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: 200.0,
              child: MealsByDateChart(placeholderSeries),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _setWeek,
                  child: Text(
                      'Week',
                      style: Theme.of(context).textTheme.display4,
                  )
              ),
              FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _setMonth,
                  child: Text(
                      'Month',
                      style: Theme.of(context).textTheme.display4,
                  )
              ),
            ],
          )
        ],
      ),
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