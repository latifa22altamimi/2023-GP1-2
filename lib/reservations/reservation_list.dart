import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';

class ReservationList extends StatelessWidget {
  final String? driverG;
  ReservationList({this.driverG});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              if (driverG != null) {
                return ReserveCard(driverG: driverG);
              }
            }));
  }
}

class ReserveCard extends StatelessWidget {
  final String? driverG;
  ReserveCard({this.driverG});
  @override
  Widget build(BuildContext context) {
    return Container(

      child: 
          Column(
            children: [


              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0,top: 10.0),
                    child: Text(
                      'Reservation#1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                  
                      ),
                    ),
                  ),
                ],
              ),
            
          

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              ElevatedButton(
                     onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: ((context) => ReservationDetails()) ));
                     },
      child: Text(
    'View details',
   style: TextStyle(
    color: Colors.black,
   fontSize: 15,
   fontWeight:
   FontWeight.w500),
   ),
style: ElevatedButton.styleFrom(
 backgroundColor: Color.fromARGB( 255, 255, 255, 255),
  shape: RoundedRectangleBorder(
  borderRadius:
     BorderRadius.all(Radius.circular(50),
    ),
     ),
     ),
     ),


     
            ],
          ),
                             
            ],
          ),  


       
       width: 180,
                    height: 100,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4.0,
                          spreadRadius: .05,
                        ),
                      ],
                    ),
    );
  }
}
