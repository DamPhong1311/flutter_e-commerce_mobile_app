import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/acer.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/asus.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/dell.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/iphone.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/laptopac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/lenovo.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/mac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/msi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/phoneac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/realmi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/samsung.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/xiaomi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brandstore/brand_page_view.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/accessories_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/laptop_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/pc_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/smartphone_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/tablet_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:ecommerece_flutter_app/common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import 'package:ecommerece_flutter_app/common/widgets/title/main_title.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/custom_shapes/circular_container.dart';
import '../../common/widgets/gridview_products.dart';
import '../../common/widgets/search/search.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _HomePageState();
}

class _HomePageState extends State<StoreScreen> {
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
                  SearchContainer(
                    onTap: () {
                      //thay login() thành widget cần đi tới
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                  KSizedBox.mediumSpace,
                  MainTitle(title: 'Brand Category'),
                  KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  ListViewHorizontal(),
                  KSizedBox.smallHeightSpace,
                  SizedBox(
                    height: 220,
                    child: BrandPageView(),
                  ),
                ],
              ),
            ),
            MainTitleAndViewAllButton(title: 'Hot', onPressed: () {}),
            KSizedBox.smallHeightSpace,
            GridviewProductsContainer(
              imageProduct: 'assets/images/products/iphone11promax.jpg',
              nameProduct: 'iPhone 11 Pro Max 64GB Chính hãng VN/A',
              priceProduct: '29.000.000đ',
              isSale: true,
              oldPrice: '24.590.000đ',
              salePercent: '-25%',
              rateProduct: '5.0',
              isSmallDevice: Helper.screenWidth(context) < 390 ? true : false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  ClipPath _headerContainer({required Widget child}) {
    return ClipPath(
      clipper: WCustomCurveyEdges(),
      child: Container(
        color: KColors.primaryColor,
        height: 580,
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

WAppBar _textAndCartButton(BuildContext context) {
  return WAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
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
      '${text}VND',
      style: getTextSmaller
          ? Theme.of(context).textTheme.bodyMedium!.apply(
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        image,
        fit: BoxFit.contain,
      ),
    );
  }
}

class ListViewHorizontal extends StatelessWidget {
  ListViewHorizontal({super.key});

  final List<CategoryItem> categories = [
    CategoryItem(name: 'Asus', icon: 'assets/icons/laptop.jpg', page: Asus()),
    CategoryItem(name: 'Acer', icon: 'assets/icons/laptop.jpg', page: Acer()),
    CategoryItem(name: 'Dell', icon: 'assets/icons/laptop.jpg', page: Dell()),
    CategoryItem(
        name: 'Lenovo', icon: 'assets/icons/laptop.jpg', page: Lenovo()),
    CategoryItem(name: 'Mac', icon: 'assets/icons/laptop.jpg', page: Mac()),
    CategoryItem(name: 'Msi', icon: 'assets/icons/laptop.jpg', page: Msi()),
    CategoryItem(
        name: 'Iphone', icon: 'assets/icons/laptop.jpg', page: Iphone()),
    CategoryItem(
        name: 'Samsung', icon: 'assets/icons/laptop.jpg', page: Samsung()),
    CategoryItem(
        name: 'Realmi', icon: 'assets/icons/laptop.jpg', page: Realmi()),
    CategoryItem(
        name: 'Xiaomi', icon: 'assets/icons/laptop.jpg', page: Xiaomi()),
    CategoryItem(
        name: 'Laptop Accessories',
        icon: 'assets/icons/pc.jpeg',
        page: Laptopac()),
    CategoryItem(
        name: 'Phone Accessories',
        icon: 'assets/icons/smartphone.jpg',
        page: Phoneac()),
    CategoryItem(
        name: 'Tablet',
        icon: 'assets/icons/vector-tablet.jpg',
        page: TabletPage()),
    CategoryItem(
        name: 'Accessories',
        icon: 'assets/icons/usb.jpg',
        page: AccessoriesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: KSpace.horizontalSpace),
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => category.page));
            },
            child: ListViewChild(category: category),
          );
        },
      ),
    );
  }
}

class ListViewChild extends StatelessWidget {
  const ListViewChild({super.key, required this.category});

  final CategoryItem category;

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
              child: Image.asset(
                category.icon,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.red, size: 40);
                },
              ),
            ),
          ),
          KSizedBox.smallHeightSpace,
          Text(
            category.name,
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

class CategoryItem {
  final String name;
  final String icon;
  final Widget page;

  CategoryItem({required this.name, required this.icon, required this.page});
}
