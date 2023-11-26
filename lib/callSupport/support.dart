import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:rehaab/customization/clip.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:http/http.dart' as http;


var long;
var lat;


class callSupport extends StatefulWidget {
  callSupport({Key? key}) : super(key: key);

  @override
  State<callSupport> createState() => _CallSupportState();
}

class _CallSupportState extends State<callSupport>{
  int? _currentIndex;
  List types=["Sudden stop","Empty battery"];
   TextEditingController message = TextEditingController();


  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(219, 69, 95, 77);
  }
Future insert() async {
    var url = "http://10.0.2.2/phpfiles/support.php";
    final res = await http.post(Uri.parse(url), body: {
      "UserId": GlobalValues.id,
      "la": double.parse(lat),
      "lo": double.parse(long),
      "message": _currentIndex==2? message.text : types[_currentIndex!],
      
    });
    var resp = json.decode(res.body);
    print(resp);
  }
 
  Widget build(BuildContext context){
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
           
          SliverToBoxAdapter(child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(10),
            height: 220,
            child:Center(child: MapPage())) ,),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                
                Row(

                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                 Container(
                   margin: EdgeInsets.only(left: 10,right:10,top: 10),

                  child:  Align(
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
                    :  Colors.white
                       
              ),
              alignment: Alignment.center,
              child: Text(
                '${types[index]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _currentIndex == index ? Colors.white: null,
                ),
              ),
            ),
          );
        },
        childCount: types.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3),
    
    )
    , SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                 SizedBox(
                  height: 5.0,
                ),
                
                Row(

                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   
                   Container(
                      margin: EdgeInsets.only(left: 10,right:10),

                    child:  Align(
                  alignment: Alignment.topLeft,
                  
                  child: Text(
                    'Other problems',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),)
                  
               
         
                  ],
                ),
                
              ],
            ),
          ),
SliverToBoxAdapter( 
  child:Container(  
  margin: EdgeInsets.only(left: 7,right:7),
  child:Column(children: [
    
                Container(
      decoration: BoxDecoration(
        border: Border.all(
                  color: _currentIndex == 2
                      ? kPrimaryColor
                      : Colors.grey,),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white),               
     child: TextFormField(
      onTap: () {

        setState(() {
          _currentIndex=2;
        });
      },
          minLines: 5,
          maxLines: null,
          keyboardType: TextInputType.multiline,
         controller:message,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
       fillColor: Colors.white,
        icon: Icon( Icons.message,
         color: kPrimaryColor,
                                   ),
         hintText: "Type the problem",
           border: InputBorder.none
           

        ),
      )),],)
  
 ),),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: RoundedButton(
                text: 'Send',
                press: () async {
                  //convert date/day/time into string first
                  showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 247, 247, 247),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      lottie.Lottie.asset('assets/images/warn.json',
                                          width: 150, height: 120),
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
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 10.0,
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
                                                    fontSize: 15,
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
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 247, 247, 247),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
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
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Done',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            50),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
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
                  }
               
              ),
            ),
          ),
        ],
      ),
       );}
                  
                
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
        ImageConfiguration.empty, 'assets/images/marker_1.png');
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
      long= position.longitude;
      lat=position.latitude;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
        future: _getCurrentLocationFuture,
        builder: (context, snapshot) {
            if (snapshot.hasData) {
            return Center (
              child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ??
                    LatLng(56.324293441187315, 38.13961947281509),
                zoom: 19.0,
              ),
         onMapCreated: (GoogleMapController googleMapController) {
              mapController = googleMapController;

          setState(() {
            markers.add(
             new Marker(
                markerId: MarkerId("1"),
                position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                icon: customMarker,
              ),
            );
            
          }
          );
        },
        markers: Set<Marker>.from(markers),
            )
            );
          } else {
            return Center(
              child:CircularProgressIndicator()
              );
          }
        },
      ),
    )
    );
  }

 /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/
}
