import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

import '../../nav_page.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Helper.screenWidth(context) * 0.9,
          child: SafeArea(
            child: Stack(
              
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green, size: 100),
                        SizedBox(height: 20),
                        Text('Payment_Success'.tr(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Payment_Success_Notification'.tr()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Positioned(
                bottom: 1,
                right: 1,
                left: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NavPage()));
                  },
                  child: Text('Continue_Shopping'.tr()),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
