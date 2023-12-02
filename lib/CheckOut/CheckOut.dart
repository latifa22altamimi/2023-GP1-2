import 'dart:async';
import 'dart:convert';
import 'dart:math';
import "package:http/http.dart" as http;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
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
  var Distance, Tawaf_time; 
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
   // GlobalValues.Status = "Completed";
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

      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
      /*  Distance = distance(position.latitude, position.longitude, currentLocation.latitude,
                currentLocation.longitude)
            .floor();*/ // I think we don't need it here 
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

        if (isFar > 40 && isFar < 50) {
          print("near");


        } else if (isFar > 60) {
          print("che");
          _stopWatchTimer.onStopTimer();
          Tawaf_time = (stopwatch.elapsed.inMilliseconds / 1000).floor();
          final int totalTimeInSeconds = Tawaf_time;
          final int hours = totalTimeInSeconds ~/ 3600;
          final int minutes = (totalTimeInSeconds % 3600) ~/ 60;
          final int seconds = totalTimeInSeconds % 60;
          finalTime ='${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          GlobalValues.Status = "Completed";
          setState(() {
            GlobalValues.Status="Completed";
          });
          locationSubscription?.cancel();
          TawafTime();
          checkout();
           
                   /*showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 10), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              TrackTawaf()))); /////should we navigate to home?
                });
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
                        Lottie.asset('assets/images/success.json',
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
                          "Checked out",
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
              });*/
        }
      });
    }
  }
}
