import 'package:flutter/material.dart';

import '../../../pages/cart/cart_page.dart';

class WCartButton {
  WCartButton._();

  static Widget cartButton({required BuildContext context, required Color? color}) {
    return IconButton(
      padding: EdgeInsets.only(right: 8),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const CartPage()));
      },
      icon: Icon(Icons.shopping_cart),
      color: color,
    );
  }
}
