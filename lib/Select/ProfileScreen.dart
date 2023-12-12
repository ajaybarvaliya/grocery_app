import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'LoginScreen.dart';
import 'UserTypeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final box = GetStorage();

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker imagePicker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? image;

  TextEditingController ftname = TextEditingController();
  TextEditingController lstname = TextEditingController();
  TextEditingController gmail = TextEditingController();
  TextEditingController Usertype = TextEditingController();

  int select = 0;

  var user = FirebaseFirestore.instance.collection('User');

  bool loading = false;

  Map<String, dynamic>? users;

  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    var data = await user.doc(box.read("uid")).get();

    users = data.data() as Map<String, dynamic>;

    ftname = TextEditingController(text: data["Firstname"]);
    lstname = TextEditingController(text: data["Lastname"]);
    gmail = TextEditingController(text: data["Email"]);
    Usertype = TextEditingController(text: data["UserType"]);

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
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue, Colors.black, Colors.indigo],
            ),
          ),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: users!["profile"] == null && image == null
                              ? Icon(
                                  (Icons.person),
                                )
                              : image == null
                                  ? Image.network(
                                      users!["profile"],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          image = File(file!.path);
                          setState(() {});

                          print('PATH ${file.path}');
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.camera_alt, size: 20),
                        ),
                      )
                    ],
                  ),
                  TextField(
                    controller: ftname,
                    decoration: InputDecoration(
                      hintText: "Firstname",
                      constraints: BoxConstraints(maxWidth: 300),
                    ),
                  ),
                  TextField(
                    controller: lstname,
                    decoration: InputDecoration(
                      hintText: "Lasttname",
                      constraints: BoxConstraints(maxWidth: 300),
                    ),
                  ),
                  TextField(
                    controller: gmail,
                    decoration: InputDecoration(
                      hintText: "Email",
                      constraints: BoxConstraints(maxWidth: 300),
                    ),
                  ),
                  TextField(
                    controller: Usertype,
                    decoration: InputDecoration(
                      hintText: "UserType",
                      constraints: BoxConstraints(maxWidth: 300),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      storage
                          .ref("profile/${box.read("uid")}.png")
                          .putFile(image!)
                          .then(
                        (uploadedImage) async {
                          String url = await uploadedImage.ref.getDownloadURL();

                          print("URL $url");

                          user.doc(box.read("uid")).update(
                            {
                              "Firstname": ftname.text,
                              "Lastname": lstname.text,
                              "Email": gmail.text,
                              "UserType": Usertype.text,
                              "profile": url,
                            },
                          );
                        },
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Succesfully data updated"),
                        ),
                      );
                    },
                    child: Text('update'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await box.erase();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTypeScreenDemo(),
                        ),
                      );
                    },
                    child: Text('Logout'),
                  ),
                  // Text("Firstname :${users!["Firstname"]}"),
                  // Text("Lastname :${users!["Lastname"]}"),
                  // Text("Email :${users!["Email"]}"),
                  // Text("UserType :${users!["UserType"]}"),
                ],
              ),
            ),
    );
  }
}
