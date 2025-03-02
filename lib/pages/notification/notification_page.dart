import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/cart_button.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../cart/cart_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: WAppBar(
              title: Text('Notification'),
              actions: [
                WCartButton.cartButton(
                    context: context,
                    color: Helper.isDarkMode(context)
                        ? Colors.white
                        : Colors.black)
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<List<NotificationModel>>(
              stream: NotificationService.getUserNotifications(
                  AuthService().getUserId()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No notifications yet."));
                }

                List<NotificationModel> notifications = snapshot.data!;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.grey.withValues(alpha: 0.3),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            notifications[index].message,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        subtitle: Text(
                          notifications[index].timestamp.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
