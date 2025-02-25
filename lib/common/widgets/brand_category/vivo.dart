import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Vivo extends StatelessWidget {
  const Vivo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'vivo',
        category: 'phone',
      ),
    );
  }
}
