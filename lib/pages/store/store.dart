import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/brandstore/brand_page_view.dart';
import 'package:ecommerece_flutter_app/common/widgets/gridview_products.dart';
import 'package:ecommerece_flutter_app/common/widgets/search/search.dart';
import 'package:ecommerece_flutter_app/common/widgets/title/main_title.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/radix_icons.dart';

import '../../common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../intro/signin_signup/signin_page.dart';
import '../product_detail/product_detail.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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
        appBar: AppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leading: IconButton(
              onPressed: () {}, icon: Iconify(RadixIcons.caret_left)),
          actions: [
            Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.only(right: 18),
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.black,
                ),
                Positioned(
                    right: 10,
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SearchContainer(
                onTap: () {
                  //thay login() thành widget cần đi tới
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              KSizedBox.smallHeightSpace,
              SizedBox(
                height: 250,
                child: BrandPageView(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child:
                    MainTitleAndViewAllButton(title: 'Hot', onPressed: () {}),
              ),
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
                    // ListView.builder(
                    //   itemCount: products.length,
                    //   itemBuilder: (context, index) {
                    //     Product product = products[index];
                    //     return GridviewProductsContainer(
                    //       length: products.length,
                    //       imageProduct: product.imageUrl,
                    //       nameProduct:
                    //           product.name,
                    //       priceProduct: Helper.formatCurrency(product.priceProduct),
                    //       isSale: product.isSale,
                    //       oldPrice: Helper.formatCurrency(product.oldPrice),
                    //       salePercent: product.salePercent,
                    //       rateProduct: '4.8',
                    //       isSmallDevice: Helper.screenWidth(context) < 390
                    //           ? true
                    //           : false,
                    //       onTap: () {
                    //         //thay login() thành widget cần đi tới
                    //         Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => ProductDetail()));
                    //       },
                    //     );
                    //   },
                    // );
                  })
            ],
          ),
        ));
  }
}
