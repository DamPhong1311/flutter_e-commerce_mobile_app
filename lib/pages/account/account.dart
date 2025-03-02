import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/pages/account/change_password.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/theme_provider_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = "Loading...";
  String email = "Loading...";
  String id = "Loading...";
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail =
            user.email ?? "No Email"; // Lấy email từ FirebaseAuth

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              name = userDoc.get('name') ?? "No Name";
              email = userEmail; // Email lấy từ FirebaseAuth
              id = userDoc.get('uid') ?? 'No Id';
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi khi lấy dữ liệu người dùng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Account"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar Người Dùng
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              KSizedBox.heightSpace,

              // Thông tin tài khoản
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildInfoRow("Your Id:", id, Icons.person),
                      KSizedBox.smallHeightSpace,
                      KSizedBox.smallHeightSpace,
                      buildInfoRow("Your Name:", name, Icons.person),
                      KSizedBox.smallHeightSpace,
                      KSizedBox.smallHeightSpace,
                      buildInfoRow("Your Email:", email, Icons.email),
                    ],
                  ),
                ),
              ),

              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,

              // Nút đổi mật khẩu
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(_) => ChangePasswordPage()));
                },
                child: const Text(
                  'Change Your Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent),
                ),
              ),

              KSizedBox.smallHeightSpace,
              KSizedBox.smallHeightSpace,
              // Nút đăng xuất
              ElevatedButton(
                onPressed: () async {
                  await AuthService().logout();
                  Helper.navigateAndReplace(context, const LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  // Widget để tạo hàng thông tin
  Widget buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Expanded(child: Icon(icon, color: Colors.blueAccent)),
        Expanded(
          flex: 3,
          child: Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
     
        KSizedBox.smallWidthSpace,
        KSizedBox.smallWidthSpace,
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
