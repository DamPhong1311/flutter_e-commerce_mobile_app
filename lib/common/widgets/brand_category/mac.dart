import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class Mac extends StatelessWidget {
  const Mac({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGridView(
        store: 'Mac',
        category: 'laptop',
      ),
    );
  }
}
