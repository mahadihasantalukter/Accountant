import 'package:hive/hive.dart';

class Customer extends HiveObject {
  String title;
  String productname;
  var note;
  double amounta;
  double paidamount;
  bool isCradit;
  final DateTime date;
  Customer({
    required this.title,
    required this.productname,
    this.note,
    required this.amounta,
    required this.paidamount,
    required this.isCradit,
    required this.date,
  });
}

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final typeId = 1;

  @override
  Customer read(BinaryReader reader) {
    // READ ORDER MUST MATCH WRITE ORDER EXACTLY
    return Customer(
      title: reader.read() as String, 
      productname: reader.read() as String, 
      note: reader.read(),
      amounta: (reader.read() as num).toDouble(), 
      paidamount:
          (reader.read() as num).toDouble(),
      isCradit: reader.read() as bool, 
      date: DateTime.fromMillisecondsSinceEpoch(
        // Index 5
        reader.read() as int,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer.write(obj.title); 
    writer.write(obj.productname);
    writer.write(obj.note); 
    writer.write(obj.amounta); 
    writer.write(obj.paidamount); 
    writer.write(obj.isCradit); 
    writer.write(obj.date.millisecondsSinceEpoch); 
  }
}
