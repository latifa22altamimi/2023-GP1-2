import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var markers = HashSet<Marker>();
  late BitmapDescriptor customMarker;

  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/double.png");
  }

  @override
  void initState() {
    super.initState();
    getCustomMarker();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Our location"),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
            target: LatLng(21.422444, 39.822861), zoom: 19),
        onMapCreated: (GoogleMapController googleMapController) {
          setState(() {
            markers.add(
              Marker(
                  markerId: const MarkerId("1"),
                  position: const LatLng(21.422444, 39.822861),
                  infoWindow: const InfoWindow(
                    title: "Electric vehicle Pick-up Point ",
                    snippet: "click for the location",
                  ),
                  icon: customMarker),
            );
          });
        },
        markers: markers,
      ),
    );
  }
}
