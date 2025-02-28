import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/helper/helper.dart';
import '../../common/widgets/gridview_products.dart';
import '../product_detail/product_detail.dart';

class SearchPage extends StatefulWidget {
  final String searchQuery;

  const SearchPage({super.key, required this.searchQuery});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<QuerySnapshot> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: widget.searchQuery)
        .where('name', isLessThanOrEqualTo: '${widget.searchQuery}\uf8ff')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm cho "${widget.searchQuery}"'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không tìm thấy sản phẩm nào.'));
          } else {
            var products = snapshot.data!.docs;
            // return ListView.builder(
            //   itemCount: products.length,
            //   itemBuilder: (context, index) {
            //     var product = products[index];
            //     return ListTile(
            //       title: Text(product['name']),
            //       subtitle: Text('\$${product['priceProduct']}'),
            //     );
            //   },
            // );
            return GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 5),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Helper.screenWidth(context) > 600 ? 4 : 2,
                  mainAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 5,
                  crossAxisSpacing: Helper.screenWidth(context) > 600 ? 20 : 5,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(
                            name: product['name'],
                            priceProduct:
                                Helper.formatCurrency(product['priceProduct']),
                            oldPrice:
                                Helper.formatCurrency(product['oldPrice']),
                            salePercent: product['salePercent'],
                            rateProduct: '4.8',
                            isSale: product['isSale'],
                            idProduct: product['id'],
                            imageUrl: product['imageUrl'],
                            price: product['priceProduct'],
                          ),
                        ),
                      );
                    },
                    child: InfoProductContainerVer(
                      // context: context,
                      imageProduct: product['imageUrl'],
                      nameProduct: product['name'],
                      priceProduct:
                          Helper.formatCurrency(product['priceProduct']),
                      isSale: product['isSale'],
                      oldPrice: Helper.formatCurrency(product['oldPrice']),
                      salePercent: product['salePercent'],
                      rateProduct: '4.8',
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
