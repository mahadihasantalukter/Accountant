import 'package:accountant/pages/Home_paged/home_page.dart';
import 'package:accountant/pages/data/customer.dart';
import 'package:accountant/pages/data/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserPages extends StatefulWidget {
  final Transaction transaction;

  const UserPages({super.key, required this.transaction});

  @override
  State<UserPages> createState() => _UserPagesState();
}

class _UserPagesState extends State<UserPages> {
  final box = Hive.box<Customer>('customer_box');

  void additem(
    String title,
    String productname,
    double totalamount,
    double paidamountin,
    bool isCredit,
  ) {
    final newentery = Customer(
      title: title,
      productname: productname,
      amounta: totalamount,
      paidamount: paidamountin,
      isCradit: isCredit,
      date: DateTime.now(),
    );
    box.add(newentery);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.transaction;

    final isCredite = data.isCradit;
    var balance = (data.amount - data.paidamount);
    double taka = 0.0;
    bool isCradit = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leadingWidth: 250,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  addTransaction(context, data);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_outlined, color: Colors.black),
                    Text("add", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  deleteTransaction(context, data);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outlined, color: Colors.red),
                    Text("delete", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],

        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.offAll(() => HomePage());
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
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Customer> box, _) {
          double amuntIn = 0;
          double amuntOut = 0;
        
          final customerTransactions = box.values.where((item) => item.title == widget.transaction.title).toList();
          for(var itemdata in customerTransactions){
            double blance = itemdata.amounta - itemdata.paidamount;
            if(itemdata.isCradit){
              if(blance >= 0){
                amuntIn += blance;
              }else{
                amuntOut += blance.abs();
              }
            }else{
              if(blance >= 0){
                amuntIn += blance;
              }else{
                amuntOut += blance.abs();
              }
            }
          }
          double currentBalance = amuntIn - amuntOut;

          return Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      summarycard(
                        "সর্বমোট টাকা",
                        amuntIn.toString(),
                        Colors.black,
                      ),
                      summarycard(
                        "টাকা দিয়েছে",
                        amuntOut.toString(),
                        Colors.black,
                      ),
                      summarycard(
                        currentBalance >= 0 ? "টাকা পাবে" : "টাকা দিবে",
                        currentBalance.abs().toString(),
                        currentBalance >= 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
                Text(data.amount.toString(), style: TextStyle(fontSize: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  // delete condition
  void deleteTransaction(BuildContext context, Transaction data) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                "লেনদেনটি কি মুছে ফেলতে চান?",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),

            content: Text(
              "${data.title} এর এই লেনদেনটি কি চিরতরে মুছে ফেলতে চান?",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text("না", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () async {
                  await data.delete();
                  Get.back();
                  Get.back();

                  Get.snackbar(
                    "ডিলিট হয়েছে",
                    "লেনদেনটি সফলভাবে মুছে ফেলা হয়েছে",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
                child: Text("হ্যাঁ", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  void addTransaction(BuildContext context, Transaction data) {
    bool localisCredit = false;
    final productController = TextEditingController();
    final noteController = TextEditingController();
    final amountController = TextEditingController();

    final paidamountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Center(child: Text("নতুন লেনদেন তৈরি করুন")),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product name
                      TextField(
                        controller: productController,

                        decoration: InputDecoration(
                          labelText: "পণ্যের নাম",
                          labelStyle: TextStyle(color: Colors.black),
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

                      SizedBox(height: 10),

                      // Note
                      TextField(
                        controller: noteController,

                        decoration: InputDecoration(
                          labelText: "নোট লিখুন",
                          labelStyle: TextStyle(color: Colors.black),
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

                        decoration: InputDecoration(
                          labelText: "মোট টাকা",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.attach_money_outlined,
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

                      // Amount
                      TextField(
                        controller: paidamountController,

                        decoration: InputDecoration(
                          labelText: "টাকা দিয়েছেন",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.attach_money_outlined,
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
                      SwitchListTile(
                        title: Text(
                          localisCredit ? "আমার কাছে পাবে" : "আমি টাকা পাবো",
                        ),
                        value: localisCredit,
                        activeColor: Colors.black,
                        inactiveThumbColor: Colors.red,
                        onChanged: (value) {
                          setModalState(() {
                            localisCredit = value;
                          });
                        },
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
                      // 1. Extract values from controllers
                      String productName = productController.text.trim();
                      String note =
                          noteController.text
                              .trim(); // You can use this for the title or a note field

                      // 2. Parse amounts safely using tryParse (prevents crashes if input is not a number)
                      double totalAmount =
                          double.tryParse(amountController.text) ?? 0.0;
                      double paidAmount =
                          double.tryParse(paidamountController.text) ?? 0.0;

                      // 3. Validation: Ensure product name and amount are provided
                      if (productName.isEmpty ||
                          amountController.text.isEmpty) {
                        Get.snackbar(
                          "ভুল হয়েছে",
                          "দয়া করে পণ্যের নাম এবং মোট টাকা লিখুন",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      additem(
                        data.title,
                        productName,
                        totalAmount,
                        paidAmount,
                        localisCredit,
                      );

                      // 5. Close the dialog
                      Get.back();

                      // 6. Optional: Show success message
                      Get.snackbar(
                        "সফল",
                        "নতুন লেনদেন যোগ করা হয়েছে",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    child: const Text("যোগ করুন"),
                  ),
                ],
              );
            },
          );
        }
        ;
      },
    );
  }
}

Widget summarycard(var title, var amount, Color color) {
  return Expanded(
    child: Card(
      elevation: 5,
      shadowColor: Colors.blue,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              "৳ $amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
