import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_application_1/sceens/detail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key, required this.catalogues});
  final List<Catalogues> catalogues;

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
  Barcode? barcode;
  String? resultQrcode;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          //Qrcode scanner Ok
          child: QRView(
              key: _qrkey,
              overlay: QrScannerOverlayShape(
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  borderWidth: 10,
                  borderRadius: 10,
                  borderLength: 20,
                  borderColor: Colors.white),
              onQRViewCreated: (QRViewController controller) {
                _controller = controller;
                controller.scannedDataStream.listen((value) {
                  //เราต้องสร้างฟังก์ชั่นที่ใช้value เพื่อส่งไปถึงหน้า detail
                  //แสดงข้อมูลผลลัพธ์จากการแสดงคิวบาร์โค้ด
                  setState(() {
                    barcode = value;
                    resultQrcode = barcode!.code;
                  });

                  //Navigator.of(context).pop();
                  //ส่งข้อมูลต่อไป
                });
              }),
        ),
        //Ok
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 130.0),
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

                  setState(() {
                    resultQrcode = result;
                  });

                  //result ถูกนำไปส่งข้อมูลที่ไหน Detail
                  //แสดงข้อมูลผลลัพธ์จากการแสดงคิวบาร์โค้ด
                  if (mounted) {
                    Fluttertoast.showToast(
                        msg: result!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: const Color.fromARGB(255, 49, 12, 12),
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
        Positioned(
          bottom: 80,
          left: 100,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white24,
            ),
            child: Row(
              children: [
                Text(
                  resultQrcode != null
                      ? 'Result: $resultQrcode'
                      : 'Scan a code!',
                  maxLines: 3,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_sharp),
                  onPressed: () {
                    final catalogue = List.generate(widget.catalogues.length,
                        (index) => widget.catalogues[index]).where((element) {
                      final titleLower = element.name.toLowerCase();
                      final searchLower = resultQrcode?.toLowerCase();
                      return titleLower.startsWith(searchLower!) &&
                          titleLower.endsWith(searchLower);
                    }).toList();
                    if (catalogue.length == 1) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Detail(catalogue: catalogue[0])));
                    } else {
                      AlertDialog(
                        title: const Text(
                          'ข้อผิดพลาด',
                          style: TextStyle(fontSize: 18),
                        ),
                        content: catalogue.isEmpty
                            ? const Text('ไม่พบข้อมูลในรายการ')
                            : Text('พบข้อมูลรายการจำนวน ${catalogue.length}'),
                      );
                    }
                  },
                )
              ],
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
