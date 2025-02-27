class CartItem {
  final String id;
  final String name;
  final int price;
  final String imageUrl;

  final int quantity;
  final int total;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.total,
  });

  // Chuyển từ Map<String, dynamic> thành CartItem
  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      name: data['name'],
      price:  (data['price'] as num).toInt(),
      imageUrl: data['imageUrl'],
      quantity: data['quantity'],
      total:  (data['total'] as num).toInt(),
    );
  }

  // Chuyển từ CartItem thành Map<String, dynamic> (nếu cần lưu vào Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'total': total,
    };
  }
}
