import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

import '../../../common/validators/validators.dart';
import '../../../nav_page.dart';
import 'email_verification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
                  'Sign Up to MyShop',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                KSizedBox.heightSpace,
                NameTextField(
                  controller: _nameController,
                ),
                EmailTextField(controller: _emailController),
                PasswordTextField(controller: _passwordController),
                ConfirmPasswordTextField(
                    controller: _confirmPasswordController),
                // KSizedBox.smallHeightSpace,
                // _agreeCheckBox(context),
                KSizedBox.heightSpace,
                ElevatedButton(
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   AuthService()
                      //       .createAccountWithEmail(_emailController.text,
                      //           _passwordController.text, _nameController.text)
                      //       .then((value) {
                      //     if (value == 'Account Created') {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //               content: Text('Account Created')));

                      //       Navigator.restorablePushAndRemoveUntil(
                      //         context,
                      //         (context, arguments) =>
                      //             MaterialPageRoute(builder: (_) => NavPage()),
                      //         (route) => false, // Xóa tất cả các route trước đó
                      //       );
                      //     } else {
                      //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //         content: Text(
                      //           value,
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //         backgroundColor: Colors.red.shade400,
                      //       ));
                      //     }
                      //   });
                      // }
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .createAccountWithEmail(_emailController.text,
                                _passwordController.text, _nameController.text)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value),
                              backgroundColor: Colors.blue.shade400,
                            ),
                          );

                          // Chuyển đến trang xác thực email
                          if (value.contains('Please check your email')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EmailVerificationPage(name: _nameController.text)),
                            );
                          }
                        });
                      }
                    },
                    child: Text(
                      'Create Account',
                    )),
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
          TextSpan(text: 'and ', style: Theme.of(context).textTheme.bodySmall),
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
}

class ConfirmPasswordTextField extends StatelessWidget {
  const ConfirmPasswordTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Confirm Password', style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != controller.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter your confirm password',
          ),
          obscureText: true,
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
          obscureText: true,
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

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) =>
              VValidators.validateEmptyText(controller.text, value),
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter your name',
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
