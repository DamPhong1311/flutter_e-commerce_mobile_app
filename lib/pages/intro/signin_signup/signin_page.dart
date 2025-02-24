import 'package:ecommerece_flutter_app/nav_page.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/forgot_password.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signup_page.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

import '../../../common/validators/validators.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KSizedBox.heightSpace,
                Text(
                  'Sign In to MyShop',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                KSizedBox.heightSpace,
                EmailTextField(
                  controller: _emailController,
                ),
                PasswordTextField(
                  controller: _passwordController,
                ),
                _forgotPasswordButton(context),
                KSizedBox.heightSpace,
                _loginButton(context),
                KSizedBox.smallHeightSpace,
                KSizedBox.smallHeightSpace,
                _registerButton(context),
                KSizedBox.heightSpace,
                orText(context),
                KSizedBox.heightSpace,
                _loginWithGGButton(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  ElevatedButton _loginButton(BuildContext context) => ElevatedButton(
      onPressed: () {
         if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {

                          if (value == 'Login Successfull') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login Successfull')));
                                    
                            Navigator.restorablePushAndRemoveUntil(
                              context,
                              (context, arguments) =>
                                  MaterialPageRoute(builder: (_) => NavPage()),
                              (route) => false, // Xóa tất cả các route trước đó
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              backgroundColor: Colors.red.shade400,
                            ));
                          }
                        });
                      }
      },
      child: Text(
        'Sign In',
      ));

  OutlinedButton _registerButton(BuildContext context) => OutlinedButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Text('Create Account'));

  Align _forgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment(1, 0),
      child: TextButton(
          onPressed: () {
            Helper.navigateAndReplace(context, ForgotPasswordPage());
          },
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
            KSizedBox.smallWidthSpace,
            Text('Login with Google')
          ],
        ));
  }

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

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          
          validator: (value) => VValidators.validateEmail(value),
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter your email',
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) => VValidators.validatePassword(value),
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter your password',
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
