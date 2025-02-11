import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signup_page.dart';
import 'package:ecommerece_flutter_app/utils/constants/colors.dart';
import 'package:ecommerece_flutter_app/utils/constants/sized_box.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TSizedBox.heightSpace,
              Text('Login to ShopZen', style: Theme.of(context).textTheme.headlineLarge,),
              TSizedBox.heightSpace,
              _textFormField(text: 'Email: ' ,label: 'Enter your email' ,context: context),
              _textFormField(text: 'Password: ',label: 'Enter your password'  ,context: context),
              _forgotPasswordButton(context),
              TSizedBox.heightSpace,
              _loginButton(),
              TSizedBox.smallHeightSpace,
              TSizedBox.smallHeightSpace,
              _registerButton(),
              TSizedBox.heightSpace,
              orText(context),
              TSizedBox.heightSpace,
              _loginWithGGButton(),
              
            ],
          ),
        ),
      )),
    );
  }

  ElevatedButton _loginButton() => ElevatedButton(onPressed: (){}, child: Text('Sign In',));

  OutlinedButton _registerButton() => OutlinedButton(onPressed: (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
  }, child: Text('Create Account'));

  Align _forgotPasswordButton(BuildContext context) {
    return Align(
              alignment: Alignment(1, 0),
              child: TextButton(onPressed: (){}, child: Text(
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
                TSizedBox.smallWidthSpace,
                Text('Login with Google')
              ],
            ));
  }

  Row orText(BuildContext context) {
    return Row(
              children: [
                Spacer(),
                Expanded(child: Divider(thickness: 1,color: Theme.of(context).brightness == Brightness.dark  ? TColors.kDartModeColor : TColors.kLightModeColor,)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Or', style: Theme.of(context).textTheme.labelMedium,)),
                Expanded(child: Divider(thickness: 1,color: Theme.of(context).brightness == Brightness.dark  ? TColors.kDartModeColor : TColors.kLightModeColor,)),
                Spacer(),
              ],
            );
  }

  Column _textFormField({required String text,required String label, required BuildContext context}) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text ,style: Theme.of(context).textTheme.titleLarge),
            TSizedBox.smallHeightSpace,
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