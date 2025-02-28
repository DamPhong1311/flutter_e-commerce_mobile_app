import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:ecommerece_flutter_app/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductInformation.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductImages.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/BottomActionButtons.dart';

class ProductDetail extends StatefulWidget {
  final String name;
  final String rateProduct;
  final String totalReviews = "400";
  final String oldPrice;
  final String salePercent;
  final String priceProduct;
  final bool isSale;
  final String idProduct;
  final String imageUrl;
  final int price;
  const ProductDetail(
      {super.key,
      required this.name,
      required this.rateProduct,
      required this.oldPrice,
      required this.priceProduct,
      required this.salePercent,
      required this.isSale,
      required this.idProduct,
      required this.imageUrl,
      required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final cartService = CartService();
  final List<String> imgList = [
    'assets/images/products/laptop.jpg',
    'assets/images/products/laptop2.jpg',
    'assets/images/products/laptop3.jpg',
    'assets/images/products/laptop4.jpg',
  ];

  int _current = 0;

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
  void someFunction() {
    String? userId = AuthService().getUserId();
    print("User ID: $userId");
  }

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
                  name: widget.name,
                  rateProduct: widget.rateProduct,
                  totalReviews: widget.totalReviews,
                  priceProduct: widget.priceProduct,
                  oldPrice: widget.oldPrice,
                  salePercent: widget.salePercent,
                  specifications: specifications,
                  isSale: widget.isSale,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Đặt WAppBar ở đây để nó hiển thị trên cùng
          Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back,
                            color: Helper.isDarkMode(context)
                                ? Colors.white
                                : Colors.black)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Product Details',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
          // Đặt BottomActionButtons ở đây để nó hiển thị ở dưới cùng
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionButtons(
              priceProduct: widget.priceProduct,
              onAddToCart: () {
                // Handle add to cart
                cartService.addToCart(
                  userId: AuthService().getUserId(),
                  productId: widget.idProduct,
                  name: widget.name,
                  price: widget.price,
                  imageUrl: widget.imageUrl,
                );
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
