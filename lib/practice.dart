import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  bool isButtonPressed = false;
  int select = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isButtonPressed ? Colors.green : Colors.red,
        title: Text(
            isButtonPressed == true ? 'Button Pressed' : 'Button Not Pressed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isButtonPressed = !isButtonPressed;
                });
              },
              child: Text('Press Me'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    isButtonPressed ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            select = value;
          });
        },
        currentIndex: select,
        backgroundColor: isButtonPressed ? Colors.green : Colors.red,
        fixedColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
      ),
    );
  }
}
