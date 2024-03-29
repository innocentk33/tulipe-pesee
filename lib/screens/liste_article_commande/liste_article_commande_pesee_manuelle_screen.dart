

import 'package:fish_scan/constants/strings.dart';
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
import 'dart:developer';
import 'dart:convert';

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
  String  montantTotal="0";
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
   _getMontantTotalPesee(commande.no);

  }
  @override
  void setState(fn) {
    _getMontantTotalPesee(commande.no);
    // TODO: implement setState
    super.setState(fn);
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
              onTap: () {
                _getArticles();
                _getMontantTotalPesee(commande.no);
              },
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
                          print("\n\n\n\n\n ${item.lineNo}\n\n\n\n");
                          setComLinPeseeActeur(item.documentNo, item.no,item.lineNo);
                          Get.to(VentePeseeManuelleScreen(article: item,));
                        }else if( item.preparateur == null  || item.verificateur == null ){
                          print("\n\n\n\n\n ${item.lineNo}\n\n\n\n");
                          setComLinPeseeActeur(item.documentNo, item.no,item.lineNo);
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
                  height: MediaQuery.of(context).size.height*0.1,

                  decoration: BoxDecoration(
                    color: kVert,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$montantTotal",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text("Montant",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,

                          ),),
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
     floatingActionButton: FloatingActionButton.extended(
       elevation: 2,
       onPressed: (){
         print("click");
         validerCommande(commande.no);
         //_getMontantTotalPesee(commande.no);
         print("\n\n montant total : $montantTotal");
       },
       label: Text("Valider",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
       icon: Icon(Icons.check),
       backgroundColor: kRose,
     ),

     /* bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,

        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0XFFca1961),
            borderRadius: BorderRadius.circular(8)
          ),
          margin: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height*.06,
        ),
      ),*/
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

  void setComLinPeseeActeur(String documentNo, String no,String noLine) {
    listeCommandePeseeManuelleController.setComLinPeseeActeur(documentNo , no,noLine);
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
  _getMontantTotalPesee(String noCommande) async{
    var response = await listeCommandeController.getMontantTotalPesee(noCommande);
    print("\n\n\n MONTANT RECHERCHER ${response.body}");
    montantTotal = response.body;
    return response.body;
  }
}
