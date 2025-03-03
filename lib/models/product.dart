class Product {
  final String id;
  final String category;
  final String description;
  final String imageUrl;
  final List<String> imageGallery;
  final bool isSale;
  final String name;
  final int oldPrice;
  final int priceProduct;
  final String salePercent;
  final String store;

  Product( {
    required this.imageGallery,
    required this.isSale,
    required this.oldPrice,
    required this.priceProduct,
    required this.salePercent,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.store,
  });

  // Chuyển từ Firestore Map sang Object
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      imageGallery: List<String>.from(data['imageGallery'] ?? []),
      isSale: data['isSale'] ?? false,
      name: data['name'] ?? '',
      oldPrice: (data['oldPrice'] as num).toInt(),
      priceProduct: (data['priceProduct'] as num).toInt(),
      salePercent: data['salePercent'] ?? '',
      store: data['store'] ?? ''
    );
  }
}
