import "package:flutter/material.dart";
import "package:get/get.dart";
import "dart:async";
import "package:http/http.dart" as http;
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import "package:rehaab/GlobalValues.dart";
import "package:rehaab/customization/clip.dart";
import "package:rehaab/widgets/constants.dart";
import "package:rehaab/widgets/rounded_button.dart";

class TrackTawaf extends StatefulWidget {
  @override
  State<TrackTawaf> createState() => _TrackTawafState();
}

class _TrackTawafState extends State<TrackTawaf> with TickerProviderStateMixin {
  double kaaba_lat = 21.422487;
  double kaaba_lon = 39.826206;
  double? c_lat, c_lon, m;
  // double? start_lat, start_lon;
  // Position? c_position;
  Position? startPosition;
  final stopwatch = Stopwatch();
  StreamSubscription<Position>? positionStream;
  int count = 0;
  int counter = 0;
  double? laps;
  Duration? elapsed;
  double? controller;
  bool _isVisible = false;

  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => startPosition = position);
      m = (kaaba_lat - position.latitude) / (kaaba_lon - position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void listenToStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position);
      setState(() {
        c_lat = position!.latitude;
        c_lon = position.longitude;
      });
      double distance =
          Geolocator.distanceBetween(kaaba_lat, kaaba_lon, c_lat!, c_lon!);
      // print("distance: $distance");
      if (c_lon == (m! * c_lat!) - (m! * kaaba_lat) + kaaba_lon) {
        count++;
        if (count == 2) {
          stopwatch.stop();
          elapsed = stopwatch.elapsed;
          stopwatch.reset();
          final snackBar = SnackBar(content: Text('Lap Time: $elapsed'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            counter = counter + 1;
          });
        } else if (count == 14) {
          laps = count / 2;
          dispose();
          setState(() {
            _isVisible = !_isVisible;
          });
        }
        if (distance > 200) {
          dispose();
          setState(() {
            _isVisible = false;
          });
        }
      }
    });
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
                    color: Color.fromARGB(255, 244, 244, 244),
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body:Container(
        child: Stack(
        children: [
        FlutterMap(
            options: MapOptions(
              center: LatLng(kaaba_lat, kaaba_lon),
              zoom: 18,
              backgroundColor: Color.fromRGBO(250,250,250,1),
            ),

            children: [
               Card(
                        margin: const EdgeInsets.only(
                            top:65, left: 35, right: 35, bottom: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child:  ListTile(
                        
                          title: Text(
                            "Hello "+GlobalValues.Fullname+"! \nare you ready to make Rehaab count your Tawaf rounds?",
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
                        color: Color.fromARGB(255, 120, 138, 121),
                        strokeWidth: 11,
                        value: controller,
                        semanticsLabel: 'progress',
                      ),
                    ),
                  ),
                ),
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(kaaba_lat, kaaba_lon),
                    radius: 60,
                    useRadiusInMeter: true,
                    color: const Color.fromARGB(50, 51, 51, 51),
                    borderStrokeWidth: 10.0,
                    borderColor: kPrimaryColor,
                  ),
                ],
              ),
              Container(
                child: Visibility(
                  visible: _isVisible,
                  child: Center(
                    child: Text('$count',
                        style: const TextStyle(
                            fontSize: 120, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                    
                  ),
                   
                ),
              ),
           Container(child: Padding( padding:EdgeInsets.only(top: 500,left: 50,right:50), child: RoundedButton(
          text: 'Start Tawaf', press: () {
          _getCurrentPosition();
          stopwatch.start();
          listenToStream();
          setState(() {
            _isVisible = !_isVisible;
          
          });
                             })),),
            ],
          ),
          // Container(child: Text("$start_lat , $start_lon"))
        ],
        
      ),)
    );
  }
}