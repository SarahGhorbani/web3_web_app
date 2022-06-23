import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niku/niku.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "cool web3 app",
      home: Home(),
    );
  }
}
class HomeController extends GetxController{}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h)=> Scaffold(
        body: Center(
          child: Niku(),
        ),
      ),
    );
  }

}
