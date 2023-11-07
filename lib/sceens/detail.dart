import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.catalogue});
  final Catalogues catalogue;

  @override
  Widget build(BuildContext context) {
    final httpsReference = FirebaseStorage.instance.refFromURL(catalogue.image);
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
                Image.network(
                  catalogue.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                ElevatedButton(
                  child: const Text('ดาวโหลดรูปภาพลงในแกลอรี่'),
                  onPressed: () {
                    print('นี้คือ ref :$httpsReference');
                    downloadFile(httpsReference, context);
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ชื่อของอุปกรณ์ : ${catalogue.name}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('รหัสของอปุกรณ์ : ${catalogue.number}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ห้อง : ${catalogue.room}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text('วันที่ซื้ออุปกรณ์ใหม่ : ${catalogue.startDate}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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

//ทดสอบ
  Future<void> downloadFile(Reference ref, context) async {
    final url = await ref.getDownloadURL();

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${ref.name}';
    await Dio().download(url, path);

    GallerySaver.saveImage(path, toDcim: true);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Download ${ref.name}')));
  }
}
