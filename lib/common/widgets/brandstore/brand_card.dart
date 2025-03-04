import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/pages/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'brand_model.dart';

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
        side: BorderSide(color: Colors.black.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị logo và tên thương hiệu
            Row(
              children: [
                Image.network(
                  brand.brandLogo,
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                const SizedBox(width: 8),
                Text(
                  brand.brandName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${brand.productCount} sản phẩm',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Hiển thị danh sách ảnh sản phẩm từ Firestore
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: brand.products.take(3).map((product) {
                return GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang chi tiết sản phẩm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          // name: product.name,
                          // priceProduct: Helper.formatCurrency(
                          //     product.priceProduct), // Sửa đúng tên biến
                          // oldPrice: Helper.formatCurrency(
                          //     product.oldPrice), // Sửa đúng tên biến
                          // salePercent: product.salePercent,
                          rateProduct:
                              "0.0", // Giữ nguyên hoặc cập nhật nếu có rating
                          // isSale: product.isSale,
                          // idProduct: product.id,
                          // imageUrl: product.imageUrl,
                          // price: product.priceProduct, 
                          // imageList: product.imageGallery,// Sửa đúng tên biến
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
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
