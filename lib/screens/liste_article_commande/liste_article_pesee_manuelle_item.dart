import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_item_controller.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/button/button.dart';

class ListeArticlePeseeManuelleItem extends StatefulWidget {
  final Article item;
  final Function click;

  const ListeArticlePeseeManuelleItem({Key key, this.item, this.click})
      : super(key: key);

  @override
  _ListeArticlePeseeManuelleItemState createState() =>
      _ListeArticlePeseeManuelleItemState();
}

class _ListeArticlePeseeManuelleItemState
    extends State<ListeArticlePeseeManuelleItem> {
  Article item;

  ListeArticleItemController controller = ListeArticleItemController();

  @override
  void initState() {
    item = widget.item;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /*controller.setArticle(item);
      controller
          .loadDatas(widget.menu == NavigationMenu.DEPOTAGE ? "39" : "37");*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.description,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    VSpacer.normal,
                    Text(
                      "Statut pesée: ${item.controle ? 'Validé' : 'Invalide'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    VSpacer.normal,
                    Text(
                      "Préparateur: ${item.preparateur ?? ""}",
                    ),
                    Text(
                      "Vérificateur: ${item.verificateur ?? ""}",
                    ),
                    Text(
                      "Nombre de cartons : ${item.nombreDeCartons}",
                    ),
                    VSpacer.normal,
                    Text(
                      "Poids : ${item.poids1}",
                    ),
                    Text(
                      "Prix : ${item.unitPrice} FCFA",
                    ),
                    Text(
                      "Montant : ${item.unitPrice * double.parse(item.poids1)} FCFA",
                    ),
                    VSpacer.normal,
                  ],
                ),
              ),
              Expanded(
                child: Button(
                  "Saisir",
                  onPressed: () {
                    widget.click();
                  },
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.black,
        ),
        VSpacer.normal,
      ],
    );
  }

  double _getPoidsTotal() {
    return 0 /*(widget.menu == NavigationMenu.DEPOTAGE || widget.menu == NavigationMenu.DEPOTAGE_RAPIDE) ? item.quantity : item.quantityBase*/;
  }
}
