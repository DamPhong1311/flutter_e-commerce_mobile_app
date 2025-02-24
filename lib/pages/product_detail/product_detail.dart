import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.grey,
  ];

  int _current = 0;
  int _selectedColorIndex = 0;
  int _quantity = 1;

  final int originalPrice = 12490000;
  final int discountPercentage = 13;
  int get discountedPrice =>
      originalPrice - (originalPrice * discountPercentage ~/ 100);

  final double averageRating = 4.7;
  final int totalReviews = 350;

  String formatCurrency(int price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  final Map<String, String> specifications = {
    "CPU": "Intel Core i3 Alder Lake 1215U, 1.2GHz",
    "RAM": "8GB DDR4 3200MHz",
    "Ổ cứng": "512GB SSD NVMe PCIe",
    "Màn hình": "14 inch Full HD (1920x1080)",
    "Card đồ họa": "Intel UHD Graphics",
    "Hệ điều hành": "Windows 11 Home",
    "Trọng lượng": "1.47 kg",
    "Pin": "3 cell, 41Wh",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                              physics: const AlwaysScrollableScrollPhysics(),
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
                          top: -8,
                          left: 0,
                          right: 0,
                          child: const WAppBar(
                            showBackArrow: true,
                            title: Padding(
                              padding: EdgeInsets.only(left: 35),
                              child: Text(
                                "Chi tiết sản phẩm",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Laptop HP 240 G9 i3 1215U/8GB/512GB/Win11",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 5),
                          Text(
                            "$averageRating",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "($totalReviews đánh giá)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            formatCurrency(discountedPrice),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: KColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatCurrency(originalPrice),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "-$discountPercentage%",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("Màu sắc",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(
                          colors.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColorIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColorIndex == index
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text("Thông số kỹ thuật",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      ...specifications.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(entry.value,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_cart,
                        color: KColors.primaryColor,
                        size: 24,
                      ),
                      label: Text(
                        "Thêm vào giỏ hàng",
                        style: TextStyle(
                          color: KColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 21),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Mua ngay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatCurrency(discountedPrice),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
