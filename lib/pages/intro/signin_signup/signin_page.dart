import 'package:ecommerece_flutter_app/nav_page.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/forgot_password.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signup_page.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KSizedBox.heightSpace,
              Text('Sign In to ShopZen', style: Theme.of(context).textTheme.headlineLarge,),
              KSizedBox.heightSpace,
              _textFormField(text: 'Email: ' ,label: 'Enter your email' ,context: context),
              _textFormField(text: 'Password: ',label: 'Enter your password'  ,context: context),
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
      )),
    );
  }

  ElevatedButton _loginButton(BuildContext context) => ElevatedButton(onPressed: (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NavPage()));
  }, child: Text('Sign In',));

  OutlinedButton _registerButton(BuildContext context) => OutlinedButton(onPressed: (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
  }, child: Text('Create Account'));

  Align _forgotPasswordButton(BuildContext context) {
    return Align(
              alignment: Alignment(1, 0),
              child: TextButton(onPressed: (){
                Helper.navigateAndReplace(context, ForgotPasswordPage());
              }, child: Text(
                'Forgot password?',
                style: Theme.of(context).textTheme.titleLarge
              )),
            );
  }

  OutlinedButton _loginWithGGButton() {
    return OutlinedButton(onPressed: (){}, child: Row(
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
                Expanded(child: Divider(thickness: 1,color: Theme.of(context).brightness == Brightness.dark  ? KColors.dartModeColor : KColors.lightModeColor,)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Or', style: Theme.of(context).textTheme.labelMedium,)),
                Expanded(child: Divider(thickness: 1,color: Theme.of(context).brightness == Brightness.dark  ? KColors.dartModeColor : KColors.lightModeColor,)),
                Spacer(),
              ],
            );
  }

  Column _textFormField({required String text,required String label, required BuildContext context}) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text ,style: Theme.of(context).textTheme.titleLarge),
            KSizedBox.smallHeightSpace,
            TextFormField(
              decoration: InputDecoration(
                labelText: label,

              ),
            ),
            SizedBox(height: 20,)
          ],
        );
  }
}