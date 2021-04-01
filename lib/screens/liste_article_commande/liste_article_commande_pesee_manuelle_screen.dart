import 'package:fish_scan/data/dummy.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:fish_scan/screens/depotage/depotage_screen.dart';
import 'package:fish_scan/screens/home/home_controller.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_commande_logic.dart';
import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/screens/liste_article_commande/liste_article_pesee_manuelle_item.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_logic.dart';
import 'package:fish_scan/screens/liste_commande/liste_commande_pesee_manuelle_logic.dart';
import 'package:fish_scan/screens/vente/vente_pesee_manuelle_screen.dart';
import 'package:fish_scan/screens/vente/vente_screen.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
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
  final String login;



  const ListeArticleCommandePeseeManuelleScreen({Key key, this.commande, this.login})
      : super(key: key);

  @override
  _ListeArticleCommandePeseeManuelleScreenState createState() =>
      _ListeArticleCommandePeseeManuelleScreenState();
}

class _ListeArticleCommandePeseeManuelleScreenState
    extends State<ListeArticleCommandePeseeManuelleScreen> {
  Commande commande;
  // String login;

  final listeArticleController = Get.put(ListeArticleCommandeController());
  final listeCommandeController = Get.put(ListeCommandeController());
  final listeCommandePeseeManuelleController =Get.put(ListeCommandePeseeManuelleController());
  //final login = GetStorageService.getLogin() as String ;

  HomeController ctrlGetLogin = Get.put(HomeController());

  @override
  void initState() {
    commande = widget.commande;
      //this.login =  await GetStorageService.getLogin();
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
      body: Obx(() {
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
                        print("my login : ${this.ctrlGetLogin.login.toUpperCase()}");
                        if( item.preparateur == this.ctrlGetLogin.login.toUpperCase() || item.verificateur == this.ctrlGetLogin.login.toUpperCase() ){
                          print("\n\n\n\n\n ${item.documentNo}\n\n\n\n");
                          setComLinPeseeActeur(item.documentNo, item.no);
                          Get.to(VentePeseeManuelleScreen(article: item,));
                        }else if( item.preparateur == null  || item.verificateur == null ){
                          print("\n\n\n\n\n ${item.documentNo}\n\n\n\n");
                          setComLinPeseeActeur(item.documentNo, item.no);
                          Get.to(VentePeseeManuelleScreen(article: item,));
                        }else{
                          showInfoDialog(context, message: "Il existe déjà un péseur et un vérificateur pour cet article !!");
                        }
                        /*if ( (item.preparateur != "" && item.preparateur != this.ctrlGetLogin.login)){// ||
                            //(item.verificateur != "" && item.verificateur != this.ctrlGetLogin.login )  ){
                          //showInfoDialog(context, message: "Il existe déjà un péseur et un vérificateur pour cet article !!");
                        }
                        else {

                        }*/
                        //Get.to(VentePeseeManuelleScreen(article: item,));
                      });
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/9,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        /*Container(

                          width: MediaQuery.of(context).size.width/1.4,
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Validateur :",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,

                                ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text("15,26KG:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,

                                    ),),
                                  Text("000XXX"),
                                ],
                              ),
                            ],
                          ),
                        )*/

                        Column(

                          children: [

                            MaterialButton(

                              color: Colors.white,
                              onPressed: (){
                                print("click");
                                validerCommande(commande.no);

                              },
                              child: Text("Valider",style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                              ),),
                            ),
                          ],
                        ),

                      ],
                    ),
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

  void setComLinPeseeActeur(String documentNo, String no) {
    listeCommandePeseeManuelleController.setComLinPeseeActeur(documentNo , no);
  }


  void validerCommande(String noCommande) async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await listeCommandePeseeManuelleController.validerCommande(noCommande);
    print("\n\n\n VALIDERRRRRRRR ${response.message}");

    showInfoDialog(context, message: response.message, positiveAction: () {
      Get.back();
      Get.back();
    });

  }
}
