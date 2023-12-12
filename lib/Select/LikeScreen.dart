import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Likescreen extends StatefulWidget {
  const Likescreen({Key? key}) : super(key: key);

  @override
  State<Likescreen> createState() => _LikescreenState();
}

class _LikescreenState extends State<Likescreen> {
  @override
  final box = GetStorage();

  List<Map<String, dynamic>> users = [];

  var user = FirebaseFirestore.instance.collection("Products");

  bool loading = false;

  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    var data = await user
        .where(
          "Likedby",
          arrayContains: box.read("uid"),
        )
        .get();

    for (var doc in data.docs) {
      var data2 = doc.data();

      var product = {
        "productId": doc.id,
        "Likedby": data2["Likedby"],
        "Addcart": data2["Addcart"],
        "UserId": "${data2['UserId']}",
        "Description": "${data2["Description"]}",
        "Price": "${data2["Price"]}",
        "Name": "${data2["Name"]}",
        "Rating": "${data2["Rating"]}",
      };

      if (box.read("UserType") == "Seller") {
        if (product["UserId"] == box.read("uid")) {
          users.add(product);
        }
      } else {
        users.add(product);
      }

      print("jjjjjjjjjjjjjjjjjjjjjjjjjj     ${product["UserId"]}");
      print("jjjjjjjjjjjjjjjjjjjjjjjjjj     ${product["productId"]}");
      print("jjjjjjjjjjjjjjjjjjjjjjjjjj     ${box.read("Email")}");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: 800,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GridView.builder(
                  itemCount: users.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blue..withOpacity(0.5),
                      child: Column(
                        children: [
                          Text('Name :${users[index]['Name']}'),
                          Text('Price :${users[index]['Price']}'),
                          Text('Rating :${users[index]['Rating']}'),
                          Text('Description :${users[index]['Description']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
