class Brand {
  final String brandName;
  final String brandLogo; // Đường dẫn asset/logo
  final int productCount;
  final List<String> productImages;

  Brand({
    required this.brandName,
    required this.brandLogo,
    required this.productCount,
    required this.productImages,
  });
}

// Danh sách mẫu
final List<Brand> brandList = [
  Brand(
    brandName: 'LapTop',
    brandLogo: 'assets/images/products/laptop.jpg',
    productCount: 265,
    productImages: [
      'assets/images/products/laptop.jpg',
      'assets/images/products/laptop.jpg',
      'assets/images/products/laptop.jpg',
    ],
  ),
  Brand(
    brandName: 'Phone',
    brandLogo: 'assets/images/products/laptop.jpg',
    productCount: 95,
    productImages: [
      'assets/images/products/laptop.jpg',
      'assets/images/products/laptop.jpg',
      'assets/images/products/laptop.jpg',
    ],
  ),
];
