import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Catalogues {
  Catalogues(
      {required this.name,
      required this.number,
      required this.room,
      required this.startDate,
      required this.checkDate})
      : id = uuid.v4();

  //ไอดีของผู้ใช้
  final String id;
  //ชือ อุปกรณ์
  final String name;
  //รหัส อุปกรณ์
  final int number;
  //รหัสห้อง
  final String room;
  //กำหนดวันที่เริ่มใช้งาน
  final DateTime startDate;
  //กำหนดวันที่ตรวจสภาพ
  final DateTime checkDate;
}
