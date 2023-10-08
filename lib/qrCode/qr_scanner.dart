import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() {
    return _QRScannerState();
  }
}

class _QRScannerState extends State<QRScanner> {
  //File? _selectedImage;

  // สร้าง object สำหรับเรียกตัวสแกน QR
  QRViewController? _controller;
  final GlobalKey _qrkey = GlobalKey();
  bool _flashOn = false;
  bool _frontCam = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
            key: _qrkey,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderLength: 15.0,
                borderWidth: 5.0,
                borderRadius: 2.0),
            onQRViewCreated: (QRViewController controller) {
              _controller = controller;
              controller.scannedDataStream.listen((value) {
                //เราต้องสร้างฟังก์ชั่นที่ใช้value เพื่อส่งไปถึงหน้า detail
                //แสดงข้อมูลผลลัพธ์จากการแสดงคิวบาร์โค้ด
                if (mounted) {
                  Fluttertoast.showToast(
                      msg: value.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16);
                }
                Navigator.of(context).pop();
                //ส่งข้อมูลต่อไป
              });
            }),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 60.0),
            child: const Text(
              'วางคิวอาร์โค้ดให้อยู่ในกรอบเพื่อสแกน',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 80.0),
            child: OutlinedButton(
              onPressed: () async {
                try {
                  final imagePicker = ImagePicker();
                  final pickedImage = await imagePicker.pickImage(
                      source: ImageSource.gallery, maxWidth: 600);

                  if (pickedImage == null) {
                    return;
                  }
                  //ใช้ฟังก์ชั่น package scan
                  String? result = await Scan.parse(pickedImage.path);

                  //final imageTemporary = File(pickedImage.path);

                  //setState(() {
                  //  _selectedImage = imageTemporary;
                  //});

                  //result ถูกนำไปส่งข้อมูลที่ไหน Detail
                  //แสดงข้อมูลผลลัพธ์จากการแสดงคิวบาร์โค้ด
                  if (mounted) {
                    Fluttertoast.showToast(
                        msg: result!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16);
                  }
                } on PlatformException catch (e) {
                  print(e);
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.amber,
                side: const BorderSide(
                    style: BorderStyle.solid, color: Colors.white, width: 1),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'นำเข้าจากแกลอรี่',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                    onPressed: () {
                      setState(() {
                        _flashOn = !_flashOn;
                        _controller?.toggleFlash();
                      });
                    }),
                IconButton(
                    color: Colors.white,
                    icon: Icon(
                        _frontCam ? Icons.camera_front : Icons.camera_rear),
                    onPressed: () {
                      setState(() {
                        _frontCam = !_frontCam;
                        _controller?.flipCamera();
                      });
                    }),
                IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
