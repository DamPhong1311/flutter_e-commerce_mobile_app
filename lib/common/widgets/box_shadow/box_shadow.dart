import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class WBoxShadowStyle {
  static final productShadow = BoxShadow(
      color: KColors.dartModeColor.withValues(alpha: 0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: Offset(0, 2));
  
  
}
