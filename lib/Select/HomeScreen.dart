import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'AddProducts.dart';
import 'UpdateProducts.dart';

class HomeScreenDemo extends StatefulWidget {
  const HomeScreenDemo({Key? key}) : super(key: key);

  @override
  State<HomeScreenDemo> createState() => _HomeScreenDemoState();
}

class _HomeScreenDemoState extends State<HomeScreenDemo> {
  var user = FirebaseFirestore.instance.collection("Products");

  final box = GetStorage();

  bool loading = false;
  List<Map<String, dynamic>> users = [];

  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    var data = await user.get();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read("UserType") == "Seller"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductsDemo(),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : SizedBox(),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  box.read("UserType") == "Seller"
                      ? Text(
                          "My Products",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 660,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        itemCount: users.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7),
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.blue.withOpacity(0.5),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  box.read("UserType") == "Seller"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 130),
                                          child: PopupMenuButton(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 1,
                                                child: Text("delete"),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                child: Text("update"),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              value == 1
                                                  ? user
                                                      .doc(
                                                          "${users[index]["productId"]}")
                                                      .delete()
                                                  : SizedBox();

                                              value == 2
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateProducts(
                                                          products:
                                                              users[index],
                                                          productid:
                                                              users[index]
                                                                  ["productId"],
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox();

                                              setState(() {});
                                            },
                                          ))
                                      : SizedBox(height: 20),
                                  Text('Name :${users[index]['Name']}'),
                                  Text('Price :${users[index]['Price']}'),
                                  Text('Rating :${users[index]['Rating']}'),
                                  Text(
                                      'Description :${users[index]['Description']}'),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        box.read("UserType") == "Buyer"
                                            ? Likes(
                                                productid: users[index]
                                                    ["productId"],
                                                Likeduser: users[index]
                                                        ["Likedby"] ??
                                                    [],
                                              )
                                            : SizedBox(),
                                        Spacer(),
                                        box.read("UserType") == "Buyer"
                                            ? Cart(
                                                productid: users[index]
                                                    ["productId"],
                                                cartuser: users[index]
                                                        ["Addcart"] ??
                                                    [],
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class Likes extends StatefulWidget {
  const Likes({
    super.key,
    required this.productid,
    this.Likeduser,
  });
  final productid;
  final Likeduser;

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  bool like = false;

  @override
  Widget build(BuildContext context) {
    var user = FirebaseFirestore.instance.collection("Products");

    final box = GetStorage();

    return InkWell(
      onTap: () async {
        if (widget.Likeduser.contains(box.read("uid"))) {
          widget.Likeduser.remove(box.read("uid"));
          setState(() {});
        } else {
          widget.Likeduser.add(box.read("uid"));
          setState(() {});
        }

        user.doc(widget.productid).update({"Likedby": widget.Likeduser});
      },
      child: widget.Likeduser.contains(box.read("uid"))
          ? Icon(Icons.favorite, color: Colors.red)
          : Icon(
              Icons.favorite_outline,
            ),
    );
  }
}

class Cart extends StatefulWidget {
  const Cart({Key? key, this.productid, this.cartuser}) : super(key: key);
  final productid;
  final cartuser;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool cart = false;
  @override
  Widget build(BuildContext context) {
    var user = FirebaseFirestore.instance.collection("Products");

    final box = GetStorage();

    return InkWell(
      onTap: () {
        if (widget.cartuser.contains(box.read("uid"))) {
          widget.cartuser.remove(box.read("uid"));
          setState(() {});
        } else {
          widget.cartuser.add(box.read("uid"));
          setState(() {});
        }

        user.doc(widget.productid).update({"Addcart": widget.cartuser});
      },
      child: widget.cartuser.contains(box.read("uid"))
          ? Icon(
              Icons.shopping_cart,
            )
          : Icon(
              Icons.shopping_cart_outlined,
            ),
    );
  }
}
