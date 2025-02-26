import 'package:ecommerece_flutter_app/common/widgets/productgridviewdetail.dart';
import 'package:flutter/material.dart';

class ViewAllPage extends StatelessWidget {
  const ViewAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProductGridView(
        category: '', // Không truyền category
        store: '', // Không truyền store
      ),
    );
  }
}
