import 'package:flutter/material.dart';

class LaptopPage extends StatelessWidget {
  const LaptopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laptop Page')),
      body: Center(child: Text('Welcome to Laptop Category!')),
    );
  }
}
