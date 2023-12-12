import 'package:flutter/material.dart';

class FruitList extends StatefulWidget {
  const FruitList({Key? key}) : super(key: key);

  @override
  State<FruitList> createState() => _FruitListState();
}

class _FruitListState extends State<FruitList> {
  List fruit = ["apple", "banana", "berry"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print(fruit.contains("chiku"));
          },
          child: Text("add"),
        ),
      ),
    );
  }
}
