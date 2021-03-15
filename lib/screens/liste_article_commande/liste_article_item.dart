import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_item_controller.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListeArticleItem extends StatefulWidget {
  final Article item;
  final NavigationMenu menu;

  const ListeArticleItem({Key key, this.item, this.menu}) : super(key: key);

  @override
  _ListeArticleItemState createState() => _ListeArticleItemState();
}

class _ListeArticleItemState extends State<ListeArticleItem> {
  Article item;

  ListeArticleItemController controller = ListeArticleItemController();

  @override
  void initState() {
    item = widget.item;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.setArticle(item);
      controller
          .loadDatas(widget.menu == NavigationMenu.DEPOTAGE ? "39" : "37");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "N°${item.no} - ${item.description}",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              VSpacer.normal,
              Text(
                  "Nombre : ${item.nombreDeCartons} - Poids total: ${_getPoidsTotal()} kg",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              VSpacer.normal,
              Obx(() {
                if (controller.isLoading)
                  return Center(child: CircularProgressIndicator());
                return Text(
                    "Carton effectif : ${controller.nombreCartons} - Poids effectif: ${controller.poids} kg");
              }),
              VSpacer.normal,
              if (widget.menu != NavigationMenu.DEPOTAGE)
                Text(
                    "Prix unitaire : ${item.unitPrice} - Montant: ${item.totalAmountInclVAT}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
    return (widget.menu == NavigationMenu.DEPOTAGE || widget.menu == NavigationMenu.DEPOTAGE_RAPIDE) ? item.quantity : item.quantityBase;
  }
}
