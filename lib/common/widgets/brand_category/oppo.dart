import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Oppo extends StatelessWidget {
  const Oppo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'OPPO',
        category: 'phone',
      ),
    );
  }
}
