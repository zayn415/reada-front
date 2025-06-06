import 'package:flutter/material.dart';
import 'package:reada/pages/community_page.dart';

import '../constants/colors.dart';
import '../pages/message_page.dart';
import '../pages/profile_page.dart';
import '../pages/shelf_page.dart';

// 页面底部导航栏
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const ShelfPage(),
    const CommunityPage(),
    const MessagePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '书架'),
          BottomNavigationBarItem(
            icon: Icon(Icons.commute_outlined),
            label: '社区',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: ColorConstants.primaryColor,
      ),
    );
  }
}
