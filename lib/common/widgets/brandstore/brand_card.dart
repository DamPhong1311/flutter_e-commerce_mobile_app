import 'package:ecommerece_flutter_app/pages/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'brand_model.dart';

/// Widget hiển thị card của mỗi brand
class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.black.withOpacity(0.6))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row chứa logo + tên thương hiệu + icon verify + số sản phẩm
            Row(
              children: [
                Image.asset(
                  brand.brandLogo,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                Text(
                  brand.brandName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                const Spacer(),
                Text(
                  '${brand.productCount} products',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Hiển thị danh sách ảnh sản phẩm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: brand.productImages.map((imgPath) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetail()), // thay bang duong dan toi product
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imgPath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
