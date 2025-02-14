import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/custom_shapes/circular_container.dart';
import '../../common/widgets/gridview_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _headerContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textAndCartButton(context),
                  KSizedBox.mediumSpace,
                  SearchContainer(),
                  KSizedBox.mediumSpace,
                  MainTitle(title: 'Popular Category'),
                  KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  ListViewHorizontal(),
                  KSizedBox.mediumSpace,
                  KSizedBox.mediumSpace,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  _banner(context),
                  KSizedBox.smallHeightSpace,
                  Center(
                      child: BannerIndicatorRow(currentBanner: currentBanner)),
                  KSizedBox.heightSpace,
                  GridviewProductsContainer(
                    imageProduct: 'assets/images/products/laptop.jpg',
                    nameProduct:
                        'Laptop HP 240 G9 i3 1215U/8GB/512GB/Win11 (6L1X8PA)',
                    priceProduct: '10.480.000',
                    isSale: true,
                    oldPrice: '13.690.000',
                    salePercent: '-23%',
                    rateProduct: '4.8',
               
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox _banner(BuildContext context) {
    return SizedBox(
      height: Helper.screenHeight(context) * (1 / 3),
      width: Helper.screenHeight(context) * 0.85,
      child: CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, _) {
                setState(() {
                  currentBanner = index;
                });
              }),
          items: [
            ImageContainer(image: 'assets/banners/promo_banner1.png'),
            ImageContainer(image: 'assets/banners/promo_banner2.png'),
            ImageContainer(image: 'assets/banners/promo_banner3.png'),
          ]),
    );
  }

  WAppBar _textAndCartButton(BuildContext context) {
    return WAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good day for shopping!',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: KColors.dartModeColor),
            ),
            Text(
              'TechShop',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: Colors.white),
            ),
          ],
        ),
        actions: [_cartButton(context)]);
  }

  Stack _cartButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          padding: EdgeInsets.only(right: 8),
          onPressed: () {},
          icon: Icon(Icons.shopping_cart),
          color: Colors.white,
        ),
        Positioned(
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle),
              child: Text(
                '2',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ))
      ],
    );
  }

  ClipPath _headerContainer({required Widget child}) {
    return ClipPath(
      clipper: WCustomCurveyEdges(),
      child: Container(
        color: KColors.primaryColor,
        height: 400,
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -250,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            Positioned(
                top: 100,
                right: -300,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            Positioned(
                top: 100,
                right: 250,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            child
          ],
        ),
      ),
    );
  }
}


class TextPrice extends StatelessWidget {
  const TextPrice(
      {super.key,
      required this.text,
      this.isLineThrough = false,
      this.getTextSmaller = false,
      required this.color});
  final bool isLineThrough;
  final bool getTextSmaller;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text VND',
      style: getTextSmaller
          ? Theme.of(context).textTheme.bodySmall!.apply(
              color: color,
              decoration: isLineThrough
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)
          : Theme.of(context).textTheme.titleMedium!.apply(
              color: color,
              decoration: isLineThrough
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
    );
  }
}

class BannerIndicatorRow extends StatelessWidget {
  const BannerIndicatorRow({
    super.key,
    required this.currentBanner,
  });

  final int currentBanner;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 3; i++)
          NavContainer(
              color: currentBanner == i ? KColors.primaryColor : Colors.grey)
      ],
    );
  }
}

class NavContainer extends StatelessWidget {
  const NavContainer({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 4,
      margin: EdgeInsets.only(right: KSpace.horizontalSmallSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: color,
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Image(
        image: AssetImage(image),
        fit: BoxFit.contain,
      ),
    );
  }
}

class ListViewHorizontal extends StatelessWidget {
  const ListViewHorizontal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: KSpace.horizontalSpace),
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return ListViewChild();
        },
      ),
    );
  }
}

class ListViewChild extends StatelessWidget {
  const ListViewChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: EdgeInsets.all(KSpace.horizontalSmallSpace),
            decoration: BoxDecoration(
                color: Helper.isDarkMode(context)
                    ? KColors.lightModeColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/laptop_icon.png'),
                fit: BoxFit.cover,
                color: Helper.isDarkMode(context)
                    ? KColors.dartModeColor
                    : KColors.lightModeColor,
              ),
            ),
          ),
          KSizedBox.smallHeightSpace,
          Text(
            'Laptop',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

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

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
