import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../customization/clip.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customMarker;
  var m1;
  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/mark_.png');
  }

  List list = [];
  Future GetData() async {
    var url = "http://192.168.100.167/phpfiles/map.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      print(red);
      setState(() {
        list.add(red);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomMarker();
    GetData();
  }

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
                'Our location',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
          target: LatLng(21.422444, 39.822861),
          zoom: 19,
        ),
        onMapCreated: (GoogleMapController googleMapController) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(list[0]['id']),
                position: LatLng(list[0]['Latitude'], list[0]['Longitude']),
                infoWindow: InfoWindow(
                  title: "Electric Vehicle Pick-up Point ",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );
            markers.add(
              Marker(
                markerId: MarkerId(list[1]['id']),
                position: LatLng(list[1]['Latitude'], list[1]['Longitude']),
                infoWindow: const InfoWindow(
                  title: "Marker 2",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );
            markers.add(
              Marker(
                markerId: MarkerId(list[2]['id']),
                position: LatLng(list[2]['Latitude'], list[2]['Longitude']),
                infoWindow: const InfoWindow(
                  title: "Marker 3",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );
          });
        },
        markers: Set<Marker>.from(markers),
      ),
    );
  }
}
