import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerece_flutter_app/models/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lưu địa chỉ
  Future<void> saveAddress(String userId, Address address) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(address.toMap());
    }
  }

  // Lấy danh sách địa chỉ
  Future<List<Address>> getAddresses() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();
      return snapshot.docs.map((doc) => Address.fromMap(doc.data())).toList();
    }
    return [];
  }

  // Xóa địa chỉ
  Future<void> removeAddress(String id) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .delete();
    }
  }
}
