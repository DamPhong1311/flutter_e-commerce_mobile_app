import 'package:easy_localization/easy_localization.dart';
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
                'Create_New_Password'.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              Text(
                'Create_New_Pass_Describe'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              KSizedBox.heightSpace,
              _textFormField(
                  text: 'New_Password'.tr(),
                  label: 'Enter_your_new_password'.tr(),
                  context: context),
              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              _textFormField(
                  text: 'Confirm_Password'.tr(),
                  label: 'Enter_your_confirm_password'.tr(),
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
          obscureText: true,
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
        'Continue'.tr(),
      ));
}
