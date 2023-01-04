import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3_web_app/presentation/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const GetMaterialApp(title: 'Cool ass DApp', home: Home());
}
