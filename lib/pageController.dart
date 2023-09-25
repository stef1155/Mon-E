import 'package:flutter/material.dart';
import 'package:mon_e/home_page.dart';
import 'package:mon_e/report.dart';
import 'package:mon_e/profile.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    Report(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 225, 71, 97),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(label: 'Menu', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: 'Reports', icon: Icon(Icons.bar_chart)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
