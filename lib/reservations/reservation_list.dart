import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reservationdetails.dart';

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
                      'Reservation#1', // reservation id
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                margin: EdgeInsets.only(left:20.0),

              child: Text(
                'Status: ', 
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500

                ),
              ),
              ),

              Text(
                'Confirmed ',
                 style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400

                ),
                ),

                Image.asset('assets/images/confirm.png',
                width: 25,
                height: 25,
                ),


              SizedBox(width: 130,),


              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                       onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: ((context) => ReservationDetails()) ));
                       },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:  Color.fromARGB(131, 60, 100, 73),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                        ),
                    
                        child: const Icon(CupertinoIcons.chevron_right, color: Colors.white),
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
