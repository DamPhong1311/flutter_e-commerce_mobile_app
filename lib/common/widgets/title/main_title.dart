
import 'package:flutter/material.dart';

import '../../constants/space.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: KSpace.horizontalSpace),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}