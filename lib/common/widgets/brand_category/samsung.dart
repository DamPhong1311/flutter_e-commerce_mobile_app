import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Samsung extends StatelessWidget {
  const Samsung({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Samsung',
        category: 'phone',
      ),
    );
  }
}
