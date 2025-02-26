import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(String userId, String productId, String name, int price, String imageUrl) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart').doc(productId);
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
  Future<void> removeFromCart(String userId, String productId, int price) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart').doc(productId);
    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      int currentQuantity = cartDoc['quantity'];
      if (currentQuantity > 1) {
        cartRef.update({
          'quantity': FieldValue.increment(-1),
          'total': FieldValue.increment(-price),
        });
      } else {
        cartRef.delete();
      }
    }
  }

  // Xóa toàn bộ giỏ hàng
  Future<void> clearCart(String userId) async {
    final cartRef = _firestore.collection('users').doc(userId).collection('cart');
    final cartItems = await cartRef.get();

    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  Stream<List<Map<String, dynamic>>> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
