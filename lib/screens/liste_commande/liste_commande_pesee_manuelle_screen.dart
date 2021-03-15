import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_pesee_manuelle_screen.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_logic.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_pesee_manuelle_logic.dart';
import 'package:fish_scan/widgets/commande/item_commande.dart';
import 'package:fish_scan/widgets/commande/item_commande_pesee_manuelle.dart';
import 'package:fish_scan/widgets/commande/item_demande_commande.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/error_message.dart';
import 'package:fish_scan/widgets/list_data.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/navigation_menu.dart';
import '../../widgets/dialogs.dart';

class ListeCommandePeseeManuelleScreen extends StatefulWidget {
  final NavigationMenu menu;

  const ListeCommandePeseeManuelleScreen({Key key, this.menu})
      : super(key: key);

  @override
  _ListeCommandePeseeManuelleScreenState createState() =>
      _ListeCommandePeseeManuelleScreenState();
}

class _ListeCommandePeseeManuelleScreenState
    extends State<ListeCommandePeseeManuelleScreen> {
  final controller = Get.put(ListeCommandePeseeManuelleController());

  @override
  void initState() {
    super.initState();
    _getCommandes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Liste de commandes",
        ),
        actions: [
          GestureDetector(
            onTap: () => _getCommandes(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return controller.response.when(
            error: (String message) {
              return ErrorMessage(
                message: message,
                retry: () => _getCommandes(),
              );
            },
            data: (List<Commande> items) {
              return Column(
                children: [
                  /*if (widget.menu != NavigationMenu.DEPOTAGE)
                    Text("Statut : ${controller.getStatusLabel(widget.menu)}"),*/
                  VSpacer.normal,
                  Expanded(
                    child: ListData<Commande>(
                      onClick: (item) {},
                      items: items,
                      data: (Commande commande) {
                        return ItemCommandePeseeManuelle(
                          item: commande,
                          menu: widget.menu,
                          callback: (ItemCommandePeseeManuelleAction action) {
                            switch (action) {
                              case ItemCommandePeseeManuelleAction.PESEUR:
                                updateNomPeseur(commande);
                                break;
                              case ItemCommandePeseeManuelleAction.VERIFICATEUR:
                                updateVerificateur(commande);
                                break;
                              case ItemCommandePeseeManuelleAction.VALIDER:
                                validerPesee(commande);
                                break;
                              case ItemCommandePeseeManuelleAction.OUVRIR:
                                showListArticle(commande);
                                break;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Future _getCommandes() {
    controller.getCommandes(
        widget.menu, controller.getStatusValue(widget.menu));
  }

  void updateNomPeseur(Commande commande) async {
    showInfoDialog(context,
        message: "Voulez-vous traiter cette commande ?",
        positiveLabel: "OUI", positiveAction: () async {
      showLoadingDialog(context, message: "Veuillez patienter ...");
      var response = await controller.updateNomPeseur(commande.no);
      Get.back();
      showInfoDialog(context,
          message: response.hasError
              ? "Une erreur est survenue"
              : "Opération réussie", positiveAction: () {
        if (!response.hasError) {
          showListArticle(commande);
        }
      });
    }, negativeLabel: "NON");
  }

  void updateVerificateur(Commande commande) async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await controller.updateNomVerificateur(commande.no);
    Get.back();
    showInfoDialog(context,
        message: response.hasError
            ? "Une erreur est survenue"
            : "Opération réussie", positiveAction: () {
      if (!response.hasError) {
        showListArticle(commande);
      }
    });
  }

  void showListArticle(Commande commande) {
    Get.off(ListeArticleCommandePeseeManuelleScreen(commande: commande));
  }

  void validerPesee(Commande commande) async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await controller.validerPesee(commande.no);
    Get.back();
    showInfoDialog(context, message: response.message, positiveAction: () {
      if (response.message.contains("succès")) {}
    });
  }
}
