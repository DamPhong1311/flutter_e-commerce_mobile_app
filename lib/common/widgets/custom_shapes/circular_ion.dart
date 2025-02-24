import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:flutter/material.dart';

class CircularIon extends StatelessWidget {
  const CircularIon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color; // Đổi từ Colors? thành Color?
  final Color? backgroundColor; // Đổi từ Colors? thành Color?
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (Helper.isDarkMode(context)
                ? KColors.dartModeColor
                : KColors.lightModeColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
