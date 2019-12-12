import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grassroots_green/auth.dart';

Future<double> _getUserPlantPercent(String userID, String scope, BaseAuth auth) async {
  double percent = 0;
  int plantCount = 0, totalCount = 0;
  try {
    Timestamp timestamp;
    if(scope == 'Week') {
      timestamp = Timestamp.fromDate(getWeekStart());
    } else {
      timestamp = Timestamp.fromDate(getMonthStart());
    }
    QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
        .document(await auth.getCurrentUser()).collection('meals').where('time', isGreaterThanOrEqualTo: timestamp)
        .getDocuments();
    List<DocumentSnapshot> meals = querySnapshot.documents;
    meals.forEach((meal) =>
    {
      if (meal.data['type'] == "Vegetarian" ||
          meal.data['type'] == "Vegan" ) {
        plantCount += 1
      },
      totalCount += 1
    });

    if(totalCount > 0) percent = plantCount / totalCount;
  } catch(e) {
    print("Not able to get track data properly");
  }

  return percent;
}

DateTime getMonthStart() {
  DateTime now = DateTime.now();
  return new DateTime(now.year, now.month, 1);
}

DateTime getWeekStart() {
  DateTime now = DateTime.now();
  return new DateTime(now.year, now.month, now.day).add(new Duration(days: -(DateTime.now().weekday) + 1));

}
