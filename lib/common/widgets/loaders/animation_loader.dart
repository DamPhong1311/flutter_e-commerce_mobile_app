import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/sized_box.dart';

class WAnimationLoader extends StatelessWidget {
  const WAnimationLoader(
      {required this.text,
      required this.animation,
       this.showAction = false,
      this.actionText,
       this.onActionPressed});

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Lottie.asset(animation, width: Helper.screenWidth(context)*0.8),
            KSizedBox.heightSpace,   
            Text(text,style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center,),
            KSizedBox.heightSpace,
            showAction 
            ? SizedBox(
              width: 250,
              child: OutlinedButton(onPressed: onActionPressed,style: OutlinedButton.styleFrom(
                backgroundColor: KColors.lightModeColor
              ), child: Text(
                actionText!,
                style: Theme.of(context).textTheme.bodyMedium!.apply(color: KColors.dartModeColor),
              )),
            )
            : const SizedBox()
        ],
      ),
    );
  }

  
}
