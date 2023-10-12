import 'package:flutter/material.dart';
//import 'package:flutter_application_1/data/catalogues_data.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_application_1/qrCode/create_qrcode.dart';
import 'package:flutter_application_1/qrCode/qr_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key, required this.catalogues});
  final List<Catalogues> catalogues;

  @override
  State<QRScreen> createState() {
    return _QRScreenState();
  }
}

class _QRScreenState extends State<QRScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('คิวอาร์โค้ด'),
          bottom: TabBar(
              controller: controller,
              tabs: const [Tab(text: 'ตัวสแกน'), Tab(text: 'โค้ดของฉัน')]),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            QRScanner(catalogues: widget.catalogues),
            const CreateQrcode(),
          ],
        ));
  }
}
