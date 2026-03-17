import 'package:hive/hive.dart';

class Customer extends HiveObject {
  String title;
  String productname;
  double amounta;
  double paidamount;
  bool isCradit;
  final DateTime date;
  Customer({
    required this.title,
    required this.productname,
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
      title: reader.read() as String,               // Index 0
      productname: reader.read() as String,         // Index 1
      amounta: (reader.read() as num).toDouble(),    // Index 2 (Safe double cast)
      paidamount: (reader.read() as num).toDouble(),// Index 3 (Safe double cast)
      isCradit: reader.read() as bool,              // Index 4
      date: DateTime.fromMillisecondsSinceEpoch(    // Index 5
        reader.read() as int,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer.write(obj.title);                        // Index 0
    writer.write(obj.productname);                  // Index 1
    writer.write(obj.amounta);                       // Index 2
    writer.write(obj.paidamount);                   // Index 3
    writer.write(obj.isCradit);                     // Index 4
    writer.write(obj.date.millisecondsSinceEpoch);  // Index 5
  }
}