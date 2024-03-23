import 'dart:async';
import 'dart:convert';
import 'dart:math';
import "package:http/http.dart" as http;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => CheckOutState();
}

class CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 24.723251;
  double kaaba_lon = 46.635499;
  var Distance, Tawaf_time; 
  int OutOfRange=130; ///////////////out of tawaf area range
   final stopwatch = Stopwatch();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String? finalTime;
  var isFar; ////////////////the distance between the user's current location and the center
  StreamSubscription<LocationData>? locationSubscription;

  Future checkout() async {
    var url = "http://10.0.2.2/phpfiles/checkout.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": GlobalValues.Rid,
    });
    var respo = json.decode(res.body);
    print(respo);
  }

  Future TawafTime() async {
    var url = "http://10.0.2.2/phpfiles/TawafDuration.php";
    final response = await http.post(Uri.parse(url), body: {
      "TDuration": finalTime,
      "Userid": GlobalValues.id,
    });
    var data = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  double distance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 2 * 6371 * asin(sqrt(a)) * 1000;
  }

  void Checkoutt() async {
  //  print("enter");
    final permission = await location.requestPermission();
    if (permission == PermissionStatus.granted) {
      final serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        final result = await location.requestService;
        if (result == true) {
          print('Service has been enabled');
        } else {
          throw Exception('GPS service not enabled');
        }
      }
      final position = await location.getLocation();
     stopwatch.start();
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) async {

        print("p");
        print(position.latitude);
        print(position.longitude);
        print("c");
        print(currentLocation.latitude);
        print(currentLocation.longitude);

        isFar = distance(kaaba_lat, kaaba_lon, currentLocation.latitude,
                currentLocation.longitude)
            .floor();

        print(isFar);

        if (isFar >= OutOfRange) {
          print("che");
          _stopWatchTimer.onStopTimer();
          Tawaf_time = (stopwatch.elapsed.inMilliseconds / 1000).floor();
          final int totalTimeInSeconds = Tawaf_time;
          final int hours = totalTimeInSeconds ~/ 3600;
          final int minutes = (totalTimeInSeconds % 3600) ~/ 60;
          final int seconds = totalTimeInSeconds % 60;
          finalTime ='${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          print(finalTime);
          GlobalValues.Status = "Completed";
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('Status', GlobalValues.Status);
          locationSubscription?.cancel();
          TawafTime();
          checkout();
           
        }
      });
    }
  }
}
