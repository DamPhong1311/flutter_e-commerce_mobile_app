import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Pcac extends StatelessWidget {
  const Pcac({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'pcac',
        category: 'ac',
      ),
    );
  }
}
