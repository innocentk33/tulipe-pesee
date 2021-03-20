import 'package:fish_scan/constants/status_commande_constants.dart';
import 'package:fish_scan/screens/global_controller.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_pesee_manuelle_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_screen.dart';
import 'package:fish_scan/screens/vente_dashboard/vente_dashboard_button.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/navigation_menu.dart';
import '../../constants/navigation_menu.dart';

class VenteDashboardScreen extends StatefulWidget {
  @override
  _VenteDashboardScreeState createState() => _VenteDashboardScreeState();
}

class _VenteDashboardScreeState extends State<VenteDashboardScreen> {
  final globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Pesée'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VenteDashboardButton(
              text: "Demande de préparation",
              onPressed: () => goToDemandePreparation(),
              codeTraitement: 1,
            ),
            VenteDashboardButton(
              text: "En cours  de préparation",
              onPressed: () => goToEnCoursPreparation(),
              codeTraitement: 2,
            ),
            VenteDashboardButton(
              text: "En confirmation",
              onPressed: () => goToConfirmation(),
              codeTraitement: 3,
            )
          ],
        ),
      ),
    );
  }

  Future goToDemandePreparation() {
    return Get.to(globalController.menu == NavigationMenu.VENTE
        ? ListeCommandeScreen(menu: NavigationMenu.VENTE_DEMANDE_PREPARATION)
        : ListeCommandePeseeManuelleScreen(
            menu: NavigationMenu.VENTE_DEMANDE_PREPARATION));
  }

  Future goToConfirmation() {
    return Get.to(
      ListeCommandeScreen(
        menu: NavigationMenu.VENTE_CONFIRMATION,
      ),
    );
  }

  Future goToEnCoursPreparation() {
    return Get.to(globalController.menu ==
            NavigationMenu.VENTE_EN_COURS_PREPARATION
        ? ListeCommandeScreen(menu: NavigationMenu.VENTE_EN_COURS_PREPARATION)
        : ListeCommandePeseeManuelleScreen(
            menu: NavigationMenu.VENTE_EN_COURS_PREPARATION));
  }
}
