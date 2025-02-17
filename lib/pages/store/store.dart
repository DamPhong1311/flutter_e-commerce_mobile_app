import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/brandstore/brand_page_view.dart';
import 'package:ecommerece_flutter_app/common/widgets/gridview_products.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/radix_icons.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

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
              SizedBox(
                height: 250,
                child: BrandPageView(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hot',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              GridviewProductsContainer(
                imageProduct: 'assets/images/products/iphone11promax.jpg',
                nameProduct: 'iPhone 11 Pro Max 64GB Chính hãng VN/A',
                priceProduct: '29.000.000đ',
                isSale: true,
                oldPrice: '24.590.000đ',
                salePercent: '-25%',
                rateProduct: '5.0',
                isSmallDevice: Helper.screenWidth(context) < 390 ? true : false,
              ),
            ],
          ),
        ));
  }
}
