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
          Column(
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
                    //ถูกไหม
                    GallerySaver.saveImage(catalogue.image.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ดาวโหลดเสร็จสิ้น')));
                  })
            ],
          ),
        ],
      ),
    );
  }
}
