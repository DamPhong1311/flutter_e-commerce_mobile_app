import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/nav_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/forgot_password.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signup_page.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common/validators/validators.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscured = true;
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
                  'Sign_In_to_MyShop'.tr(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                KSizedBox.heightSpace,
                EmailTextField(
                  controller: _emailController,
                ),
                PasswordTextField(
                  controller: _passwordController,
                  isObscured: isObscured,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: checkBoxShowPassword()),
                    Expanded(child: _forgotPasswordButton(context)),
                  ],
                ),
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

  Row checkBoxShowPassword() {
    return Row(
      children: [
        Checkbox(
          value: !isObscured, // Nếu không ẩn thì checkbox được chọn
          onChanged: (bool? value) {
            setState(() {
              isObscured = !value!; // Đảo trạng thái ẩn/hiện
            });
          },
        ),
        Text("Show_Password".tr()),
      ],
    );
  }

  ElevatedButton _loginButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          AuthService()
              .loginWithEmail(_emailController.text, _passwordController.text)
              .then((value) {
            if (value == 'Login Successfull') {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login_Successfull')));

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => NavPage()),
                (route) => false,
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
        'Sign_In'.tr(),
      ));

  OutlinedButton _registerButton(BuildContext context) => OutlinedButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Text('Create_Account'.tr()));

  Align _forgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment(1, 0),
      child: TextButton(
          onPressed: () {
            Helper.navigateAndReplace(context, ForgotPasswordPage());
          },
          child: Text('Forgot_password'.tr(),
              style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  OutlinedButton _loginWithGGButton() {
    return OutlinedButton(
        onPressed: () async {
          UserCredential? userCredential =
              await AuthService().signInWithGoogle();

          if (userCredential != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );

            Navigator.restorablePushAndRemoveUntil(
              context,
              (context, arguments) =>
                  MaterialPageRoute(builder: (_) => NavPage()),
              (route) => false, // Xóa tất cả các route trước đó
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Login Failed. Please try again.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google_icon.png'),
            KSizedBox.smallWidthSpace,
            Text('Login_with_Google'.tr())
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
              'Or'.tr(),
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
        Text('Email'.tr(), style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) => VValidators.validateEmail(value),
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter_your_email'.tr(),
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
    required this.isObscured,
  });

  final TextEditingController controller;
  final bool isObscured;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password'.tr(), style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) => VValidators.validatePassword(value),
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter_your_password'.tr(),
          ),
          obscureText: isObscured,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
