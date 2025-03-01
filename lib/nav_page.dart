import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/pages/store/store.dart';
import 'package:flutter/material.dart';

import 'pages/account/account.dart';
import 'pages/home/home_page.dart';

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
    pages = [
      HomePage(scrollController: _scrollController,),
      StoreScreen(scrollController: _scrollController,),
      Container(
        color: Colors.green,
      ),
      AccountPage()
    ];
  }

  void _scrollToTop() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
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
                label: 'Home',
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Store',
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
                backgroundColor: Colors.transparent)
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
