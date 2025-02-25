import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Iphone extends StatelessWidget {
  const Iphone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'iphone',
        category: 'phone',
      ),
    );
  }
}
