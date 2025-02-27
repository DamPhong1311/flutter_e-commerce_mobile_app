import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  Helper._();

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void navigateAndReplace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static String formatCurrency(int price) {
    final format = NumberFormat("#,###", "vi_VN");
    return format.format(price);
  }
  static int parseToIntCurrency(String formattedPrice) {
  String cleanedPrice = formattedPrice.replaceAll(',', ''); // Loại bỏ dấu phẩy
  return int.tryParse(cleanedPrice) ?? 0; // Chuyển về int, nếu lỗi trả về 0
}
}
