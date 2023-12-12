import 'package:flutter/material.dart';

import 'RegisterScreen.dart';

class UserTypeScreenDemo extends StatefulWidget {
  const UserTypeScreenDemo({Key? key}) : super(key: key);

  @override
  State<UserTypeScreenDemo> createState() => _UserTypeScreenDemoState();
}

class _UserTypeScreenDemoState extends State<UserTypeScreenDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterScreenDemo(UserType: "Seller"),
                  ),
                );
              },
              color: Colors.brown,
              child: Text(
                "Seller",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreenDemo(UserType: "Buyer"),
                  ),
                );
              },
              color: Colors.brown,
              child: Text(
                "Buyer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
