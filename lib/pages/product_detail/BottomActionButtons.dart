import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomActionButtons extends StatelessWidget {
  final String priceProduct;
  final Function() onAddToCart;
  final Function() onBuyNow;

  const BottomActionButtons({
    super.key,
    required this.priceProduct,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  String formatCurrency(int price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAddToCart,
              icon: Icon(
                Icons.shopping_cart,
                color: KColors.primaryColor,
                size: 24,
              ),
              label: Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(
                  color: KColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 22),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: onBuyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Mua ngay",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    priceProduct,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
