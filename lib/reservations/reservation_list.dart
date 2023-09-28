import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';

class ReservationList extends StatelessWidget {
  
  ReservationList({VehicleType? vehicleType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return ReserveCard();
            }));
  }
}

class ReserveCard extends StatelessWidget {
  ReserveCard({VehicleType? vehicleType});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('hi'),
    );
  }
}
