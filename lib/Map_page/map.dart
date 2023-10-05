import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../customization/clip.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customMarker;

  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/mark_.png');
  }

  @override
  void initState() {
    super.initState();
    getCustomMarker();
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
                markerId: const MarkerId("1"),
                position: const LatLng(21.422444, 39.822861),
                infoWindow: const InfoWindow(
                  title: "Electric Vehicle Pick-up Point",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );

            markers.add(
              Marker(
                markerId: const MarkerId("2"),
                position: const LatLng(21.423437919104114, 39.83102421727011),
                infoWindow: const InfoWindow(
                  title: "Marker 2",
                  snippet: "Click for the location",
                ),
                icon: customMarker,
              ),
            );
            markers.add(
              Marker(
                markerId: const MarkerId("3"),
                position: const LatLng(21.425406784366682, 39.82432911006888),
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
