class Brand {
  final String brandName;
  final String brandLogo;
  final int productCount;
  final List<String> productImages;

  Brand({
    required this.brandName,
    required this.brandLogo,
    required this.productCount,
    required this.productImages,
  });

  // Hàm tạo đối tượng Brand từ dữ liệu Firestore
  factory Brand.fromFirestore(Map<String, dynamic> data) {
    return Brand(
      brandName: data['store'] ?? 'No Name',
      brandLogo: data['imageUrl'] ?? '',
      productCount: 1,
      productImages: List<String>.from(data['imageGallery'] ?? []),
    );
  }
}
