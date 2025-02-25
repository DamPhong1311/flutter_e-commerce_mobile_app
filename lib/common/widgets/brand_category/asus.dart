import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Asus extends StatelessWidget {
  const Asus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Asus',
        category: 'laptop',
      ),
    );
  }
}
