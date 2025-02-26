import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/header/header_container.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WHeaderContainer.headerContainer(
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Helper.isDarkMode(context)
                              ? KColors.lightModeColor
                              : KColors.dartModeColor,
                        )),
                    KSizedBox.smallWidthSpace,
                    Text(
                      "Your Cart",
                      style: Theme.of(context).textTheme.headlineMedium!.apply(
                          color: Helper.isDarkMode(context)
                              ? KColors.lightModeColor
                              : Colors.white),
                    )
                  ],
                ),
              ),
              height: 150),
          KSizedBox.heightSpace,
          infoProductCart(
              context: context,
              name: 'Laptop sieuasd ádasdasdasd ádasdasdasdasdddsadsadsd',
              imageUrl:
                  "https://bizweb.dktcdn.net/thumb/large/100/386/607/products/msi-modern-15-man-hinh-cbc4d36c-8e6c-4b32-a9ef-195bdbee0f79.jpg?v=1723108351407",
              priceProduct: "12.312.312",
              isSale: true,
              oldPrice: "12.321.123",
              salePercent: '23%')
        ],
      ),
    );
  }

  Container infoProductCart(
      {required BuildContext context,
      required String imageUrl,
      required String name,
      required String priceProduct,
      required String oldPrice,
      required String salePercent,
      required bool isSale}) {
    return Container(
      width: Helper.screenWidth(context) * 0.95,
      height: Helper.screenHeight(context) * 0.2,
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
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Đặt border radius ở đây
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Giúp ảnh vừa khít container
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  KSizedBox.smallHeightSpace,
                  // KSizedBox.smallHeightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TextPrice(
                    text: priceProduct,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  isSale
                      ? Row(
                          children: [
                            TextPrice(
                              text: oldPrice,
                              color: Colors.black,
                              isLineThrough: true,
                              getTextSmaller: true,
                            ),
                            KSizedBox.smallWidthSpace,
                            Text(
                              salePercent,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(color: Colors.red),
                            )
                          ],
                        )
                      : SizedBox()
                        ],
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.blue,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
