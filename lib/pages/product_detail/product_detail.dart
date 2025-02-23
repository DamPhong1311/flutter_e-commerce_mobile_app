import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/constants/space.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:ecommerece_flutter_app/common/widgets/main_title_view_all_butotn/main_title_and_viewall_button.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/custom_shapes/circular_container.dart';
import '../../common/widgets/gridview_products.dart';
import '../../common/widgets/search/search.dart';
import '../../common/widgets/title/main_title.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final List<String> imgList = [
    'assets/images/products/laptop.jpg',
    'assets/images/products/laptop2.jpg',
    'assets/images/products/laptop3.jpg',
    'assets/images/products/laptop4.jpg',
    'assets/images/products/laptop5.jpg',
    'assets/images/products/laptop6.jpg',
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedEdgesWidget(
              child: Container(
                color: Helper.isDarkMode(context)
                    ? KColors.lightModeColor
                    : Colors.white,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Image(
                            image: AssetImage(imgList[_current]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20,
                      left: 20,
                      child: SizedBox(
                        height: 60,
                        child: ListView.separated(
                          itemCount: imgList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _current = index;
                                });
                              },
                              child: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _current == index
                                        ? Colors.black
                                        : Colors.grey,
                                    width: _current == index ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image(
                                    image: AssetImage(imgList[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        title: const Text(
                          "Product Details",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: ' 5.0 ',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const TextSpan(text: '(120)'),
                          ]))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
