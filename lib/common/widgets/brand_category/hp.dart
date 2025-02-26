import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Hp extends StatelessWidget {
  const Hp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'HP',
        category: 'laptop',
      ),
    );
  }
}
