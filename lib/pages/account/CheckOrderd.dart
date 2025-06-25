import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/product.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({Key? key}) : super(key: key);

  String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    String userId = getUserId();

    void _cancelOrder(
        BuildContext context, String userId, String orderId) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm_CheckOdered'.tr()),
          content: Text('Ask_Confirm'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'.tr()),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('ordered')
            .doc(orderId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Order_Canceled'.tr())),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order_Placed'.tr()),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('ordered')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No_Order'.tr()));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final data = order.data() as Map<String, dynamic>;

                final productMap = data['product'] as Map<String, dynamic>;
                final product =
                    Product.fromMap(productMap, productMap['id'] ?? '');

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              product.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '🛒 ${product.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(' Price: ${product.priceProduct} VNĐ'),
                        Text(' Sale: ${product.salePercent}'),
                        const SizedBox(height: 5),
                        Text(' Status: ${data['status']}'),
                        const SizedBox(height: 5),
                        Text(
                            ' Payment Method: ${data['paymentMethod']}'),
                        const SizedBox(height: 5),
                        Text(' Total Price: ${data['totalPrice'] ?? 0} VNĐ'),
                        const SizedBox(height: 5),
                        if (data['address'] != null)
                          Text(
                            ' Address: ${data['address']['detail'] ?? ''}, ${data['address']['ward'] ?? ''}, ${data['address']['district'] ?? ''}, ${data['address']['province'] ?? ''}',
                          ),
                        const SizedBox(height: 5),
                        if (data['createdAt'] != null)
                          Text(' Date: ${data['createdAt'].toDate()}'),
                        TextButton(
                          onPressed: () =>
                              _cancelOrder(context, userId, order.id),
                          child: Center(
                            child: Text(
                              'Cancel_order'.tr(),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
