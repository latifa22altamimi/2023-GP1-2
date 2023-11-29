import 'dart:convert';
import 'dart:math';
import "package:http/http.dart" as http;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 24.778676;
  double kaaba_lon = 46.669766;
  double c_lat = 0, c_lon = 0, m = 0;
  var l, Tawaf_time;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final stopwatch = Stopwatch();
 String? finalTime;

 Future TawafTime() async{
    var url ="http://10.0.2.2/phpfiles/TawafDuration.php";
    final response= await http.post(Uri.parse(url),body:{
    "TDuration":finalTime,
    "Userid":GlobalValues.id,
    });
  var data =json.decode(response.body); }
  
  @override
  void dispose() {
    super.dispose();
  } 


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

double d(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 2* 6371 * asin(sqrt(a)) * 1000;
  }

void Checkout(){
   Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }
   Future<LocationData> getCurrentLocation() async {
      setState(() {
    });

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
     var x =
        d(position.latitude, position.longitude, kaaba_lat, kaaba_lon).floor();
    location.onLocationChanged.listen((LocationData currentLocation) {
      l = d(position.latitude, position.longitude, currentLocation.latitude,
              currentLocation.longitude)
          .floor();
          if (x > 50 || l> 50) {

        print("far");
        dispose();
        _stopWatchTimer.onStopTimer();
         Tawaf_time = (stopwatch.elapsed.inMilliseconds /1000/ 60).ceil();
         calculateFinalTime();
         TawafTime();
      }

          });
      return position;    
}
}


void calculateFinalTime() {
    if ( Tawaf_time != null) {
      final int totalTimeInMinutes = Tawaf_time;
      final int hours = totalTimeInMinutes ~/ 60;
      final int minutes = totalTimeInMinutes % 60;
      finalTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      setState(() {
        
      });
    }
  }

}