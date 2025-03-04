import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../pages/home/home_page.dart';
import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../constants/space.dart';
import '../helper/helper.dart';

class InfoProductContainerVer extends StatelessWidget {
  const InfoProductContainerVer({
    super.key,
    this.isSale = false,
    this.imageProduct,
    this.nameProduct,
     this.priceProduct,
    this.oldPrice,
    this.salePercent,
    required this.rateProduct,
    required this.product,
  });

  final String? imageProduct;
  final String? nameProduct;
  final String? priceProduct;
  final bool? isSale;
  final String? oldPrice;
  final String? salePercent;
  final String rateProduct;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Helper.screenWidth(context) * 0.5,
      height: Helper.screenHeight(context) * 0.7,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: KColors.dartModeColor.withValues(alpha: 0.1),
                blurRadius: 50,
                spreadRadius: 7,
                offset: Offset(0, 2)),
          ],
          borderRadius: BorderRadius.circular(16),
          color: Helper.isDarkMode(context)
              ? KColors.dartModeColor.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1)),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Image.network(product.imageUrl)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: KSpace.horizontalSmallSpace * 2),
                  child: productInfo(
                    context: context,
                    name: product.name,
                    price:  Helper.formatCurrency(
                                      product.priceProduct),
                    isSale: product.isSale,
                    salePercent: ' ${product.salePercent}',
                    oldPrice:  Helper.formatCurrency(
                                      product.oldPrice),
                    rate: rateProduct,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productInfo({
    required BuildContext context,
    required String name,
    required String price,
    bool isSale = false,
    required String? oldPrice,
    required String? salePercent,
    required String rate,
    bool isSmallDevice = false,
  }) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        KSizedBox.smallHeightSpace,
        Row(
          children: [
            TextPrice(
              text: price,
              color: Colors.red,
            ),
          ],
        ),
        isSale
            ? Row(
                children: [
                  TextPrice(
                    text: oldPrice ?? '',
                    color: Colors.black,
                    isLineThrough: true,
                    getTextSmaller: true,
                  ),
                  isSmallDevice
                      ? SizedBox()
                      : Text(
                          salePercent ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: Colors.red),
                        )
                ],
              )
            : SizedBox(height: 22),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            KSizedBox.smallWidthSpace,
            Text(
              rate,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: Colors.orange),
            )
          ],
        )
      ],
    );
  }
}
