import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'BottomNavBar.dart';

class AddProductsDemo extends StatefulWidget {
  const AddProductsDemo({Key? key}) : super(key: key);

  @override
  State<AddProductsDemo> createState() => _AddProductsDemoState();
}

class _AddProductsDemoState extends State<AddProductsDemo> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    CollectionReference users =
        FirebaseFirestore.instance.collection("Products");

    TextEditingController namecontroller = TextEditingController();
    TextEditingController pricecontroller = TextEditingController();
    TextEditingController descontroller = TextEditingController();
    TextEditingController ratcontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.black, Colors.blue],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(
                hintText: "Name",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: pricecontroller,
              decoration: InputDecoration(
                hintText: "Price",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: descontroller,
              decoration: InputDecoration(
                hintText: "Description",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: ratcontroller,
              decoration: InputDecoration(
                hintText: "Rating",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                await users.add(
                  {
                    "Likedby": [],
                    "Addcart": [],
                    "UserId": box.read("uid"),
                    "Name": namecontroller.text,
                    "Price": pricecontroller.text,
                    "Description": descontroller.text,
                    "Rating": ratcontroller.text,
                  },
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBraDemo(),
                  ),
                );
              },
              color: Colors.blue,
              child: Text("Add"),
            )
          ],
        ),
      ),
    );
  }
}
