import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/sized_box.dart';
import '../../common/validators/validators.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        List<UserInfo> providerData = user.providerData;
        bool isGoogleUser =
            providerData.any((info) => info.providerId == "google.com");

        if (isGoogleUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'You signed in with Google. Password change is not allowed!')),
          );
          return;
        }


        // Xác thực lại người dùng bằng mật khẩu cũ
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Nếu xác thực thành công, tiến hành đổi mật khẩu
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Change Password Successfully!')),
        );
        // Helper.navigateAndReplace(context, LoginPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not logged in yet')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Old password is incorrect!')),
        );
      } else if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('You need to log in again to change your password!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.message}')),
        );
      }
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
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back)),
                      KSizedBox.smallWidthSpace,
                      Text(
                        'Create New Password',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  KSizedBox.heightSpace,
                  KSizedBox.heightSpace,
                  _textFormField(
                    text: 'Current Password:',
                    label: 'Enter your current password',
                    controller: _oldPasswordController,
                    validator: (value) => VValidators.validateEmptyText(
                        'Current Password', value),
                    obscureText: true,
                  ),
                  KSizedBox.smallHeightSpace,
                  _textFormField(
                    text: 'New Password:',
                    label: 'Enter your new password',
                    controller: _newPasswordController,
                    validator: (value) => VValidators.validatePassword(value),
                    obscureText: true,
                  ),
                  KSizedBox.smallHeightSpace,
                  _textFormField(
                    text: 'Confirm Password:',
                    label: 'Enter your confirm password',
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  KSizedBox.heightSpace,
                  _updateButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _textFormField({
    required String text,
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    bool obscureText = false,
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
          obscureText: obscureText,
          validator: validator,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  ElevatedButton _updateButton(BuildContext context) => ElevatedButton(
        onPressed: _changePassword,
        child: Text('Confirm'),
      );
}
