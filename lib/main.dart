import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/homepage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAGAa_AuLpDCWjXyXm8_mPndgafkSF2Lsc',
      appId: '1:624837942326:android:50a88470d219ee5bc64c97',
      messagingSenderId: '624837942326',
      projectId: 'products-getx',
      storageBucket: 'products-getx.appspot.com',
    )
  );
    await Hive.initFlutter();
  await Hive.openBox('mybox');
  var box = Hive.box('myBox');
  FirebaseDatabase.instance.reference();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Getx assignment',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 3, 73, 138)),
        useMaterial3: true,
      ),
      home: const homepage(),
    );
  }
}
