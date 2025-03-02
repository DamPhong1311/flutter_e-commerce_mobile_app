import 'package:ecommerece_flutter_app/common/widgets/gridview_products.dart';
import 'package:ecommerece_flutter_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../pages/product_detail/product_detail.dart';
import '../helper/helper.dart';

class ProductGridView extends StatefulWidget {
  final String category;
  final String? store;

  const ProductGridView({super.key, required this.category, this.store});

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  String sortOption = 'Price: Low to High';

  String formatCurrency(int price) {
    return NumberFormat('#,###', 'vi_VN').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.store?.isNotEmpty == true && widget.category.isNotEmpty)
              ? capitalize('${widget.store} - ${widget.category}')
              : (widget.category.isNotEmpty)
                  ? capitalize(widget.category)
                  : (widget.store?.isNotEmpty == true)
                      ? capitalize('${widget.store}')
                      : 'Tất cả sản phẩm',
          style: TextStyle(fontSize: 21),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortOption = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Price: Low to High',
                child: Text('Price: Low to High'),
              ),
              PopupMenuItem(
                value: 'Price: High to Low',
                child: Text('Price: High to Low'),
              ),
            ],
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (widget.category.isNotEmpty && widget.store?.isNotEmpty == true)
            ? FirebaseFirestore.instance
                .collection('products')
                .where('category', isEqualTo: widget.category)
                .where('store', isEqualTo: widget.store)
                .snapshots()
            : (widget.category.isNotEmpty)
                ? FirebaseFirestore.instance
                    .collection('products')
                    .where('category', isEqualTo: widget.category)
                    .snapshots()
                : FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không có sản phẩm nào!'));
          }

          // Chuyển dữ liệu từ Firestore thành danh sách `Product`
          var products = snapshot.data!.docs
              .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>,
                  doc.id)) // Sửa lỗi truyền documentId
              .toList();

          // Áp dụng sắp xếp dựa trên tùy chọn
          if (sortOption == 'Price: Low to High') {
            products.sort((a, b) => a.priceProduct.compareTo(b.priceProduct));
          } else if (sortOption == 'Price: High to Low') {
            products.sort((a, b) => b.priceProduct.compareTo(a.priceProduct));
          }

          return GridView.builder(
            itemCount: products.length,
            padding: EdgeInsets.symmetric(horizontal: 5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              mainAxisSpacing: MediaQuery.of(context).size.width > 600 ? 20 : 5,
              crossAxisSpacing:
                  MediaQuery.of(context).size.width > 600 ? 20 : 5,
              mainAxisExtent: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.height * 0.27
                  : MediaQuery.of(context).size.width < 390
                      ? MediaQuery.of(context).size.height * 0.43
                      : MediaQuery.of(context).size.height * 0.33,
            ),
            itemBuilder: (_, index) {
              final product = products[index]; // `product` là Product
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        name: product.name, // Bây giờ dùng `product.name` được
                        priceProduct:
                            Helper.formatCurrency(product.priceProduct),
                        oldPrice: Helper.formatCurrency(product.oldPrice),
                        salePercent: product.salePercent,
                        rateProduct: '4.8',
                        isSale: product.isSale,
                        idProduct: product.id,
                        imageUrl: product.imageUrl,
                        price: product.priceProduct,
                      ),
                    ),
                  );
                },
                child: InfoProductContainerVer(
                  imageProduct: product.imageUrl,
                  nameProduct: product.name,
                  priceProduct: Helper.formatCurrency(product.priceProduct),
                  isSale: product.isSale,
                  oldPrice: Helper.formatCurrency(product.oldPrice),
                  salePercent: product.salePercent,
                  rateProduct: '4.8',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Hàm viết hoa chữ cái đầu
String capitalize(String text) {
  if (text.isEmpty) return '';
  return text.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return '';
  }).join(' ');
}
