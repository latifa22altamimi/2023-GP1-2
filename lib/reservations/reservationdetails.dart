import 'dart:math';

import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/customization/clip.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';
import 'package:rehaab/widgets/rounded_button.dart';


class ReservationDetails extends StatefulWidget{

const ReservationDetails({super.key});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();

}
class _ReservationDetailsState extends State<ReservationDetails> {
  



Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
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
                'Reservation details',
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
         child : Column( 
        
        children: [
        Container( 
          alignment: Alignment.center, 
        height: 300,//padding: const EdgeInsets.only(top: 1.0, left: 10.0, right: 10.0),
        width: 300,
        //margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(50),),
        //padding: EdgeInsets.only(top: 50),
        child: QrImageView(data: "Name\n Date \n  Time \n Vehicle type \n Driving type \n Driver gender \n  " , size: 200, )), 
        Container(padding: EdgeInsets.only(top: 5),      alignment: Alignment.topCenter, height:40,child: Text("Use this QR code at the pickup location to check in",maxLines: 2, style: TextStyle(color: Colors.grey, fontSize: 15 ), )),
        Container(child: Row(children: [Container(  

          padding: EdgeInsets.only( left: 30, right: 6 , top: 150, bottom: 6),
          child: ElevatedButton.icon(
                
            onPressed: () async { showDialog(
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
                                      Lottie.asset('assets/images/warn.json',
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
                                        'Do you want to cancel?',
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
                                                //success msg here , insert in db --------------------------------------------
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
                                                          Lottie.asset(
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
                                                            'Cancelation is done successfully',
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
                                                                        Navigator.pop(context);
                                                                    
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
                              )); },
            label:Text("Cancel"),
             icon: Icon(Icons.close),  

style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red), shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))), fixedSize: MaterialStateProperty.resolveWith((states) => Size(150, 40)),), 
              ),) , Container(
//padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
          padding: EdgeInsets.only( right: 6,top: 150, bottom: 6),
              child: ElevatedButton.icon(
                
            onPressed: () async { },
            label:Text("Reschdule"),
             icon: Icon(Icons.schedule),  

style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Color.fromARGB(255, 207, 202, 202)), shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))), fixedSize: MaterialStateProperty.resolveWith((states) => Size(150, 40)),), 
              ),
          

        )],)
      
     
      ) , Offstage(
        offstage: true,
        child: ElevatedButton.icon(
                
            onPressed: () async { },
            label:Text("Call support"),
             icon: Icon(Icons.phone),  

style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Color.fromARGB(255, 207, 202, 202)), shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))), fixedSize: MaterialStateProperty.resolveWith((states) => Size(150, 40)),), 
              ),
      ) , Offstage( 

        offstage: true,

        child:Container(
          padding: EdgeInsets.only(top: 8),
        child: ElevatedButton.icon(
                
            onPressed: () async { showDialog(
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
                                      Lottie.asset('assets/images/warn.json',
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
                                        'Do you want to check out?',
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
                                                //success msg here , insert in db --------------------------------------------
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
                                                          Lottie.asset(
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
                                                            'the operation is done successfully',
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
                                                                        Navigator.pop(context);
                                                                    
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
                              ));},
            label:Text("Check out"),
             icon: Icon(Icons.check),  

style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red), shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))), fixedSize: MaterialStateProperty.resolveWith((states) => Size(150, 40)),), 
              ),
      ))]),  )
//padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
             
          

       );
}







}
