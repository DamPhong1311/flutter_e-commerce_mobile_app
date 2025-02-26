import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Xiaomi extends StatelessWidget {
  const Xiaomi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Xiaomi',
        category: 'phone',
      ),
    );
  }
}
