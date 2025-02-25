import 'package:ecommerece_flutter_app/common/widgets/brand_category/viewall.dart';
import 'package:flutter/material.dart';

import '../title/main_title.dart';

class MainTitleAndViewAllButton extends StatelessWidget {
  const MainTitleAndViewAllButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainTitle(title: title),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllPage(),
                ));
          },
          child: Text(
            'View all',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
