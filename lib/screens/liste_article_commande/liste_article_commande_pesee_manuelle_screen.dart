import 'package:fish_scan/data/dummy.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:fish_scan/screens/depotage/depotage_screen.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_logic.dart';
import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_pesee_manuelle_item.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_logic.dart';
import 'package:fish_scan/screens/vente/vente_pesee_manuelle_screen.dart';
import 'package:fish_scan/screens/vente/vente_screen.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/error_message.dart';
import 'package:fish_scan/widgets/list_data.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:fish_scan/widgets/titled_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liste_article_item.dart';

class ListeArticleCommandePeseeManuelleScreen extends StatefulWidget {
  final Commande commande;

  const ListeArticleCommandePeseeManuelleScreen({Key key, this.commande})
      : super(key: key);

  @override
  _ListeArticleCommandePeseeManuelleScreenState createState() =>
      _ListeArticleCommandePeseeManuelleScreenState();
}

class _ListeArticleCommandePeseeManuelleScreenState
    extends State<ListeArticleCommandePeseeManuelleScreen> {
  Commande commande;

  final listeArticleController = Get.put(ListeArticleCommandeController());
  final listeCommandeController = Get.put(ListeCommandeController());

  @override
  void initState() {
    commande = widget.commande;
    super.initState();
    _getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(commande == null
            ? "Feuille article"
            : "Commande N° ${commande.no}"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => _getArticles(),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (listeArticleController.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return listeArticleController.response.when(
            error: (String message) {
              return ErrorMessage(
                message: message,
                retry: () => _getArticles(),
              );
            },
            data: (List<Article> items) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListData<Article>(
                      emptyMessage: "Aucun article pour cette commande",
                      onClick: (item) {
                        toNextScreen(item);
                      },
                      items: items,
                      data: (Article item) {
                        return ListeArticlePeseeManuelleItem(item: item, click: (){
                          Get.to(VentePeseeManuelleScreen(article: item,));
                        });
                      },
                    ),
                  ),
                  /*if (widget.menu == NavigationMenu.VENTE_EN_COURS_PREPARATION)
                    Button(
                      "Valider",
                      onPressed: () => _updateStatusCommande(),
                    )*/
                ],
              );
            },
          );
        }),
      ),
    );
  }

  void toNextScreen(Article item) async {
    var result = await Get.to(VentePeseeManuelleScreen(article: item));
    handleResult(result);
  }

  void handleResult(result) {
    if (result != null) {
      _getArticles();
    }
  }

  Future _getArticles() =>
      listeArticleController.getArticlesPeseeManuelle(commandeNo: commande.no);
}
