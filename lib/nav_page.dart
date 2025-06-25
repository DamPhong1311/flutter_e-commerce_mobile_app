import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/pages/store/store.dart';
import 'package:flutter/material.dart';

import 'pages/account/account.dart';
import 'pages/chatbot/chatbot_page_yt.dart';
import 'pages/home/home_page.dart';
import 'pages/notification/notification_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentPage = 0;

  List<Widget> pages = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    pages = [HomePage(), StoreScreen(), ChatPage(), NotificationPage(), AccountPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.primaryColor,
      body: pages.elementAt(_currentPage),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: KColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPage,
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'.tr(),
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Store'.tr(),
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'ChatBot',
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification'.tr(),
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account'.tr(),
                backgroundColor: Colors.transparent)
          ]),
    );
  }
}
