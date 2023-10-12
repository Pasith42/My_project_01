import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:gallery_saver/gallery_saver.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.catalogue});
  final Catalogues catalogue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catalogue.name),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Image.file(
                  catalogue.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                ElevatedButton(
                  child: const Text('ดาวโหลดรูปภาพลงในแกลอรี่'),
                  onPressed: () {
                    GallerySaver.saveImage(catalogue.image.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ดาวโหลดเสร็จสิ้น')));
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('ชื่อของอุปกรณ์ : ${catalogue.name}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('รหัสของอปุกรณ์ : ${catalogue.number}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('ห้อง : ${catalogue.room}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('วันที่ซื้ออุปกรณ์ใหม่ : ${catalogue.startDate}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('วันที่ตรวจสอบล่าสุด : ${catalogue.checkDate}'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
