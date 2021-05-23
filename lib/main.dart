import 'package:fish_scan/screens/depotage/depotage_screen.dart';
import 'package:fish_scan/screens/home/home_screen.dart';
import 'package:fish_scan/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tulipe',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0XFF2e7940),visualDensity: VisualDensity.adaptivePlatformDensity,),
      //theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: SplashScreen(),
    );
  }
}