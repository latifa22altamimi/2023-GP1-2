import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../customization/clip.dart';
import '../widgets/constants.dart';

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
    var url = "http://10.0.2.2/phpfiles/map.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
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

  late var lat = list[0]['Latitude'];
  late var lon = list[0]['Longitude'];

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
          target: LatLng(21.422520070642364, 39.82617437839509),
          zoom: 18,
        ),
        onMapCreated: (GoogleMapController googleMapController) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(list[0]["MarkerId"]),
                position: LatLng(double.parse(lat), double.parse(lon)),
                infoWindow: InfoWindow(
                  title: "Electric Vehicle Pick-up/Return Point ",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );
            /* markers.add(
              Marker(
                markerId: MarkerId("2"),
                position: LatLng(double.parse(lat1), double.parse(lon1)),
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
                position: LatLng(double.parse(list[2]['Latitude']),
                    double.parse(list[2]['Longitude'])),
                infoWindow: const InfoWindow(
                  title: "Marker 3",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );*/
          });
        },
        markers: Set<Marker>.from(markers),
      ),
    );
  }
}
