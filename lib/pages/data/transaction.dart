import 'dart:typed_data';

import 'package:hive/hive.dart';

class Transaction extends HiveObject {
  final String title;
  final String productname;
  final int phonenumber;
   double amount;
  
  bool isCradit; 
  final DateTime date;
  final Uint8List? image;
  final double paidamount;
  List? history;
  Transaction( {
    required this.productname,
    required this.isCradit,
    required this.title,
    required this.amount,
    
    required this.date,
    required this.phonenumber,
    this.image,
    required this.paidamount,
    this.history,
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
    productname: reader.read() as String? ?? "",
    amount: (reader.read() as num? ?? 0.0).toDouble(), // নিরাপদ পড়ার পদ্ধতি
    date: DateTime.fromMillisecondsSinceEpoch(reader.read() as int? ?? DateTime.now().millisecondsSinceEpoch),
    image: reader.read() as Uint8List?,
    // নিচের লাইনটি চেক করবে ডাটা আছে কি না, না থাকলে ০.০ বসাবে
    paidamount: reader.availableBytes > 0 ? (reader.read() as num? ?? 0.0).toDouble() : 0.0,
    history: reader.availableBytes > 0 ? reader.read() as List? : [],
  );
}

@override
void write(BinaryWriter writer, Transaction obj) {
  writer.write(obj.isCradit);
  writer.write(obj.title);
  writer.write(obj.phonenumber);
  writer.write(obj.productname);
  writer.write(obj.amount);
  writer.write(obj.date.millisecondsSinceEpoch);
  writer.write(obj.image);
  writer.write(obj.paidamount);
  writer.write(obj.history);
}
}