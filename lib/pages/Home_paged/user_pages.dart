import 'package:accountant/pages/Home_paged/home_page.dart';
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
  late Box<Transaction> box;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box<Transaction>('tally_box');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    amountController.dispose();
    paidamountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.transaction;
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        leadingWidth: 200,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  updateTransaction(context, data);
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
              backgroundColor: data.isCradit ? Colors.green : Colors.red,
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
        builder: (context, Box<Transaction> box, _) {
          double balnce = data.amount - data.paidamount;

          bool isCredit = data.isCradit;
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
                      _summarycard(
                        "সর্বমোট টাকা",

                        data.amount.toString(),
                        Colors.black,
                      ),
                      _summarycard(
                        " টাকা দিয়েছে",
                        data.paidamount.toString(),
                        Colors.red,
                      ),
                      _summarycard(
                        isCredit ? "টাকা পাবে " : "টাকা দিবে",
                        balnce.abs().toString(),
                        balnce >= 0 ? Colors.black : Colors.red,
                      ),
                    ],
                  ),
                ),
                Text(data.amount.toString()),
                Text(data.paidamount.toString()),
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

  // update condition
  void updateTransaction(BuildContext context, Transaction data) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                "লেনদেনটি কি পরিবর্তন করতে চান?",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),

            content: Text(
              "${data.title} এর এই লেনদেনটি কি পরিবর্তন করতে চান?",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "${data.amount}",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController paidamountController = TextEditingController();
}

Widget _summarycard(var title, var amount, Color color) {
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
              amount,
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
