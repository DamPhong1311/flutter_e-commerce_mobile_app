import 'package:ecommerece_flutter_app/models/product.dart';

class Brand {
  final String brandName;
  final String brandLogo;
  final int productCount;
  final List<Product> products;

  Brand({
    required this.brandName,
    required this.brandLogo,
    required this.productCount,
    required this.products,
  });

  // Chuyển từ Firestore Map sang Object
  factory Brand.fromMap(Map<String, dynamic> data, List<Product> products) {
    return Brand(
      brandName: data['brandName'] ?? '',
      brandLogo: data['brandLogo'] ?? '',
      productCount: products.length, // Đếm số lượng sản phẩm thực tế
      products: products,
    );
  }
}
