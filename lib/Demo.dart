import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DemoData extends StatefulWidget {
  const DemoData({Key? key}) : super(key: key);

  @override
  State<DemoData> createState() => _DemoDataState();
}

class _DemoDataState extends State<DemoData> {
  var user = FirebaseFirestore.instance.collection("User");

  bool loading = false;
  List<Map<String, dynamic>> users = [];

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    var data = await user.get();

    for (var doc in data.docs) {
      users.add(doc.data());
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: List.generate(
                  users.length, (index) => Text('${users[index]['Email']}')),
            ),
    );
  }
}
