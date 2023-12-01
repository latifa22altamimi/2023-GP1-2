import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/main/home.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:rehaab/customization/clip.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:http/http.dart' as http;

String long = '';
String lat = '';

class callSupport extends StatefulWidget {
  callSupport({Key? key}) : super(key: key);

  @override
  State<callSupport> createState() => _CallSupportState();
}

class _CallSupportState extends State<callSupport> {
  int? _currentIndex;
  List types = ["Sudden stop", "Empty battery"];
  TextEditingController message = TextEditingController();
  bool problemSelected = false;
  bool problemTyped = false;

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(219, 69, 95, 77);
  }

  Future insert() async {
    var url = "http://10.0.2.2/phpfiles/support.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": GlobalValues.Rid,
      "la": lat,
      "lo": long,
      "message": _currentIndex == 2 ? message.text : types[_currentIndex!],
    });
    if (res.statusCode == 200) {
      print("success");
    } else {
      print("fail");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
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
                'Call for support',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.all(10),
                height: 220,
                child: Center(child: MapPage())),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Problem type',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                print(types);
                return InkWell(
                  splashColor: Color.fromARGB(0, 255, 255, 255),
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      problemSelected = true;
                      problemTyped = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentIndex == index
                              ? kPrimaryColor
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _currentIndex == index
                            ? kPrimaryColor
                            : Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      '${types[index]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: types.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Other problems',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: EdgeInsets.only(left: 7, right: 7),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == 2
                                  ? kPrimaryColor
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              _currentIndex = 2;
                              problemSelected = false;
                              problemTyped = true;
                            });
                          },
                          minLines: 5,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: message,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.message,
                                color: kPrimaryColor,
                              ),
                              hintText: "Type the problem",
                              border: InputBorder.none),
                        )),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: RoundedButton(
                  text: 'Send',
                  press: () async {
                    if ((problemSelected ||
                            problemTyped && message.text != '') &&
                        lat != '' &&
                        long != '') {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 247, 247, 247),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      lottie.Lottie.asset(
                                          'assets/images/warn.json',
                                          width: 100,
                                          height: 100),
                                      Text(
                                        'Warning',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Are you sure you want to call for support?',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    height: 38, width: 100),
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 30.0,
                                          ),
                                          //when press on confirm

                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    height: 38, width: 100),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                insert();
                                                print(_currentIndex == 2
                                                    ? message.text
                                                    : types[_currentIndex!]);
                                                print(lat);
                                                print(long);
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    Future.delayed(
                                                        Duration(seconds: 5),
                                                        () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      home()));
                                                    });
                                                    return Dialog(
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              247, 247, 247),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            lottie.Lottie.asset(
                                                                'assets/images/success.json',
                                                                width: 100,
                                                                height: 100),
                                                            Text(
                                                              'Success',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              height: 10.0,
                                                            ),
                                                            Text(
                                                              'Your location is sent to the administrators, they are coming to help you',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.0,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints
                                                                      .tightFor(
                                                                          height:
                                                                              38,
                                                                          width:
                                                                              100),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 60, 100, 73),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    } else {
                      if (!(problemSelected ||
                          (problemTyped && message.text != ''))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Container(
                              height: 80,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(221, 224, 41, 41),
                                      Color.fromARGB(255, 240, 50, 50),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4.0,
                                      spreadRadius: .05,
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Error!',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "Type the problem or choose from the options!",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: lottie.Lottie.asset(
                                      'assets/images/erorrr.json',
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customMarker;

  late GoogleMapController mapController;
  late Future _getCurrentLocationFuture;
  LatLng? _currentPosition;

  @override
  void initState() {
    _getCurrentLocationFuture = _getCurrentLocation();
    super.initState();
    getCustomMarker();
  }

  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        'assets/images/support.json'); //--------------------put new marker image
  }

  _getCurrentLocation() async {
    Position position;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 15));

    LatLng location = LatLng(position.latitude, position.longitude);
    _currentPosition = location;
    setState(() {
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: _getCurrentLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ??
                    LatLng(56.324293441187315, 38.13961947281509),
                zoom: 16.0,
              ),
              onMapCreated: (GoogleMapController googleMapController) {
                mapController = googleMapController;

                setState(() {
                  markers.add(
                    new Marker(
                      markerId: MarkerId("1"),
                      position: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                    ),
                  );
                });
              },
              markers: Set<Marker>.from(markers),
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ));
  }

  /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/
}
