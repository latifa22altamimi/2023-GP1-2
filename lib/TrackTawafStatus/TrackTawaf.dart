import "package:flutter/material.dart";
import "dart:async";
import "dart:math";
import 'package:location/location.dart';
import "package:lottie/lottie.dart";
import "package:rehaab/widgets/constants.dart";
import "package:stop_watch_timer/stop_watch_timer.dart";
import "../GlobalValues.dart";
import "../customization/clip.dart";
import "../main/home.dart";

class TrackTawaf extends StatefulWidget {
  @override
  State<TrackTawaf> createState() => _TrackTawafState();
}

class _TrackTawafState extends State<TrackTawaf> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 24.7884335;
  double kaaba_lon = 46.6724390;
  double c_lat = 0, c_lon = 0, m = 0;
  var l;
  final stopwatch = Stopwatch();
  int counter = 0;
  double? controller;
  bool _isVisible = false;
  var round_time;
  var gap = 0;
  var rest = 0;
  var isFar;
  String? finalTime;
  int? StoppedTimeMinutes;
  var icon= Icons.start;
  bool enter=false;
  StreamSubscription<LocationData>? locationSubscription;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
@override
 void FinishStream() {
 locationSubscription?.cancel();
//GlobalValues.Status = "Completed";
      showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 10), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              home()))); /////should we navigate to home?
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
                          "Congrats you have finished your Tawaf! \n اللَّهُمَّ اجْعَلْنِي مِنْ أَئِمَّةِ الْمُتَّقِينَ، وَاجْعَلْنِي مِنْ وَرَثَةِ جَنَّةِ النَّعِيمِ، وَاغْفِرْ لِي خَطِيئَتِي يَوْمَ الدِّينِ ",
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
}

 

  double d(lat1, lon1, lat2, lon2) {
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
    var x =
        d(position.latitude, position.longitude, kaaba_lat, kaaba_lon).floor();
  
     locationSubscription= location.onLocationChanged.listen((LocationData currentLocation) {
      l = d(position.latitude, position.longitude, currentLocation.latitude,
              currentLocation.longitude)
          .floor();
      isFar = d(kaaba_lat, kaaba_lon, currentLocation.latitude,
              currentLocation.longitude)
          .floor();
      print("p");
      print(position.latitude);
      print(position.longitude);
      print("c");
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      if (stopwatch.elapsed.inMilliseconds > 15000 && x < 200) {
        if (l < 5) {
          print("enter");
          if (stopwatch.elapsed.inMilliseconds - gap > 15000) {
            setState(() {
              counter = counter + 1;
              print(counter);
            });
            gap = stopwatch.elapsed.inMilliseconds;
          }
        }
        if (isFar > 150 && isFar < 200) {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Alert'),
                    content: const Text('You are getting so far'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else if (isFar > 200) {
          // print("so far");
          _isVisible = false;
          rest = 0;
          dispose();
          _stopWatchTimer.onStopTimer();
          _stopWatchTimer.onResetTimer();
          stopwatch.stop();
          stopwatch.reset();
        }
        if (counter >= 7) {
          rest = 0;
          FinishStream();
     
        } else if (!enter){
          if(counter == 1) {
          _stopWatchTimer.onStopTimer();
         final round_time = (stopwatch.elapsed.inMilliseconds / 1000).floor();
         print(round_time);
          final int totalTimeInSeconds = round_time * 7;
final int hours = totalTimeInSeconds ~/ 3600;
final int minutes = (totalTimeInSeconds % 3600) ~/ 60;
final int seconds = totalTimeInSeconds % 60;
finalTime =
  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        enter=true;
        }
        }

      }
    });

    return position;
  }

  /* void calculateFinalTime() {
    final int totalTimeInMinutes = round_time * 7;
    final int hours = totalTimeInMinutes ~/ 60;
    final int minutes = totalTimeInMinutes % 60;
    finalTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    setState(() {});
  }*/

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 60, 100, 73),
                  Color.fromARGB(255, 104, 132, 113)
                ],
              ),
            ),
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
                // bottom: 20,
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
      bottomSheet: finalTime != null
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                'You will in approximately after: $finalTime',
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
