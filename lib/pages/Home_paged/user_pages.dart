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
  @override
  Widget build(BuildContext context) {
    final data = widget.transaction;
    final isCredit = data.isCradit;
    var balance = (data.amount - data.paidamount);

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
              backgroundColor: isCredit ? Colors.green : Colors.red,
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
      body: Container(
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
                    Colors.black,
                  ),
                  _summarycard(
                    isCredit ? "টাকা পাবে " : "টাকা দিবে",
                    balance.abs().toString(),
                    isCredit ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: data.history!.length,
                itemBuilder: (context, index) {
                  final item = data;
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.blue,
                      color: Colors.teal.shade50,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productname,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "+880${item.phonenumber}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${item.date.day}/${item.date.month}/${item.date.year}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    item.isCradit ? "টাকা পাবে" : "টাকা দিবে",
                                  ),
                                ),
                              ),
                            ),

                            Column(
                              children: [
                                Text(
                                  "মোট টাকা ${item.amount}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  " টাকা দিয়েছে ${item.paidamount}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  item.isCradit
                                      ? "টাকা পাবে ${balance.abs()}"
                                      : "টাকা দিবে ${balance.abs()}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
    builder: (context) => AlertDialog(
      title: Center(child: Text("টাকা জমা করুন")),
      content: TextField(
        controller: paidamountController, // আপনার তৈরি করা কন্ট্রোলার
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "টাকার পরিমাণ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: Text("বাতিল"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (paidamountController.text.isNotEmpty) {
              double newAmount = double.parse(paidamountController.text);

              setState(() {
                // মূল পেইড অ্যামাউন্ট আপডেট
                data.amount += newAmount;

                // হিস্টোরিতে নতুন ডাটা যোগ
                data.history ??= [];
                data.history!.add({
                  'amount': newAmount,
                  'date': DateTime.now(),
                });
              });

              await data.save(); // Hive-এ সেভ
              paidamountController.clear();
              Get.back();
            }
          },
          child: Text("যোগ করুন"),
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
