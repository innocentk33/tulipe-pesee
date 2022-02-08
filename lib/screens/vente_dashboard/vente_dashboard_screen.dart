
import 'package:fish_scan/screens/global_controller.dart';
import 'package:fish_scan/screens/home/home_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_pesee_manuelle_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_screen.dart';
import 'package:fish_scan/screens/vente_dashboard/vente_dashboard_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: ()=>Get.to(HomeScreen()),
        ),

        actions: [


          GestureDetector(
            onTap: ((){

              Navigator.push(context,MaterialPageRoute(builder: (context)=>VenteDashboardScreen()));
            }
            ) ,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.refresh),
            ),
          ),


        ],
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
              text: "En cours de préparation",
              onPressed: () => goToEnCoursPreparation(),
              codeTraitement: 2,
            ),
            VenteDashboardButton(
              text: "En confirmation",
              onPressed: () => goToConfirmation(),
              codeTraitement: 3,
            )  ,
            VenteDashboardButton(
              text: "Commande modifier",
              onPressed: () => goToEnModification(),
              codeTraitement: 5,
            ),
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

/*  Future goToCommandeModifier (){
    return Get.to(CommandesModifierScreen(menu: NavigationMenu.VENTE_MODIFICATION)) ;
  }*/

  Future goToEnCoursPreparation() {
    return Get.to(globalController.menu == NavigationMenu.VENTE_EN_COURS_PREPARATION
        ? ListeCommandeScreen(menu: NavigationMenu.VENTE_EN_COURS_PREPARATION)
        : ListeCommandePeseeManuelleScreen(
            menu: NavigationMenu.VENTE_EN_COURS_PREPARATION));
  }
  Future goToEnModification() {
    return Get.to(globalController.menu == NavigationMenu.VENTE_EN_COURS_PREPARATION
        ? ListeCommandeScreen(menu: NavigationMenu.VENTE_EN_COURS_PREPARATION)
        : ListeCommandePeseeManuelleScreen(
            menu: NavigationMenu.VENTE_MODIFICATION));
  }

  refreshDashboard() {
   return Get.off(VenteDashboardScreen());
  }
}
