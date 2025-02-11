import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/utils/constants/colors.dart';
import 'package:ecommerece_flutter_app/utils/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              TSizedBox.heightSpace,
              Text(
                'Login to ShopZen',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              TSizedBox.heightSpace,
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
              TSizedBox.smallHeightSpace,
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(value: true, onChanged: (value) {}),
                  ),
                  TSizedBox.smallWidthSpace,
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
              ),
              TSizedBox.heightSpace,
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Create Account',
                  )),
              TSizedBox.smallHeightSpace,
              TSizedBox.smallHeightSpace,
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

  Align _forgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment(1, 0),
      child: TextButton(
          onPressed: () {},
          child: Text('Forgot password?',
              style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  OutlinedButton _loginWithGGButton() {
    return OutlinedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google_icon.png'),
            TSizedBox.smallWidthSpace,
            Text('Login with Google')
          ],
        ));
  }

  Row _orText(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Expanded(
            child: Divider(
          thickness: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? TColors.kDartModeColor
              : TColors.kLightModeColor,
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
              ? TColors.kDartModeColor
              : TColors.kLightModeColor,
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
        TSizedBox.smallHeightSpace,
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
