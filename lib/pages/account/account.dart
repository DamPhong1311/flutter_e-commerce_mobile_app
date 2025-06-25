import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/pages/account/change_password.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../services/theme_provider_service.dart';
import 'CheckOrderd.dart';
import 'about_us_page.dart';

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
        title: Text("Your_Account".tr()),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar Người Dùng
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child:
                      const Icon(Icons.person, size: 50, color: Colors.white),
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
                        buildInfoRow("Your_Id".tr(), id, Icons.person),
                        KSizedBox.smallHeightSpace,
                        KSizedBox.smallHeightSpace,
                        buildInfoRow("Your_Name".tr(), name, Icons.person),
                        KSizedBox.smallHeightSpace,
                        KSizedBox.smallHeightSpace,
                        buildInfoRow("Your_Email".tr(), email, Icons.email),
                      ],
                    ),
                  ),
                ),

                KSizedBox.smallHeightSpace,
                KSizedBox.smallHeightSpace,

                // Nút đổi mật khẩu
                NavButtonAccountPage(
                    context: context,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangePasswordPage()));
                    },
                    text: "Change_Your_Password".tr()),
                KSizedBox.smallHeightSpace,

                NavButtonAccountPage(
                    context: context,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => OrderListPage()));
                    },
                    text: "Ordered".tr()),
                NavButtonAccountPage(
                    context: context,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AboutUsPage()));
                    },
                    text: "About_Us".tr()),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Log_Out'.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                KSizedBox.smallHeightSpace,
                KSizedBox.smallHeightSpace,

                // 🌍 Nút Đổi Ngôn Ngữ
                IconButton(
                  icon: const Icon(Icons.language,
                      size: 30, color: Colors.blueAccent),
                  onPressed: () {
                    _toggleLanguage(context);
                  },
                ),
                Text(
                  "Switch_Language".tr(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleLanguage(BuildContext context) {
    Locale currentLocale = context.locale;

    if (currentLocale.languageCode == 'en') {
      context.setLocale(const Locale('vi')); // Chuyển sang Tiếng Việt
    } else {
      context.setLocale(const Locale('en')); // Chuyển sang Tiếng Anh
    }
  }

  Column NavButtonAccountPage(
      {required BuildContext context,
      required VoidCallback onPressed,
      required String text}) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Align(
            alignment: Alignment.centerLeft, //test
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? KColors.dartModeColor
              : const Color.fromARGB(132, 0, 0, 0),
        ),
      ],
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        KSizedBox.smallWidthSpace,
        KSizedBox.smallWidthSpace,
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
