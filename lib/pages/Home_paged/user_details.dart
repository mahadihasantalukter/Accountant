import 'package:accountant/pages/Home_paged/user_pages.dart';
import 'package:accountant/pages/data/customer.dart';
import 'package:accountant/pages/data/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserDetails extends StatefulWidget {
  final Transaction transaction;
  final Customer transaction2;
  const UserDetails({
    super.key,
    required this.transaction,
    required this.transaction2,
  });

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    final data = widget.transaction;
    final data2 = widget.transaction2;
    final isCredite = data.isCradit;
    final isCredite2 = data2.isCradit;

    double balance = data2.amounta - data2.paidamount;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 250,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.offAll(() => UserPages(transaction: data));
              },
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: isCredite ? Colors.green : Colors.red,
              backgroundImage:
                  data.image != null ? MemoryImage(data.image!) : null,
              child:
                  data.image == null
                      ? Text(
                        data.title.isNotEmpty ? data.title[0] : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : null,
            ),
            SizedBox(width: 10),
            Text(
              " ${data.title}  বিবরণ",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              showEditeCustomer(context, data2, data);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Column(
              children: [
                Icon(Icons.mode_edit_outline_outlined, color: Colors.black),
                Text("Edit", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              deletecoustomer(context, data2, data);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Column(
              children: [
                Icon(Icons.delete_outlined, color: Colors.red),
                Text("Delete", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "মোবাইল নাম্বার +880${data.phonenumber.toString()}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(4.5),
                3: FlexColumnWidth(4),
              },
              textDirection: TextDirection.ltr,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(width: 1, color: Colors.black),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "প্যণের নাম",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "মোট টাকা",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "টাকা দিয়েছেন",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          balance == 0
                              ? "পরিশোধ 0.0"
                              : (balance > 0 ? "মোট পাবো " : "মোট পাবে "),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:
                                balance == 0
                                    ? Colors.black
                                    : (balance > 0 ? Colors.red : Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(data2.productname)),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          data2.amounta.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(data2.paidamount.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          balance.isNegative ? "0.0" : balance.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                balance == 0
                                    ? Colors.black
                                    : (balance > 0 ? Colors.red : Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {0: FlexColumnWidth(4)},

              border: TableBorder.all(
                width: 1,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "নোট",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(data2.note.toString())),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void deletecoustomer(BuildContext context, Customer data2, Transaction data) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Center(
            child: Text(
              "কাস্টমারটি কি মুছে ফেলতে চান?",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          content: Text(
            "${data2.title} এর কাস্টমারটি কি মুছে ফেলতে চান?",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text("না", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                await data2.delete();
                Get.offAll(() => UserPages(transaction: data));
              },
              child: Text("হ্যাঁ", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
  );
}

void showEditeCustomer(BuildContext context, Customer data2, Transaction data) {
  final productnameController = TextEditingController(text: data2.productname);
  final phoneController = TextEditingController(
    text: data.phonenumber.toString(),
  );
  final amountController = TextEditingController(
    text: data2.amounta.toString(),
  );
  final noteController = TextEditingController(text: data2.note.toString());
  final paidamountController = TextEditingController(
    text: data2.paidamount.toString(),
  );

  showDialog(
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            double currentAmount = double.tryParse(amountController.text) ?? 0;
            double currentPaid =
                double.tryParse(paidamountController.text) ?? 0;
            double balance = currentAmount - currentPaid;

            return AlertDialog(
              title: Center(
                child: Text(
                  "কাস্টমার পরিবর্তন করুন",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: productnameController,

                      decoration: InputDecoration(
                        labelText: "পণ্যের নাম",

                        fillColor: Colors.white54,

                        hintStyle: TextStyle(color: Colors.black),

                        prefixIcon: Icon(
                          Icons.production_quantity_limits,

                          color: Colors.black,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24,

                          vertical: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(
                      controller: phoneController,

                      decoration: InputDecoration(
                        labelText: "কাস্টমারের ফোন নাম্বার",

                        fillColor: Colors.white54,

                        hintStyle: TextStyle(color: Colors.black),

                        prefixIcon: Icon(
                          Icons.phone_android_outlined,

                          color: Colors.black,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24,

                          vertical: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    TextField(
                      controller: noteController,

                      decoration: InputDecoration(
                        labelText: "নোট",

                        fillColor: Colors.white54,

                        hintStyle: TextStyle(color: Colors.black),

                        prefixIcon: Icon(
                          Icons.note_add_outlined,

                          color: Colors.black,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24,

                          vertical: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged:
                          (value) =>
                              setState(() {}), // টাইপ করলে লেবেল চেঞ্জ হবে
                      decoration: InputDecoration(
                        labelText: "টাকা",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: paidamountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        labelText:
                            balance == 0
                                ? "পরিশোধ"
                                : (balance > 0
                                    ? "মোট পাবো $balance"
                                    : "মোট পাবে ${balance.abs()}"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("বাতিল"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      data2.productname = productnameController.text;
                      data2.amounta =
                          double.tryParse(amountController.text) ??
                          data2.amounta;
                      data2.note = noteController.text;
                      data2.paidamount =
                          double.tryParse(paidamountController.text) ??
                          data2.paidamount;

                      data.phonenumber =
                          int.tryParse(phoneController.text) ??
                          data.phonenumber;

                      await data2.save();

                      await data.save();

                      Get.back();
                      Get.snackbar(
                        "সফল",
                        "ডাটা আপডেট হয়েছে",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: Text("আপডেট"),
                ),
              ],
            );
          },
        ),
  );
}
