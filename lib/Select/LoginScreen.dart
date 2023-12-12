import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'BottomNavBar.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreenDemo extends StatefulWidget {
  const LoginScreenDemo({Key? key, this.UserType}) : super(key: key);
  final UserType;

  @override
  State<LoginScreenDemo> createState() => _LoginScreenDemoState();
}

class _LoginScreenDemoState extends State<LoginScreenDemo> {
  CollectionReference user = FirebaseFirestore.instance.collection("User");

  FirebaseAuth auth = FirebaseAuth.instance;

  final box = GetStorage();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailcontroller,
              keyboardType: TextInputType.emailAddress,
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
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: "Password",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                UserCredential credential =
                    await auth.signInWithEmailAndPassword(
                        email: emailcontroller.text,
                        password: passcontroller.text);

                box.write("uid", "${credential.user!.uid}");
                box.write("UserType", widget.UserType);
                box.write("Email", emailcontroller.text);

                var data = await user.doc(credential.user!.uid).get();

                Map<String, dynamic> data1 =
                    data.data() as Map<String, dynamic>;
                if (data1["UserType"] == widget.UserType) {
                  box.write("uid", credential.user!.uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavBraDemo(Type: "${credential.user!.uid}"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select same UserType"),
                    ),
                  );
                }
              },
              color: Colors.brown,
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                SizedBox(
                  width: 5,
                ),
                InkResponse(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegisterScreenDemo(UserType: "${widget.UserType}"),
                      ),
                    );
                  },
                  child: Text("register", style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
