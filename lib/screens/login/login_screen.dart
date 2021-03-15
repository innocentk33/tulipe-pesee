import 'package:fish_scan/screens/home/home_screen.dart';
import 'package:fish_scan/screens/login/login_controller.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());

  TextEditingController loginCtrl;
  TextEditingController passwordCtrl;

  @override
  void initState() {
    loginCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: loginCtrl,
              decoration: InputDecoration(labelText: "Identifiant"),
            ),
            VSpacer.normal,
            TextField(
              controller: passwordCtrl,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            VSpacer.large,
            Button("Connexion", onPressed: () => _submitLogin())
          ],
        ),
      ),
    );
  }

  _submitLogin() async {
    showLoadingDialog(context, message: "Connexion");

    var login = loginCtrl.text.trim();
    var password = passwordCtrl.text.trim();
    var response = await controller.login(
        login: login, password: password);

    Get.back();

    if (response.hasError) {
      showInfoDialog(context, message: response.message);
      return;
    }
    Get.offAll(HomeScreen());
  }
}
