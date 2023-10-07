import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/sceens/complete.dart';
import 'package:flutter_application_1/sceens/image_input.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formatter = DateFormat.yMMMMEEEEd();

class Addcatalog extends ConsumerStatefulWidget {
  const Addcatalog({super.key});

  @override
  ConsumerState<Addcatalog> createState() => _AddcatalogState();
}

class _AddcatalogState extends ConsumerState<Addcatalog> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _roomController = TextEditingController();
  DateTime? _selectedstartDate;
  DateTime? _selectedcheckDate;
  File? _selectedImage;

  void _saveCatalogue() {
    final enterName = _nameController.text;
    //เพราะว่าเรากำหนดพิมพ์ข้อความตัวเลขอย่างเดียว ไม่จำเป็นมีตัวอักษร
    final enterNumber = int.tryParse(_numberController.text);
    final enterRoom = _roomController.text;
    final enterStartDate = _selectedstartDate;
    final enterChecktDate = _selectedcheckDate;

    final amountIsInvalid = enterNumber == null || enterNumber <= 0;

    if (enterName.isEmpty ||
        amountIsInvalid ||
        enterRoom.isEmpty ||
        enterStartDate == null ||
        enterChecktDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ข้อผิดพลาดในการนำเข้าข้อมูลรายการ'),
          content: const Text(
              'กรุณาตรวจสอบวันเดือนปี ชื่ออุปกรณ์ รหัสอุปกรณ์ และชื่อห้องด้วยครับ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    ref.read(userCtataloguesProvider.notifier).appCatalogue(
        enterName,
        enterNumber,
        enterRoom,
        enterStartDate,
        enterChecktDate,
        _selectedImage!);

    Navigator.of(context).pop();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            height: 50,
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('เพิ่มรายการเสร็จสมบูรณ์'),
            ));
      },
    );
  }

  void _presentDatePickerStart() async {
    final now = DateTime.now();
    final firstDate = DateTime(
        now.year - 1 /*เลือกตัวเลข ย้อนหลังกี่ปีครับ*/, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedstartDate = pickedDate;
    });
  }

  void _presentDatePickerEnd() async {
    final now = DateTime.now();
    final firstDate = DateTime(
        now.year - 1 /*เลือกตัวเลข ย้อนหลังกี่ปีครับ*/, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedcheckDate = pickedDate;
    });
  }

//ตรวจสอบใช้งานหรือไม่ครับ
  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('เพิ่มรายการใหม่', style: TextStyle(color: Colors.black)
              /*
            Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
                */
              ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                TextField(
                    decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                    keyboardType: TextInputType.emailAddress,
                    controller: _nameController,
                    style: TextStyle(color: Colors.black)
                    /*Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                      */
                    ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                    decoration:
                        const InputDecoration(labelText: 'รหัสของอุปกรณ์'),
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black)
                    /*Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),*/
                    ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                    decoration: const InputDecoration(labelText: 'ชื่อห้อง'),
                    controller: _roomController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black)
                    /*Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),*/
                    ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('วันที่เริ่มใช้งาน: '),
                    Text(
                        _selectedstartDate == null
                            ? 'ไม่มีข้อมูลวันเดือนปี'
                            : formatter.format(_selectedstartDate!),
                        style: TextStyle(color: Colors.black)
                        /*Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),*/
                        ),
                    IconButton(
                        onPressed: _presentDatePickerStart,
                        icon: const Icon(Icons.calendar_month)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('วันที่ตรวจสอบสภาพ: '),
                    Text(
                        _selectedcheckDate == null
                            ? 'ไม่มีข้อมูลวันเดือนปี'
                            : formatter.format(_selectedcheckDate!),
                        style: TextStyle(color: Colors.black)
                        /*Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),*/
                        ),
                    IconButton(
                        onPressed: _presentDatePickerEnd,
                        icon: const Icon(Icons.calendar_month)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('ยกเลิก')),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                        onPressed: _saveCatalogue, child: const Text('บันทึก')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
