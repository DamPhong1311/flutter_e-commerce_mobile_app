import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = "Đang tải...";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  Future<void> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        name = userDoc['name'] ?? "Không có tên";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            KSizedBox.heightSpace,
            KSizedBox.heightSpace,
            Text(name),
            ElevatedButton(
                onPressed: () async {
                  await AuthService().logout();
                  Helper.navigateAndReplace(context, LoginPage());
                },
                child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
