import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/acer.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/asus.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/dell.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/hp.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/iphone.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/laptopac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/lenovo.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/mac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/msi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/oppo.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/pcac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/phoneac.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/realmi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/samsung.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/viewall.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/vivo.dart';
import 'package:ecommerece_flutter_app/common/widgets/brand_category/xiaomi.dart';
import 'package:ecommerece_flutter_app/common/widgets/brandstore/brand_page_view.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:ecommerece_flutter_app/common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import 'package:ecommerece_flutter_app/common/widgets/title/main_title.dart';
import 'package:ecommerece_flutter_app/models/product.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/product_detail.dart';
import 'package:ecommerece_flutter_app/services/product_service.dart';
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
            MainTitleAndViewAllButton(
                title: 'Hot',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewAllPage()));
                }),
            KSizedBox.smallHeightSpace,
            FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Lỗi: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Không có sản phẩm nào"));
                  }

                  List<Product> products = snapshot.data!;
                  return GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            Helper.screenWidth(context) > 600 ? 4 : 2,
                        mainAxisSpacing:
                            Helper.screenWidth(context) > 600 ? 20 : 5,
                        crossAxisSpacing:
                            Helper.screenWidth(context) > 600 ? 20 : 5,
                        mainAxisExtent: Helper.screenWidth(context) > 600
                            ? Helper.screenHeight(context) * 0.27
                            : Helper.screenWidth(context) < 390
                                ? Helper.screenHeight(context) * 0.43
                                : Helper.screenHeight(context) * 0.33,
                      ),

                      //làm dạng ngang và nếu điện thoại nhỏ sẽ đổi sang dạng đó

                      itemBuilder: (_, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            //thay login() thành widget cần đi tới
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail()));
                          },
                          child: InfoProductContainerVer(
                            // context: context,
                            imageProduct: product.imageUrl,
                            nameProduct: product.name,
                            priceProduct:
                                Helper.formatCurrency(product.priceProduct),
                            isSale: product.isSale,
                            oldPrice: Helper.formatCurrency(product.oldPrice),
                            salePercent: product.salePercent,
                            rateProduct: '4.8',
                          ),
                        );
                      });
                })
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
    CategoryItem(name: 'Asus', icon: 'assets/icons/Asus.jpg', page: Asus()),
    CategoryItem(name: 'Acer', icon: 'assets/icons/acer.webp', page: Acer()),
    CategoryItem(name: 'Dell', icon: 'assets/icons/dell.webp', page: Dell()),
    CategoryItem(name: 'HP', icon: 'assets/icons/hp.png', page: Hp()),
    CategoryItem(
        name: 'Lenovo', icon: 'assets/icons/lenovo.webp', page: Lenovo()),
    CategoryItem(name: 'Mac', icon: 'assets/icons/Macbook.webp', page: Mac()),
    CategoryItem(name: 'Msi', icon: 'assets/icons/MSI.png', page: Msi()),
    CategoryItem(
        name: 'Iphone', icon: 'assets/icons/iphone.png', page: Iphone()),
    CategoryItem(
        name: 'Samsung', icon: 'assets/icons/samsung.png', page: Samsung()),
    CategoryItem(
        name: 'Realmi', icon: 'assets/icons/realmi.webp', page: Realmi()),
    CategoryItem(name: 'Oppo', icon: 'assets/icons/oppo.jpg', page: Oppo()),
    CategoryItem(name: 'Vivo', icon: 'assets/icons/vivo.png', page: Vivo()),
    CategoryItem(
        name: 'Xiaomi', icon: 'assets/icons/xiaomi.webp', page: Xiaomi()),
    CategoryItem(
        name: 'Phone AS',
        icon: 'assets/icons/phoneaccessories.jpg',
        page: Phoneac()),
    CategoryItem(
        name: 'Laptop AS',
        icon: 'assets/icons/laptopaccessories.jpg',
        page: Laptopac()),
    CategoryItem(
        name: 'PC AS', icon: 'assets/icons/pcaccessories.png', page: Pcac()),
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
