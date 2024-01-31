import 'dart:io';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../customization/clip.dart';
import '../widgets/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CheckIn extends StatefulWidget {
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  
  Barcode? barcode;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() async{
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    
  }

 

  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
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
                'Chenk In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment:Alignment.center ,
        children: <Widget>[
          buildQrView(context), 
          Positioned(child: buildResult(), bottom: 10,)
        ],)
    ));
  
  Widget buildResult()=> Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white24
    ),
    child: Text( 
    barcode!= null? 'Result: ${barcode!.code}': 'Scan a code' ,
    maxLines: 10,
    )
  );

   Widget buildQrView(BuildContext context) => QRView(key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kPrimaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width*0.8),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),);
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    
     
  

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    
    controller.scannedDataStream.listen((barcode) => setState(() => this.barcode = barcode));
     
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
