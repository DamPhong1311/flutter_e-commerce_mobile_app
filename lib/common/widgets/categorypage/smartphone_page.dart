import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class SmartphonePage extends StatelessWidget {
  const SmartphonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        category: 'phone',
      ),
    );
  }
}
