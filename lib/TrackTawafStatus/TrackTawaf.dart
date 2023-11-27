import "package:flutter/material.dart";
import "dart:async";
import "package:http/http.dart" as http;
import "dart:math";
import 'package:location/location.dart';
import "package:rehaab/customization/clip.dart";
import "package:rehaab/widgets/constants.dart";
import "package:rehaab/widgets/rounded_button.dart";
import "package:stop_watch_timer/stop_watch_timer.dart";

class TrackTawaf extends StatefulWidget {
  @override
  State<TrackTawaf> createState() => _TrackTawafState();
}

class _TrackTawafState extends State<TrackTawaf> with TickerProviderStateMixin {
  Location location = Location();
  double kaaba_lat = 34.71446582516598;
  double kaaba_lon = 36.71972231498224;
  double c_lat = 0, c_lon = 0, m = 0;
  var l;
  final stopwatch = Stopwatch();
  int counter = 0;
  double? controller;
  bool _isVisible = false;
  var lap_time;
  var gap = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void dispose() {
    super.dispose();
  }

  double d(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
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
    location.onLocationChanged.listen((LocationData currentLocation) {
      l = d(position.latitude, position.longitude, currentLocation.latitude,
              currentLocation.longitude)
          .floor();
      // if (stopwatch.elapsed.inMilliseconds > 15000) {
      if (l < 3) {
        if (stopwatch.elapsed.inMilliseconds - gap > 15000) {
          setState(() {
            counter = counter + 1;
            print(counter);
          });
        }
        gap = stopwatch.elapsed.inMilliseconds;
      } else if (x > 200) {
        _isVisible = false;
        dispose();
        _stopWatchTimer.onStopTimer();
      }
      if (counter >= 7) {
        dispose();
      } else if (counter == 1) {
        _stopWatchTimer.onStopTimer();
        // lap_time = (stopwatch.elapsed.inMilliseconds / 1000).floor();
      }
      // }
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
              Card(
                        margin: const EdgeInsets.only(
                            top:65, left: 35, right: 35, bottom: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child:  ListTile(
                        
                          title: Text(
                            "Are you ready to make Rehaab count your Tawaf rounds?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor)
                                ,
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
                      color: Color.fromARGB(255, 89, 95, 133),
                      strokeWidth: 8,
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
                        offset: Offset(0, 3),
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
            Positioned(
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
                        offset: Offset(0, 3),
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
                            "Timer: $displayTime",
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
             Padding( padding:EdgeInsets.only(top: 500,left: 50,right:50), 
          child:Visibility(
            child: RoundedButton(
          text: 'Start Tracking', press: () async {
          _stopWatchTimer.onStartTimer();
          stopwatch.start();
          getCurrentLocation();
        },
        
                             )
                             ) 
                             )
          ],
        ),
      ),
    
    /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF251AC2),
        child: const Icon(Icons.start),
        onPressed: () async {
          _stopWatchTimer.onStartTimer();
          stopwatch.start();
          getCurrentLocation();
        },
      ),*/
      
    );
  }
}
