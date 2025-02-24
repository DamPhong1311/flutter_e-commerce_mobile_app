import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomActionButtons extends StatelessWidget {
  final int discountedPrice;
  final Function() onAddToCart;
  final Function() onBuyNow;

  const BottomActionButtons({
    Key? key,
    required this.discountedPrice,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

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
                    formatCurrency(discountedPrice),
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
