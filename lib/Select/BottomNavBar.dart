import 'package:flutter/material.dart';

import 'CartScreen.dart';
import 'HomeScreen.dart';
import 'LikeScreen.dart';
import 'ProfileScreen.dart';

class BottomNavBraDemo extends StatefulWidget {
  const BottomNavBraDemo({
    Key? key,
    this.Type,
  }) : super(key: key);
  final Type;

  @override
  State<BottomNavBraDemo> createState() => _BottomNavBraDemoState();
}

class _BottomNavBraDemoState extends State<BottomNavBraDemo> {
  List<Widget>? screen;

  @override
  void initState() {
    screen = box.read("UserType") == "Seller"
        ? [
            HomeScreenDemo(),
            ProfileScreen(),
          ]
        : [
            HomeScreenDemo(),
            Likescreen(),
            CartScreen(),
            ProfileScreen(),
          ];
    // TODO: implement initState
    super.initState();
  }

  int select = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {});
          select = value;
        },
        currentIndex: select,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: box.read("UserType") == "Seller"
            ? [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "",
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "",
                ),
              ],
      ),
      body: screen![select],
    );
  }
}
