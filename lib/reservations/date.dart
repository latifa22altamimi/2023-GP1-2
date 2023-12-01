import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//this basically is to convert date/day/time from calendar to string
class DateConverted {
  static String getDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

/*var red;
Future GetData() async{

  var url = "http://10.0.2.2/rehaab/duration.php";
  var res = await http.get(Uri.parse(url));

  if(res.statusCode ==200){
     red = json.decode(res.body);
    

  red = int.parse(red);
  }

}*/

var duration = 90; // take from database
List<String> solts() {
  DateTime now = DateTime.now();
  DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
  DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 0);
  //DateTimeRange timep = DateTimeRange(start:now.subtract(Duration(hours: now.hour) ), end:now ) ;
  //TimeOfDay TODAY = TimeOfDay.now();

  //print('${TODAY}');

  Duration step = Duration(minutes: duration);
  int count = 1;
  DateTime first = startTime;
  List<String> timeSlots = [];
  DateTime timeIncrement = startTime;
  timeSlots.add(DateFormat.Hm().format(timeIncrement));
  while (startTime.isBefore(endTime)) {
    timeIncrement = startTime.add(step);
    if (first.hour == timeIncrement.hour && count != 1)
      break;
    else {
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
      startTime = timeIncrement;
    }
    count++;
  }
  return timeSlots;
}
