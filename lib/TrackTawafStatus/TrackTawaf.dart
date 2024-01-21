import "package:flutter/material.dart";
import "dart:async";
import "dart:math";
import 'package:location/location.dart';
import "package:lottie/lottie.dart";
import "package:rehaab/widgets/constants.dart";
import "package:stop_watch_timer/stop_watch_timer.dart";
import "../customization/clip.dart";
import "../main/home.dart";

class TrackTawaf extends StatefulWidget {
  @override
  State<TrackTawaf> createState() => _TrackTawafState();
}

class _TrackTawafState extends State<TrackTawaf> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 21.4224779; ////lat of center of kaaba
  double kaaba_lon = 39.8251832;////long of center of kaaba
  var Distance; ////////the distance between my current location and the starting point
  final stopwatch = Stopwatch();
  int counter = 0;
  double? controller;
  bool _isVisible = false;
  var round_time;
  var gap = 0; 
  var rest = 0;
  int OutOfRange=130; ///////////////out of tawaf area range
  int Near=5;//////are the users near to their starting point by 5 meters?
  int WaitingTime=15000; //////////the system should wait around 15 s before increments rounds
  String? TotalTime; //////////round time*7 to get the approximant finish time 
  int? StoppedTimeMinutes; ///////convert time to mins
  var icon= Icons.start;
  bool oneRound=false; /////////////to check if the user finished first round or not
  StreamSubscription<LocationData>? locationSubscription;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();


 void EndStream() { /////////when user complete 7 rounds
 locationSubscription?.cancel();
 Future.delayed(Duration(seconds: 2), () {
      showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 10), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              home())));
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
                        Lottie.asset('assets/images/Congrats.json',
                            width: 150, height: 150),
                        Text(
                          "You've finished your Tawaf!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                Center(
              child: Text(
                "اللَّهُمَّ اجْعَلْنِي مِنْ أَئِمَّةِ الْمُتَّقِينَ، وَاجْعَلْنِي مِنْ وَرَثَةِ جَنَّةِ النَّعِيمِ، وَاغْفِرْ لِي خَطِيئَتِي يَوْمَ الدِّينِ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
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
                  });
}

 

  double distance(lat1, lon1, lat2, lon2) { ////////////// Haversine formula to calculate the distance between 2 points
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 2 * 6371 * asin(sqrt(a)) * 1000;
  }

  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  Future<LocationData> getCurrentLocation() async {
    setState(() {
      _isVisible = !_isVisible;
    });
    _isVisible = true;
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
    var DistanceCenter =
        distance(position.latitude, position.longitude, kaaba_lat, kaaba_lon).floor(); /////////the distance between the starting point and the center
  
     locationSubscription= location.onLocationChanged.listen((LocationData currentLocation) {
      Distance = distance(position.latitude, position.longitude, currentLocation.latitude,
              currentLocation.longitude)
          .floor();

      print("p");
      print(position.latitude);
      print(position.longitude);
      print("c");
      print(currentLocation.latitude);
      print(currentLocation.longitude);

      if (stopwatch.elapsed.inMilliseconds > WaitingTime) {
        
        if (Distance < Near) {
          print("enter");
          if (stopwatch.elapsed.inMilliseconds - gap > WaitingTime  && DistanceCenter < OutOfRange) {
            setState(() {
              counter = counter + 1;
              print(counter);
            });
            gap = stopwatch.elapsed.inMilliseconds;
          }
        }
        if (counter >= 7) {
          rest = 0;
          EndStream();
     
        } else if (!oneRound){
          if(counter == 1) {
          _stopWatchTimer.onStopTimer();
        final round_time = (stopwatch.elapsed.inMilliseconds / 1000).floor();
         print(round_time);
          final int totalTimeInSeconds = round_time * 7;
final int hours = totalTimeInSeconds ~/ 3600;
final int minutes = (totalTimeInSeconds % 3600) ~/ 60;
final int seconds = totalTimeInSeconds % 60;
TotalTime =
  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        oneRound=true;
        }
        }

      }
    });

    return position;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 60.0),
          child: BackButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        flexibleSpace: ClipPath(
          clipper: AppbarClip(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
             color: kPrimaryColor,
            child: Center(
              child: Text(
                'Track Tawaf Status',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.only(
                  top: 65, left: 35, right: 35, bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: ListTile(
                title: Text(
                  "Are you ready to make Rehaab count your Tawaf rounds?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor),
                ),
              ),
            ),
            SizedBox(
              child: Center(
                child: Visibility(
                  visible: _isVisible,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Color.fromARGB(255, 87, 126, 90),
                      strokeWidth: 18,
                      value: controller,
                      semanticsLabel: 'progress',
                    ),
                  ),
                ),
              ),
            ),
            Container(
                child: Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
              ),
            )),
            Container(
              child: Visibility(
                visible: _isVisible,
                child: Center(
                  child: Text('$counter',
                      style: const TextStyle(
                          fontSize: 120, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                bottom: 50,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                      color: const Color.fromARGB(133, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: 0,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime = StopWatchTimer.getDisplayTime(value!);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Lap Time: $displayTime",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
  padding: EdgeInsets.all(100), 
  child: SizedBox(
    width: 75,
    height: 75,
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(icon),
        onPressed: () async {
      if (rest == 0) {

            rest = 1;

            _stopWatchTimer.onStartTimer();

            stopwatch.start();

            setState(() {

              icon = Icons.stop;

            });

            getCurrentLocation();

          } else if (rest == 1) {

            rest = 2;

            stopwatch.stop();

            setState(() {

              icon = Icons.start;

              _isVisible = false;

              _stopWatchTimer.onStopTimer();

            });

          } else if (rest == 2) {

            rest = 1;

            stopwatch.start();

            setState(() {

              icon = Icons.stop;

              _isVisible = true;

              if (counter < 1) {

                _stopWatchTimer.onStartTimer();

              }

            });

          }
        },
      ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomSheet: TotalTime != null
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                'You will finish in approximately after: $TotalTime',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}
