import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'brand_model.dart';
import 'brand_card.dart';

class BrandPageView extends StatefulWidget {
  const BrandPageView({super.key});

  @override
  _BrandPageViewState createState() => _BrandPageViewState();
}

class _BrandPageViewState extends State<BrandPageView> {
  final List<Brand> brandList = [];

  @override
  void initState() {
    super.initState();
    fetchBrandsFromFirestore();
  }

  Future<void> fetchBrandsFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final Map<String, List<String>> brandProductsMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final brandName = data['store'] ?? '';
        final productImages = List<String>.from(data['imageGallery'] ?? []);

        if (brandName.isNotEmpty &&
            brandName != 'Asus' && // Bỏ brand Asus
            ['iPhone', 'Samsung', 'Acer', 'HP', 'Dell'].contains(brandName)) {
          if (!brandProductsMap.containsKey(brandName)) {
            brandProductsMap[brandName] = [];
          }

          brandProductsMap[brandName]?.addAll(productImages);
        }
      }

      final List<Brand> brands = brandProductsMap.entries.map((entry) {
        return Brand(
          brandName: entry.key,
          brandLogo: entry.value.isNotEmpty ? entry.value.first : '',
          productCount: entry.value.length, // Đếm số lượng sản phẩm thực tế
          productImages: entry.value,
        );
      }).toList();

      setState(() {
        brandList.clear();
        brandList.addAll(brands);
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu từ Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: brandList.length,
      controller: PageController(viewportFraction: 0.9),
      itemBuilder: (context, index) {
        return BrandCard(brand: brandList[index]);
      },
    );
  }
}
