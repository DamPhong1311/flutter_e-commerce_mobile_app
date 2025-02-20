import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/loaders/animation_loader.dart';

class PFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, // dialog k bị dismiss bởi ấn bên ngoài
      builder: (_) => PopScope(
        canPop: false,  
        child: Container(
          color: Helper.isDarkMode(Get.context!)? KColors.lightModeColor: KColors.dartModeColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250,),
              WAnimationLoader(text: text, animation: animation),
            ],
          ),
        )
        ),
    );
  }
  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}
