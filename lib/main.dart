import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/homepage.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 3, 73, 138)),
        useMaterial3: true,
      ),
      home: const homepage(),
    );
  }
}