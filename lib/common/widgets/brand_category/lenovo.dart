import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Lenovo extends StatelessWidget {
  const Lenovo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Lenovo',
        category: 'laptop',
      ),
    );
  }
}
