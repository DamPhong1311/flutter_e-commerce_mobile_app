import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:ecommerece_flutter_app/services/cart_service.dart';
import 'package:ecommerece_flutter_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductInformation.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/ProductImages.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/BottomActionButtons.dart';
import 'package:ecommerece_flutter_app/pages/checkout/checkout.dart';
import 'package:ecommerece_flutter_app/models/cart_item.dart';

import '../../models/product.dart';

class ProductDetail extends StatefulWidget {
  final String? name;
  final String rateProduct;
  final String totalReviews = "400";
  final String? oldPrice;
  final String? salePercent;
  final String? priceProduct;
  final bool? isSale;
  final String? idProduct;
  final String? imageUrl;
  final List<String>? imageList;
  final int? price;
  final Product product;

  const ProductDetail({
    super.key,
    this.name,
    required this.rateProduct,
    this.oldPrice,
    this.salePercent,
     this.priceProduct,
    this.isSale,
    this.idProduct,
    this.imageUrl,
    this.imageList,
    this.price,
    required this.product,

  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final cartService = CartService();
  late List<String> imgList = [

    widget.product.imageUrl,
    widget.product.imageGallery[0],
    widget.product.imageGallery[1],
    widget.product.imageGallery[2],

  ];

  int _current = 0;

  String formatCurrency(int price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  final Map<String, String> specifications = {
    "CPU": "Intel Core i3 Alder Lake 1215U, 1.2GHz",
    "RAM": "8GB DDR4 3200MHz",
    "Solid-state drive": "512GB SSD NVMe PCIe",
    "screen": "14 inch Full HD (1920x1080)",
    "GPU": "Intel UHD Graphics",
    "OS": "Windows 11 Home",
    "Weight": "1.47 kg",
    "Battery": "3 cell, 41Wh",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                  name: widget.product.name,
                  rateProduct: widget.rateProduct,
                  totalReviews: widget.totalReviews,
                  priceProduct: Helper.formatCurrency(widget.product.priceProduct),
                  oldPrice: Helper.formatCurrency(widget.product.oldPrice),
                  salePercent: widget.product.salePercent,
                  specifications: specifications,
                  isSale: widget.product.isSale,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
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
                            : Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Product Details',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionButtons(
              priceProduct: Helper.formatCurrency(widget.product.priceProduct),
              onAddToCart: () async {
                cartService.addToCart(
                  userId: AuthService().getUserId(),
                  productId: widget.product.id,
                  name: widget.product.name,
                  price: widget.product.priceProduct,
                  imageUrl: widget.product.imageUrl,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to the cart')),
                );

                await NotificationService.addNotification(
                  AuthService().getUserId(),
                  'You have successfully added ${widget.product.name} to your cart! Check your cart for more details',
                );
              },
              onBuyNow: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                    
                        cartItem: CartItem(
                          id: widget.product.id,
                          name: widget.product.name,
                          price: widget.product.priceProduct,
                          imageUrl: widget.product.imageUrl,
                          quantity: 1,
                          total: widget.product.priceProduct,
                        ),
                      
                      totalPrice: widget.product.priceProduct.toDouble(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
