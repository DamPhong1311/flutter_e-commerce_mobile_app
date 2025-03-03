import 'package:ecommerece_flutter_app/common/validators/validators.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A password reset email has been sent!')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage())); // Quay về trang đăng nhập
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KSizedBox.heightSpace,
                  Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  KSizedBox.smallHeightSpace,
                  Text(
                    'Enter your email for verification. We will send a reset link.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  KSizedBox.heightSpace,
                  _textFormField(
                    text: 'Email:',
                    label: 'Enter your email',
                    controller: _emailController,
                  ),
                  KSizedBox.heightSpace,
                  _continueButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _continueButton(BuildContext context) => ElevatedButton(
        onPressed: _resetPassword,
        child: Text('Continue'),
      );

  Column _textFormField({
    required String text,
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
          validator:(value) => VValidators.validateEmail(value),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
