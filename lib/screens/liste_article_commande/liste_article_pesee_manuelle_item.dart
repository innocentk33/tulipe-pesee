import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_item_controller.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
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
    return InkWell(
      onTap: (){
        print("never");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              item.description,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(

                            "${item.controle ? 'CORRECTE' : 'INCORRECTE'}",

                            style: TextStyle(fontWeight: FontWeight.bold,
                            color: item.controle ?Colors.green:Colors.red,

                            ),

                          )
                        ],
                      ),
                      VSpacer.normal,


                      Row(
                        children: [
                          Text(
                            "Peseur:",
                          ),
                          Text("${item.preparateur ?? ""}",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Vérificateurzer: ",
                          ),
                          Text("${item.verificateur ?? ""}",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Cartons : ",
                          ),
                          Text("${item.cartonPeseur}",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Poids :",
                          ),
                          Text("${item.poids1}",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Prix :",
                          ),
                          Text("${item.unitPrice} FCFA",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Montant :",
                          ),
                          Text("${item.unitPrice * double.parse(item.poids1)} FCFA",style: TextStyle(
                            fontWeight: FontWeight
                                .w900,

                          ),)
                        ],
                      ),
                      VSpacer.normal,
                    ],
                  ),
                ),
                Expanded(
                  child: Button(
                    "Saisirzer",
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
      ),
    );
  }

  double _getPoidsTotal() {
    return 0 /*(widget.menu == NavigationMenu.DEPOTAGE || widget.menu == NavigationMenu.DEPOTAGE_RAPIDE) ? item.quantity : item.quantityBase*/;
  }
}
