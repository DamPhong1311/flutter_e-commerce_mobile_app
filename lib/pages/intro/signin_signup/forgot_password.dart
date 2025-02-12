import 'package:ecommerece_flutter_app/pages/intro/signin_signup/create_new_password.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KSizedBox.heightSpace,
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              Text(
                'Enter your email id for the verification process, we will send 4 digit to your email',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              KSizedBox.heightSpace,
              _textFormField(
                  text: 'Email: ', label: 'Enter your email', context: context),
              KSizedBox.heightSpace,
              _continueButton(context),
            
            ],
          ),
        ),
      )),
    );
  }

  ElevatedButton _continueButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        Helper.navigateAndReplace(context, CreateNewPasswordPage());
      },
      child: Text(
        'Continue',
      ));

  Row orText(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Expanded(
            child: Divider(
          thickness: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? KColors.dartModeColor
              : KColors.lightModeColor,
        )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Or',
              style: Theme.of(context).textTheme.labelMedium,
            )),
        Expanded(
            child: Divider(
          thickness: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? KColors.dartModeColor
              : KColors.lightModeColor,
        )),
        Spacer(),
      ],
    );
  }

  Column _textFormField(
      {required String text,
      required String label,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
