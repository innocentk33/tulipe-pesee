import 'package:fish_scan/gen/assets.gen.dart';
import 'package:fish_scan/models/parametre.dart';
import 'package:fish_scan/screens/login/login_screen.dart';
import 'package:fish_scan/screens/settings/settings_screen.dart';
import 'package:fish_scan/screens/splash/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController controller = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _getUserLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                  child: Assets.images.logo.image(width: 183, height: 284)),
            ),
            Text(
              'Smart-Technologies',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              'Microsoft Dynamics Business Central',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _getUserLogin() async {
    Parametre parametre = await controller.getParametre();
    if (parametre == null) {
      Get.offAll(SettingsScreen(isFirstLaunch: true));
      return;
    }

    String login = await controller.getUserLogin();
    Get.offAll(login != null ? HomeScreen() : LoginScreen());
  }
}
