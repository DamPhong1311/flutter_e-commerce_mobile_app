import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Phoneac extends StatelessWidget {
  const Phoneac({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'phoneac',
        category: 'ac',
      ),
    );
  }
}
