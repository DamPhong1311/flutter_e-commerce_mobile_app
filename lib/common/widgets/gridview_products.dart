import 'package:flutter/material.dart';

import '../../pages/home/home_page.dart';
import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../constants/space.dart';
import '../helper/helper.dart';

class GridviewProductsContainer extends StatelessWidget {
  const GridviewProductsContainer({
    super.key,
    this.isSale = false,
    required this.imageProduct,
    required this.nameProduct,
    required this.priceProduct,
    this.oldPrice,
    this.salePercent,
    required this.rateProduct,
    this.isSmallDevice = false
  });

  final String imageProduct;
  final String nameProduct;
  final String priceProduct;
  final bool isSale;
  final String? oldPrice;
  final String? salePercent;
  final String rateProduct;
  final bool isSmallDevice;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 8,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Helper.screenWidth(context) > 600 ? 4 : 2,
        mainAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 8,
        crossAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 8,
        mainAxisExtent: Helper.screenWidth(context) > 600
            ? Helper.screenHeight(context) * 0.35
            : Helper.screenHeight(context) * 0.7,
      ),

      //làm dạng ngang và nếu điện thoại nhỏ sẽ đổi sang dạng đó
      itemBuilder: (_, index) => InfoProductContainerVer(
        imageProduct: imageProduct,
        nameProduct: nameProduct,
        priceProduct: priceProduct,
        isSale: true,
        oldPrice: oldPrice,
        salePercent: salePercent,
        rateProduct: rateProduct,
        isSmallDevice: isSmallDevice,
      ),
    );
  }
}

class InfoProductContainerVer extends StatelessWidget {
  const InfoProductContainerVer(
      {super.key,
      this.isSale = false,
      required this.imageProduct,
      required this.nameProduct,
      required this.priceProduct,
      this.oldPrice,
      this.salePercent,
      required this.rateProduct,
      this.isSmallDevice = false});

  final String imageProduct;
  final String nameProduct;
  final String priceProduct;
  final bool isSale;
  final String? oldPrice;
  final String? salePercent;
  final String rateProduct;
  final bool isSmallDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmallDevice
          ? Helper.screenWidth(context) * 0.8
          : Helper.screenWidth(context) * 0.5,
      height: isSmallDevice
          ? Helper.screenHeight(context) * 0.5
          : Helper.screenHeight(context) * 0.7,
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
              ? KColors.dartModeColor.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05)),
      child: Stack(
        children: [
             Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ImageContainer(image: imageProduct),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: KSpace.horizontalSmallSpace * 2),
                child: ProductInfo(
                  name: nameProduct,
                  price: priceProduct,
                  isSale: isSale,
                  salePercent: ' $salePercent',
                  oldPrice: oldPrice,
                  rate: rateProduct,
                  isSmallDevice: isSmallDevice,
                ),
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}


class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.name,
    required this.price,
    this.isSale = true,
    this.oldPrice,
    this.salePercent,
    required this.rate,
    this.isSmallDevice = false
  });

  final String name;
  final String price;
  final bool isSale;
  final String? oldPrice;
  final String? salePercent;
  final String rate;
  final bool isSmallDevice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
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
            ? isSmallDevice? Row(
                children: [
                  TextPrice(
                    text: oldPrice ?? '',
                    color: Colors.black,
                    isLineThrough: true,
                    getTextSmaller: true,
                  ),
                  Text(
                    salePercent ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: Colors.red),
                  )
                ],
              ): Column(
                children: [
                  TextPrice(
                    text: oldPrice ?? '',
                    color: Colors.black,
                    isLineThrough: true,
                    getTextSmaller: true,
                  ),
                  Text(
                    salePercent ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
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
