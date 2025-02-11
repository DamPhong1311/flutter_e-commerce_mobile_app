import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    String welcomeText = 'Welcome to MyShop';
    String welcomeSubText =
        'Your one-stop destination for hassle-\nfree online shopping';
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Expanded(flex:5, child: Image.asset('assets/images/onboarding_image.png')),
          Spacer(),
          Expanded(
            flex: 2,
            child: textAndSubtext(text: welcomeText, subText: welcomeSubText, context: context),
          ),
          Spacer(),
          Expanded(child: _getStartedButton(context)),
          SizedBox(height: 30,)
        ],
      )),
    );
  }

  FractionallySizedBox _getStartedButton(BuildContext context) {
    return FractionallySizedBox(
            widthFactor: 0.9,
            child: ElevatedButton(onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }, child: Text('GET STARTED')),
          );
  }

  Widget textAndSubtext(
      {required String text,
      required String subText,
      required BuildContext context}) {
    return Column(
      children: [
        Text(text,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center),
        SizedBox(
          height: 12,
        ),
        Text(
          subText,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
