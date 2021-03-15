import 'package:fish_scan/screens/login/login_screen.dart';
import 'package:fish_scan/screens/settings/settings_controller.dart';
import 'package:fish_scan/screens/splash/splash_screen.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const SettingsScreen({Key key, this.isFirstLaunch = false}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController serveurCtrl;
  TextEditingController portCtrl;
  TextEditingController instanceCtrl;
  TextEditingController societeCtrl;

  SettingsController controller = Get.put(SettingsController());

  @override
  void initState() {
    serveurCtrl = TextEditingController(text: "http://52.157.86.58");
    portCtrl = TextEditingController(text: "7047");
    instanceCtrl = TextEditingController(text: "BC170");
    societeCtrl = TextEditingController(text: "TULIPE");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: serveurCtrl,
              decoration: InputDecoration(labelText: "Serveur"),
            ),
            VSpacer.normal,
            TextField(
              controller: portCtrl,
              decoration: InputDecoration(labelText: "Port"),
            ),
            VSpacer.normal,
            TextField(
              controller: instanceCtrl,
              decoration: InputDecoration(labelText: "Instance"),
            ),
            VSpacer.normal,
            TextField(
              controller: societeCtrl,
              decoration: InputDecoration(labelText: "Société"),
            ),
            VSpacer.large,
            Button("Valider", onPressed: () {
              if (checkForm()) _saveSettings();
            })
          ],
        ),
      ),
    );
  }

  bool checkForm() {
    if (serveurCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le serveur est obligatoire.");
      return false;
    }

    if (portCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le port est obligatoire.");
      return false;
    }

    if (instanceCtrl.text.isEmpty) {
      showInfoDialog(context, message: "L'instance est obligatoire.");
      return false;
    }

    if (societeCtrl.text.isEmpty) {
      showInfoDialog(context, message: "La société est obligatoire.");
      return false;
    }
    return true;
  }

  _saveSettings() async {
    bool saved = await controller.saveSettings(
        serveur: serveurCtrl.text.trim(),
        port: portCtrl.text.trim(),
        instance: instanceCtrl.text.trim(),
        societe: societeCtrl.text.trim());
    if (saved) {
      showInfoDialog(context, message: "Paramètres enregistrés",
          positiveAction: () {
        if (widget.isFirstLaunch) {
          Get.offAll(LoginScreen());
          return;
        }
        Get.back();
      });
    }
  }

  void _updateSettings() async {
    var parametre = await controller.getParametre();
    if (parametre != null) {
      setState(() {
        serveurCtrl.text = parametre.serveur;
        portCtrl.text = parametre.port;
        instanceCtrl.text = parametre.instance;
        societeCtrl.text = parametre.societe;
      });
    }
  }
}
