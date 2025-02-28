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
              children: brand.productImages.take(3).map((imgUrl) {
                return GestureDetector(
                  onTap: () {
                    // 📌 NƠI THÊM CHỨC NĂNG CHUYỂN TRANG CHI TIẾT SẢN PHẨM
                    print('Nhấn vào sản phẩm với hình ảnh: $imgUrl');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imgUrl,
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
