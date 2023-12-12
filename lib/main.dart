import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groceryapp/practice.dart';
import 'Demo.dart';
import 'FruitList.dart';
import 'Select/AddProducts.dart';
import 'Select/LoginScreen.dart';
import 'Select/RegisterScreen.dart';

import 'Select/SplashScreen.dart';
import 'Select/UserTypeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Practice(),
    );
  }
}
