import 'dart:async';
import 'dart:convert';
import 'dart:math';
import "package:http/http.dart" as http;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => CheckOutState();
}

class CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 24.723251;
  double kaaba_lon = 46.635499;
  double c_lat = 0, c_lon = 0, m = 0;
  var l, Tawaf_time;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final stopwatch = Stopwatch();
  String? finalTime;
  var isFar;
  StreamSubscription<LocationData>? locationSubscription;

  Future TawafTime() async {
    var url = "http://10.6.194.195/phpfiles/TawafDuration.php";
    final response = await http.post(Uri.parse(url), body: {
      "TDuration": finalTime,
      "Userid": GlobalValues.id,
    });
    var data = json.decode(response.body);
  }

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
    return 2 * 6371 * asin(sqrt(a)) * 1000;
  }

  void Checkoutt() async {
    print("enter");
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
      var x = d(position.latitude, position.longitude, kaaba_lat, kaaba_lon)
          .floor();
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        l = d(position.latitude, position.longitude, currentLocation.latitude,
                currentLocation.longitude)
            .floor();
        print("p");
        print(position.latitude);
        print(position.longitude);
        print("c");
        print(currentLocation.latitude);
        print(currentLocation.longitude);
        isFar = d(kaaba_lat, kaaba_lon, currentLocation.latitude,
                currentLocation.longitude)
            .floor();
        print(isFar);
        if (isFar > 40 && isFar < 50) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 10), () {});
                return Dialog(
                  backgroundColor: Color.fromARGB(255, 247, 247, 247),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/images/warn.json',
                            width: 100, height: 100),
                        Text(
                          'Success',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          " Warning! I noticed that you are approaching the exit of the Tawaf area. Please make sure that you have completed your circumambulation around the Kaaba before leaving",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  height: 38, width: 100),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
          print("near");
        } else if (isFar > 60) {
          print("che");

          _stopWatchTimer.onStopTimer();
          Tawaf_time = (stopwatch.elapsed.inMilliseconds / 1000 / 60).ceil();
          print(Tawaf_time);

          calculateFinalTime();
          TawafTime();
          locationSubscription?.cancel();
        }
      });
    }
  }

  void calculateFinalTime() {
    if (Tawaf_time != null) {
      final int totalTimeInMinutes = Tawaf_time;
      final int hours = totalTimeInMinutes ~/ 60;
      final int minutes = totalTimeInMinutes % 60;
      finalTime =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
  }
}
