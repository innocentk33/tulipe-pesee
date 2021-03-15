import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_screen.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_logic.dart';
import 'package:fish_scan/widgets/commande/item_commande.dart';
import 'package:fish_scan/widgets/commande/item_demande_commande.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/error_message.dart';
import 'package:fish_scan/widgets/list_data.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListeCommandeScreen extends StatefulWidget {
  final NavigationMenu menu;

  const ListeCommandeScreen({Key key, this.menu}) : super(key: key);

  @override
  _ListeCommandeScreenState createState() => _ListeCommandeScreenState();
}

class _ListeCommandeScreenState extends State<ListeCommandeScreen> {
  final controller = Get.put(ListeCommandeController());

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
                  if (widget.menu != NavigationMenu.DEPOTAGE)
                    Text("Statut : ${controller.getStatusLabel(widget.menu)}"),
                  VSpacer.normal,
                  Expanded(
                    child: ListData<Commande>(
                      onClick: (item) {
                        if (widget.menu == NavigationMenu.DEPOTAGE) {
                          Get.to(ListeArticleCommandeScreen(
                              commande: item, menu: widget.menu));
                        } else if (widget.menu ==
                            NavigationMenu.VENTE_EN_COURS_PREPARATION) {
                          Get.to(ListeArticleCommandeScreen(
                              commande: item, menu: widget.menu));
                        }
                      },
                      items: items,
                      data: (Commande item) {

                        if (widget.menu ==
                            NavigationMenu.VENTE_DEMANDE_PREPARATION) {
                          return ItemDemandeCommande(
                            item: item,
                            buttonCallback: () =>
                                showInfoDialog(context,
                                    message: "Voulez-vous traiter cette commande ?",
                                    positiveLabel: "OUI",
                                    positiveAction: () =>
                                        _updateCommandeStatus(item),
                                    negativeLabel: "NON"),
                          );
                        }

                        return ItemCommande(item: item);
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
    controller.getCommandes(widget.menu, controller.getStatusValue(widget.menu));
  }

  _updateCommandeStatus(Commande item) async {
    showLoadingDialog(context, message: "Veuillez patienter ...");

    var response =
    await controller.updateCommandeStatus(commande: item, status: 2);

    Get.back();

    if (response.hasError) {
      showInfoDialog(context, message: response.message);
      return;
    }

    Get.off(ListeArticleCommandeScreen(
        commande: item, menu: NavigationMenu.VENTE_EN_COURS_PREPARATION));
  }
}
