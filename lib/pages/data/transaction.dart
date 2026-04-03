import 'dart:typed_data';

import 'package:hive/hive.dart';

class Transaction extends HiveObject {
  String title;
  int phonenumber;
  bool isCradit;
  final DateTime date;
  final Uint8List? image;
  Transaction({
    required this.isCradit,
    required this.title,
    required this.date,
    required this.phonenumber,
    this.image,
  });
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final typeId = 0;
  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      isCradit: reader.read() as bool? ?? true,
      title: reader.read() as String? ?? "",
      phonenumber: reader.read() as int? ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(
        reader.read() as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      image: reader.read() as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.write(obj.isCradit);
    writer.write(obj.title);
    writer.write(obj.phonenumber);
    writer.write(obj.date.millisecondsSinceEpoch);
    writer.write(obj.image);
  }
}
