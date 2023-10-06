import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/sceens/image_input.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formatter = DateFormat.yMMMMEEEEd();

class Addcatalog extends ConsumerStatefulWidget {
  Addcatalog({super.key});

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
    final enterNumber = int.tryParse(_nameController.text);
    final enterRoom = _nameController.text;
    final enterStartDate = _selectedstartDate;
    final enterChecktDate = _selectedcheckDate;

    final amountIsInvalid = enterNumber == null || enterNumber <= 0;

    if (enterName.isEmpty ||
        amountIsInvalid ||
        enterRoom.isEmpty ||
        _selectedstartDate == null ||
        _selectedcheckDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ข้อผิดพลาดในการนำเข้าข้อมูลรายการ'),
          content: Text(
              'กรุณาตรวจสอบวันเดือนปี ชื่ออุปกรณ์ รหัสอุปกรณ์ และชื่อห้องด้วยครับ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'),
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
        enterStartDate!,
        enterChecktDate!,
        _selectedImage!);

    Navigator.of(context).pop();
  }

  void _presentDatePicker_start() async {
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

  void _presentDatePicker_end() async {
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
          title: Text(
            'เพิ่มรายการใหม่',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  controller: _roomController,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('วันที่เริ่มใช้งาน: '),
                    Text(
                      _selectedstartDate == null
                          ? 'ไม่มีข้อมูลวันเดือนปี'
                          : formatter.format(_selectedstartDate!),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    IconButton(
                        onPressed: _presentDatePicker_start,
                        icon: Icon(Icons.calendar_month)),
                    const SizedBox(
                      width: 30,
                    ),
                    Text('วันที่ตรวจสอบสภาพ: '),
                    Text(
                      _selectedcheckDate == null
                          ? 'ไม่มีข้อมูลวันเดือนปี'
                          : formatter.format(_selectedcheckDate!),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    IconButton(
                        onPressed: _presentDatePicker_end,
                        icon: Icon(Icons.calendar_month)),
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
                ElevatedButton.icon(
                    onPressed: _saveCatalogue,
                    icon: Icon(Icons.add),
                    label: Text('Add Catalogue')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
