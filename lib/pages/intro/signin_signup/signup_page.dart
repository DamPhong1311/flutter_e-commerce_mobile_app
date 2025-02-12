import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                'Sign Up to ShopZen',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              KSizedBox.heightSpace,
              _textFormField(
                  text: 'Email: ', label: 'Enter your email', context: context),
              _textFormField(
                  text: 'Password: ',
                  label: 'Enter your password',
                  context: context),
              _textFormField(
                  text: 'Confirm Password: ',
                  label: 'Enter your password',
                  context: context),
              KSizedBox.smallHeightSpace,
              _agreeCheckBox(context),
              KSizedBox.heightSpace,
              _createAccButton(),
              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Sign In'))
            ],
          ),
        ),
      )),
    );
  }

  Row _agreeCheckBox(BuildContext context) {
    return Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(value: true, onChanged: (value) {}),
                ),
                KSizedBox.smallWidthSpace,
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'I agree to ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: 'Privacy Policy ',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: Helper.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Helper.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          )),
                  TextSpan(
                      text: 'and ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: 'Terms of use',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: Helper.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Helper.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          )),
                ]))
              ],
            );
  }

  ElevatedButton _createAccButton() {
    return ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Create Account',
                ));
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