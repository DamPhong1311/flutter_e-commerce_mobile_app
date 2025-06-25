import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/cart_button.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/viewall.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/accessories_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/laptop_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/pc_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/categorypage/smartphone_page.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:ecommerece_flutter_app/common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import 'package:ecommerece_flutter_app/pages/cart/cart_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/product_detail.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:ecommerece_flutter_app/services/propose_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  late ScrollController scrollController;
  int currentBanner = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Product> recommendedProducts = [];

  @override
  void initState() {
    loadRecommendedProducts();
    scrollController = ScrollController();
    super.initState();
  }

  Future<void> loadRecommendedProducts() async {
    List<Product> products = await ProposeService()
        .getRecommendedProducts(AuthService().getUserId());
    // print("Loaded products: ${products.length}");
    setState(() {
      recommendedProducts = products;
    });
  }

  void _scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadRecommendedProducts(); // Load lại danh sách mỗi khi trang hiển thị
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await loadRecommendedProducts(); // Cập nhật danh sách khi quay lại
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _headerContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textAndCartButton(context),
                    KSizedBox.mediumSpace,
                    SearchHead(searchController: _searchController),
                    KSizedBox.mediumSpace,
                    MainTitle(title: 'Popular_Category'.tr()),
                    KSizedBox.smallHeightSpace,
                    KSizedBox.smallHeightSpace,
                    ListViewHorizontal(
                        onUpdate: () => loadRecommendedProducts()),
                    // KSizedBox.mediumSpace,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 
                    _banner(context),
                    Center(
                        child:
                            BannerIndicatorRow(currentBanner: currentBanner)),
                    KSizedBox.heightSpace,

                    MainTitle(title: 'Recommend'.tr()),
                    KSizedBox.smallHeightSpace,
                    KSizedBox.smallHeightSpace,

                    FutureBuilder<List<Product>>(
                        future: ProposeService()
                            .getRecommendedProducts(AuthService().getUserId()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Lỗi: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("Không có sản phẩm nào"));
                          }

                          List<Product> products = snapshot.data!;
                          return SizedBox(
                            height: Helper.screenWidth(context) > 600
                                ? Helper.screenHeight(context) * 0.27
                                : Helper.screenWidth(context) < 390
                                    ? Helper.screenHeight(context) * 0.43
                                    : Helper.screenHeight(context) * 0.35,
                            child: ListView.builder(
                                itemCount: products.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  final product = products[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                      // name: product.name,
                                                      rateProduct: '4.8',

                                                      product: product,
                                                    )));
                                        loadRecommendedProducts();
                                      },
                                      child: SizedBox(
                                        width: Helper.screenWidth(context) > 600
                                            ? Helper.screenWidth(context) *
                                                0.25
                                            : Helper.screenWidth(context) < 390
                                                ? Helper.screenWidth(context) *
                                                    0.5
                                                : Helper.screenWidth(context) *
                                                    0.51,
                                        child: InfoProductContainerVer(
                                          rateProduct: '4.8',
                                          product: product,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                    KSizedBox.heightSpace,
                    MainTitleAndViewAllButton(
                        title: 'All'.tr(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewAllPage()));
                        }),
                    KSizedBox.smallHeightSpace,
                    FutureBuilder<List<Product>>(
                        future: ProductService().getProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Lỗi: ${snapshot.error}"));
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
                                    Helper.screenWidth(context) > 600 ? 12 : 5,
                                crossAxisSpacing:
                                    Helper.screenWidth(context) > 600 ? 20 : 3,
                                mainAxisExtent: Helper.screenWidth(context) >
                                        600
                                    ? Helper.screenHeight(context) * 0.27
                                    : Helper.screenWidth(context) < 390
                                        ? Helper.screenHeight(context) * 0.43
                                        : Helper.screenHeight(context) * 0.33,
                              ),

                              //làm dạng ngang và nếu điện thoại nhỏ sẽ đổi sang dạng đó

                              itemBuilder: (_, index) {
                                final product = products[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetail(
                                                  // name: product.name,
                                                  rateProduct: '4.8',

                                                  product: product,
                                                )));
                                    loadRecommendedProducts();
                                  },
                                  child: InfoProductContainerVer(
                                    rateProduct: '4.8',
                                    product: product,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _scrollToTop,
          child: Icon(Icons.arrow_upward),
        ),
      ),
    );
  }

  Center _banner(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Helper.screenHeight(context) * 0.2,
        width: Helper.screenWidth(context),
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
      ),
    );
  }

  WAppBar _textAndCartButton(BuildContext context) {
    return WAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome_Text_Home_Page'.tr(),
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
        WCartButton.cartButton(context: context, color: Colors.white)
        // Positioned(
        //     right: 0,
        //     child: Container(
        //       width: 18,
        //       height: 18,
        //       decoration: BoxDecoration(
        //           color: Colors.black.withValues(alpha: 0.5),
        //           shape: BoxShape.circle),
        //       child: Text(
        //         '2',
        //         style: Theme.of(context)
        //             .textTheme
        //             .labelLarge!
        //             .apply(color: Colors.white),
        //         textAlign: TextAlign.center,
        //       ),
        //     ))
      ],
    );
  }

  ClipPath _headerContainer({required Widget child}) {
    return ClipPath(
      clipper: WCustomCurveyEdges(),
      child: Container(
        color: KColors.primaryColor,
        height: 380,
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
  final VoidCallback onUpdate;
  ListViewHorizontal({super.key, required this.onUpdate});

  final List<CategoryItem> categories = [
    CategoryItem(name: 'Laptop', icon: 'assets/icons/laptop.jpg', page: LaptopPage()),
    CategoryItem(name: 'PC', icon: 'assets/icons/pc.jpeg', page: PcPage()),
    CategoryItem(name: 'Smartphone'.tr(), icon: 'assets/icons/smartphone.jpg', page: SmartphonePage()),
    CategoryItem(name: 'Accessories'.tr(), icon: 'assets/icons/usb.jpg', page: AccessoriesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: KSpace.horizontalSpace),
      height: 80,
      child: Row(
        children: categories.map((category) {
          return Expanded(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => category.page),
                );
                onUpdate();
              },
              child: ListViewChild(category: category),
            ),
          );
        }).toList(),
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
              labelText: 'Search'.tr(),
              labelStyle: Theme.of(context).textTheme.bodySmall,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
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
