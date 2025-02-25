import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Acer extends StatelessWidget {
  const Acer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Acer',
        category: 'laptop',
      ),
    );
  }
}
