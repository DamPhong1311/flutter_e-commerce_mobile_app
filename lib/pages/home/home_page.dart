import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:ecommerece_flutter_app/common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import 'package:ecommerece_flutter_app/pages/cart/cart_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/product_detail.dart';

import '../../common/widgets/custom_shapes/circular_container.dart';
import '../../common/widgets/gridview_products.dart';
import '../../common/widgets/search/search.dart';
import '../../common/widgets/title/main_title.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBanner = 0;
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  @override
  void initState() {
    _productsFuture = _productService.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            headerContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textAndCartButton(context),
                  KSizedBox.mediumSpace,
                  SearchHead(searchController: _searchController),
                  KSizedBox.mediumSpace,
                  MainTitle(title: 'Popular Category'),
                  KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  ListViewHorizontal(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                  KSizedBox.mediumSpace,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  _banner(context),
                  Center(
                      child: BannerIndicatorRow(currentBanner: currentBanner)),
                  KSizedBox.heightSpace,
                  MainTitleAndViewAllButton(title: 'Sale', onPressed: () {}),
                  KSizedBox.smallHeightSpace,
                  KSizedBox.smallHeightSpace,
                  FutureBuilder<List<Product>>(
                      future: _productsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Lỗi: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("Không có sản phẩm nào"));
                        }

                        List<Product> products = snapshot.data!;
                        return GridView.builder(
                            itemCount: products.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  Helper.screenWidth(context) > 600 ? 4 : 2,
                              mainAxisSpacing:
                                  Helper.screenWidth(context) > 600 ? 20 : 5,
                              crossAxisSpacing:
                                  Helper.screenWidth(context) > 600 ? 20 : 3,
                              mainAxisExtent: Helper.screenWidth(context) > 600
                                  ? Helper.screenHeight(context) * 0.27
                                  : Helper.screenWidth(context) < 390
                                      ? Helper.screenHeight(context) * 0.43
                                      : Helper.screenHeight(context) * 0.33,
                            ),
                            itemBuilder: (_, index) {
                              final product = products[index];
                              return GestureDetector(
                                onTap: () {
                                  //thay login() thành widget cần đi tới
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(

                                        )),
                                  );
                                },
                                child: InfoProductContainerVer(
                                  // context: context,
                                  imageProduct: product.imageUrl,
                                  nameProduct: product.name,
                                  priceProduct: Helper.formatCurrency(
                                      product.priceProduct),
                                  isSale: product.isSale,
                                  oldPrice:
                                      Helper.formatCurrency(product.oldPrice),
                                  salePercent: product.salePercent,
                                  rateProduct: '4.8',
                                ),
                              );
                            });
                      })
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          },
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

  ClipPath headerContainer({required Widget child}) {
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

class SearchHead extends StatelessWidget {
  const SearchHead({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Helper.screenWidth(context) * 0.9,
        decoration: BoxDecoration(
            color: Helper.isDarkMode(context)
                ? KColors.lightModeColor
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: KColors.dartModeColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelText: '  Nhập tên sản phẩm',
              labelStyle: Theme.of(context).textTheme.bodySmall,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  String searchQuery = _searchController.text.trim();
                  if (searchQuery.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(searchQuery: searchQuery),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
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
  const ListViewHorizontal({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

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
          return GestureDetector(onTap: onTap, child: ListViewChild());
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
                image: AssetImage('assets/icons/laptop.jpg'),
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
