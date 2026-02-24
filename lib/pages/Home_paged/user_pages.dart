import 'package:accountant/pages/Home_paged/home_page.dart';
import 'package:accountant/pages/data/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

class UserPages extends StatefulWidget {
  const UserPages({super.key});

  @override
  State<UserPages> createState() => _UserPagesState();
}

class _UserPagesState extends State<UserPages> {
  final box = Hive.box<Transaction>('tally_box');

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ব্যবহারকারীর বিবরণ",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => HomePage());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
