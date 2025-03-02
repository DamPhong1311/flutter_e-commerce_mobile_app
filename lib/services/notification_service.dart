import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';


class NotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm thông báo vào Firestore
  static Future<void> addNotification(String userId, String message) async {
    final notification = NotificationModel(
      id: '',
      message: message,
      timestamp: DateTime.now(),
    );

    await _db.collection('users').doc(userId).collection('notifications').add(notification.toFirestore());
  }

  // Lấy danh sách thông báo của user theo stream
  static Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc.data(), doc.id)).toList());
  }
}
