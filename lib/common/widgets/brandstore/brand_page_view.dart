import 'package:flutter/material.dart';
import 'brand_model.dart';
import 'brand_card.dart';

class BrandPageView extends StatelessWidget {
  const BrandPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: brandList.length,
      controller: PageController(viewportFraction: 0.9),
      itemBuilder: (context, index) {
        return BrandCard(brand: brandList[index]);
      },
    );
  }
}
