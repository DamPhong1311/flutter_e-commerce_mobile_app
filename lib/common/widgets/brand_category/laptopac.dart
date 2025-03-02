import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Laptopac extends StatelessWidget {
  const Laptopac({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'laptopac',
        category: 'ac',
      ),
    );
  }
}
