import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CreateQrcode extends StatefulWidget {
  const CreateQrcode({super.key});

  @override
  State<CreateQrcode> createState() {
    return _QRScannerState();
  }
}

class _QRScannerState extends State<CreateQrcode> {
  final TextEditingController _controller = TextEditingController(text: '');
  String qrdata = '';

  Future<void> _captureAndSaved() async {
    try {
      final image = await QrPainter(
        data: qrdata,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200.0); // Generate QR code image data

      String filename = 'qr_code.png';
      final tempDir =
          await getTemporaryDirectory(); // Get temporary directory to store the generated image
      final file = await File('${tempDir.path}/$filename')
          .create(); // Create a file to store the generated image
      var bytes = image!.buffer.asUint8List(); // Get the image bytes
      await file.writeAsBytes(bytes); // Write the image bytes to the file
      //print('QR code shared to: $path');
      GallerySaver.saveImage(file.path);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR code saved to gallery')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong!!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'พิมพ์ตัวเลขรหัส',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  qrdata = _controller.text;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                    style: BorderStyle.solid, color: Colors.blue, width: 1),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'สร้าง QRcode',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Center(
                child: QrImageView(
                  data: qrdata,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: true,
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text(
                        'Uh oh! Something went wrong...',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                    style: BorderStyle.solid, color: Colors.blue, width: 1),
                shape: const StadiumBorder(),
              ),
              onPressed: _captureAndSaved,
              child: const Text('ดาวโหลดไฟล์ลงแกลอรี่'),
            )
          ],
        ),
      ),
    );
  }
}
