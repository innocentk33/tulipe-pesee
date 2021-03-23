import 'package:fish_scan/gen/assets.gen.dart';
import 'package:fish_scan/screens/global_controller.dart';
import 'package:fish_scan/screens/home/home_controller.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_screen.dart';
import 'package:fish_scan/screens/login/login_screen.dart';
import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/screens/settings/settings_screen.dart';
import 'package:fish_scan/screens/vente_dashboard/vente_dashboard_screen.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/button/menu_button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  GlobalController globalController = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();
    controller.getLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Assets.images.user.image(width: 50, height: 50),
                        HSpacer.normal,
                        Obx(() => RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: "Bienvenue, ",
                                    ),
                                    TextSpan(
                                        text: controller.login,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                            ))
                      ],
                    ),
                    VSpacer.large,
                    MenuButton("Pesée manuelle",
                        prefix: Assets.images.box.image(width: 30, height: 30),
                        onPressed: () {
                      globalController.menu = NavigationMenu.VENTE_MANUELLE;
                      Get.to(VenteDashboardScreen());
                    }),
              /*      MenuButton("Code à barre",
                        prefix: Assets.images.box.image(width: 30, height: 30),
                        onPressed: () {
                      globalController.menu = NavigationMenu.VENTE;
                      Get.to(VenteDashboardScreen());
                    }),
                    MenuButton(
                      "Depotage",
                      prefix: Assets.images.cargo.image(width: 30, height: 30),
                      onPressed: () => Get.to(
                        ListeCommandeScreen(menu: NavigationMenu.DEPOTAGE),
                      ),
                    ),
                    MenuButton("Contrôle",
                        prefix:
                            Assets.images.verify.image(width: 30, height: 30),
                        onPressed: () {}),
                    MenuButton(
                      "Inventaire",
                      prefix:
                          Assets.images.inventory.image(width: 30, height: 30),
                      onPressed: () => Get.to(
                        ListeArticleCommandeScreen(
                          menu: NavigationMenu.DEPOTAGE_RAPIDE,
                        ),
                      ),
                    ),*/


                  ],
                ),
              ),
              MenuButton("Paramètre",
                  prefix:
                  Assets.images.settings.image(width: 30, height: 30),
                  onPressed: () => Get.to(SettingsScreen())),
              Button("Deconnexion", color: Colors.red, onPressed: () {
                _showLogoutConfirmation();
              }),
            ],
          ),
        ),
      ),
    );
  }

  _showLogoutConfirmation() {
    showInfoDialog(context,
        message: "Voulez-vous vous déconnecter ?",
        positiveLabel: "OUI", positiveAction: () async {
      controller.clearSession();
      Get.offAll(LoginScreen());
    }, negativeLabel: "NON");
  }
}
