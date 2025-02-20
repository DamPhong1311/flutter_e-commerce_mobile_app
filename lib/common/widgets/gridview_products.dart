import 'package:flutter/material.dart';

import '../../pages/home/home_page.dart';
import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../constants/space.dart';
import '../helper/helper.dart';

class GridviewProductsContainer extends StatelessWidget {
  const GridviewProductsContainer(
      {super.key,
      this.isSale = false,
      required this.imageProduct,
      required this.nameProduct,
      required this.priceProduct,
      this.oldPrice,
      this.salePercent,
      required this.rateProduct,
      this.isSmallDevice = false, 
      required this.onTap});

  final String imageProduct; 
  final String nameProduct; 
  final String priceProduct;
  final bool isSale;
  final String? oldPrice;
  final String? salePercent;
  final String rateProduct;
  final bool isSmallDevice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 8,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Helper.screenWidth(context) > 600 ? 4 : 2,
        mainAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 5,
        crossAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 5,
        mainAxisExtent: Helper.screenWidth(context) > 600
            ? Helper.screenHeight(context) * 0.27
            : isSmallDevice ? Helper.screenHeight(context) * 0.43 : Helper.screenHeight(context) * 0.33,
      ),

      //làm dạng ngang và nếu điện thoại nhỏ sẽ đổi sang dạng đó
      itemBuilder: (_, index) => GestureDetector(
        onTap: onTap,
        child: infoProductContainerVer(
          context: context,
          imageProduct: imageProduct,
          nameProduct: nameProduct,
          priceProduct: priceProduct,
          isSale: true,
          oldPrice: oldPrice,
          salePercent: salePercent,
          rateProduct: rateProduct,
          isSmallDevice: isSmallDevice,
        ),
      ),
    );
  }

  Widget infoProductContainerVer(
      {required BuildContext context,
      required String imageProduct,
      required String nameProduct,
      required String priceProduct,
      bool isSale = false,
      String? oldPrice,
      String? salePercent,
      required String rateProduct,
      bool isSmallDevice = false}) {
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
                  child: ImageContainer(image: imageProduct),
                ),
              ),
              Expanded(
               
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: KSpace.horizontalSmallSpace * 2),
                  child: productInfo(
                    context: context,
                    name: nameProduct,
                    price: priceProduct,
                    isSale: isSale,
                    salePercent: ' $salePercent',
                    oldPrice: oldPrice,
                    rate: rateProduct,
                    isSmallDevice: isSmallDevice,
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
                              .titleSmall!
                              .apply(color: Colors.red),
                        )
                ],
              )
            : SizedBox(),
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
