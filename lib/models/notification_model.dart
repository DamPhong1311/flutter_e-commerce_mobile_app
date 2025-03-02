import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id; // ID của thông báo (Firestore document ID)
  final String message; // Nội dung thông báo
  final DateTime timestamp; // Thời gian gửi thông báo

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
  });

  // Chuyển từ Firestore DocumentSnapshot thành NotificationModel
  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return NotificationModel(
      id: docId,
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Chuyển NotificationModel thành Map để lưu Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'timestamp': timestamp,
    };
  }
}
