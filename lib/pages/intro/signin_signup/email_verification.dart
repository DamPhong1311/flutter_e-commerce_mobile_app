import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../nav_page.dart';
import '../../../services/auth_service.dart';

class EmailVerificationPage extends StatefulWidget {
  late String name;

  EmailVerificationPage({super.key, required this.name});
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  void checkEmailVerificationAndNavigate(BuildContext context) async {
    bool isVerified = await AuthService().checkEmailVerification(widget.name);

    if (isVerified) {
      // Chuyển hướng vào app chính
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavPage()), // Trang chính
      );
    } else {
      // Hiển thị thông báo nếu chưa xác thực
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bạn chưa xác thực email. Vui lòng kiểm tra lại."),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify_email'.tr())),
      body: Center(
        child: SizedBox(
          width: Helper.screenWidth(context)*0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Verify_email_decribe'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 180),
              ElevatedButton(
                onPressed: () {
                  checkEmailVerificationAndNavigate(context);
                },
                child: Text('Continue'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
