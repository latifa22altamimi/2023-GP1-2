import 'package:flutter/material.dart';

import 'package:smooth_compass/utils/src/compass_ui.dart';

class Compass extends StatelessWidget {
  const Compass({super.key});

  @override
  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(title: Text("Qiblah")),
        body: Center(child: SmoothCompass(
          compassBuilder: (context, snapshot, child) {
            return SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/compass.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedRotation(
                        duration: const Duration(milliseconds: 500),
                        turns: (snapshot?.data?.qiblahOffset ?? 0) / 360,
                        //Place your qiblah needle here
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const VerticalDivider(
                            color: Colors.grey,
                            thickness: 5,
                          ),
                        )),
                  ),
                ],
              ),
            );
          },
        )));
  }
}
