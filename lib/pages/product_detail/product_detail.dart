import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductInformation.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductImages.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/BottomActionButtons.dart';

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

  ];

  final List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.grey,
  ];

  int _current = 0;
  int _selectedColorIndex = 0;

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
                // Đặt ProductImages và ProductInformation ở đây
                ProductImages(
                  imgList: imgList,
                  currentIndex: _current,
                  onImageSelected: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                ProductInformation(
                  productName: "Laptop HP 240 G9 i3 1215U/8GB/512GB/Win11",
                
                  averageRating: averageRating,
                  totalReviews: totalReviews,
                  discountedPrice: discountedPrice,
                  originalPrice: originalPrice,
                  discountPercentage: discountPercentage,
                  colors: colors,
                  selectedColorIndex: _selectedColorIndex,
                  onColorSelected: (index) {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  specifications: specifications,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Đặt WAppBar ở đây để nó hiển thị trên cùng
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WAppBar(
              leadingOnPressed: (){
                Navigator.of(context).pop();
              },
              showBackArrow: true,
              title: Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  "Chi tiết sản phẩm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                
              ),
            ),
          ),
          // Đặt BottomActionButtons ở đây để nó hiển thị ở dưới cùng
          Positioned(
            bottom: 1,
            left: 0,
            right: 0,
            child: BottomActionButtons(
              discountedPrice: discountedPrice,
              onAddToCart: () {
                // Handle add to cart
              },
              onBuyNow: () {
                // Handle buy now
              },
            ),
          ),
        ],
      ),
    );
  }
}
