import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/sized_box.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

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
                'Create New Password',
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
                  text: 'New Password: ',
                  label: 'Enter your new password',
                  context: context),
              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              _textFormField(
                  text: 'Confirm Password: ',
                  label: 'Enter your confirm password',
                  context: context),
              KSizedBox.heightSpace,
              _updateButton(context),
            ],
          ),
        ),
      )),
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

  ElevatedButton _updateButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        Helper.navigateAndReplace(context, LoginPage());
      },
      child: Text(
        'Continue',
      ));
}
