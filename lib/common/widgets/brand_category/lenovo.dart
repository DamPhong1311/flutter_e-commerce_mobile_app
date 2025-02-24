import 'package:flutter/material.dart';

class Lenovo extends StatelessWidget {
  const Lenovo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laptop Page')),
      body: Center(child: Text('Welcome to Laptop Category!')),
    );
  }
}
