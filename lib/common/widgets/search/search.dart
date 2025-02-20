

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sized_box.dart';
import '../../constants/space.dart';
import '../../helper/helper.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key, required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: KSpace.horizontalSpace),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Helper.isDarkMode(context)
                ? KColors.lightModeColor
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KColors.dartModeColor)),
        child: Row(
          children: [
            Icon(Icons.search,
                color: Helper.isDarkMode(context)
                    ? KColors.dartModeColor
                    : KColors.lightModeColor),
            KSizedBox.smallWidthSpace,
            Text(
              'Search in Shop',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
