import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'BottomNavBar.dart';
import 'LoginScreen.dart';

class RegisterScreenDemo extends StatefulWidget {
  const RegisterScreenDemo({Key? key, this.UserType}) : super(key: key);
  final UserType;

  @override
  State<RegisterScreenDemo> createState() => _RegisterScreenDemoState();
}

class _RegisterScreenDemoState extends State<RegisterScreenDemo> {
  ImagePicker imagePicker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? image;

  CollectionReference user = FirebaseFirestore.instance.collection("User");

  FirebaseAuth auth = FirebaseAuth.instance;

  final box = GetStorage();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController firstnamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: GestureDetector(
                onTap: () async {
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  image = File(file!.path);
                  setState(() {});

                  print('PATH ${file.path}');
                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: image != null
                      ? Image.file(
                          image!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: firstnamecontroller,
              decoration: InputDecoration(
                hintText: "Firstname",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: lastnamecontroller,
              decoration: InputDecoration(
                hintText: "Lastname",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: "Email",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: passcontroller,
              decoration: InputDecoration(
                hintText: "Password",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () async {
                UserCredential credential =
                    await auth.createUserWithEmailAndPassword(
                        email: emailcontroller.text,
                        password: passcontroller.text);

                box.write("uid", credential.user!.uid);
                box.write("UserType", widget.UserType);
                box.write("Email", emailcontroller.text);

                storage
                    .ref("profile/${box.read("uid")}.png")
                    .putFile(image!)
                    .then(
                  (uploadedImage) async {
                    String url = await uploadedImage.ref.getDownloadURL();

                    print("URL $url");

                    await user.doc(credential.user!.uid).set(
                      {
                        "Firstname": firstnamecontroller.text,
                        "Lastname": lastnamecontroller.text,
                        "Email": emailcontroller.text,
                        "Password": passcontroller.text,
                        "UserType": widget.UserType,
                        "profile": url,
                      },
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BottomNavBraDemo(Type: "${credential.user!.uid}"),
                      ),
                    );
                  },
                );
              },
              color: Colors.brown,
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(
                  width: 3,
                ),
                InkResponse(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreenDemo(
                          UserType: "${widget.UserType}",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
