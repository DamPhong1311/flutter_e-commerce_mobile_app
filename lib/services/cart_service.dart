import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart({
    required String userId,
    required String productId,
    required String name,
    required int price,
    required String imageUrl,
  }) async {
    final cartRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId);
    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      cartRef.update({
        'quantity': FieldValue.increment(1),
        'total': FieldValue.increment(price),
      });
    } else {
      cartRef.set({
        'id': productId,
        'name': name,
        'price': price,
        'quantity': 1,
        'imageUrl': imageUrl,
        'total': price,
      });
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng (giảm số lượng, nếu 1 thì xóa luôn)
  Future<void> removeFromCart(
      String userId, String productId, int price) async {
    final cartRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId);
    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      int currentQuantity = cartDoc['quantity'];
      int currentTotal = cartDoc['total'];

      if (currentQuantity > 1) {
        // Đảm bảo total không âm
        int newTotal = (currentTotal - price) > 0 ? (currentTotal - price) : 0;

        cartRef.update({
          'quantity': FieldValue.increment(-1),
          'total': newTotal, // Sử dụng giá trị tính toán
        });
      } else {
        cartRef.delete();
      }
    }
  }

  // Xóa toàn bộ giỏ hàng
  Future<void> clearCart(String userId) async {
    final cartRef =
        _firestore.collection('users').doc(userId).collection('cart');
    final cartItems = await cartRef.get();

    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  Stream<List<CartItem>> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList());
  }
}
