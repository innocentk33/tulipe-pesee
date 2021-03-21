import 'package:fish_scan/models/commande.dart';
import 'package:flutter/material.dart';

import '../../constants/navigation_menu.dart';
import '../../constants/navigation_menu.dart';
import '../../utils/get_storage_service.dart';
import '../button/button.dart';
import '../dialogs.dart';
import '../spacers.dart';

enum ItemCommandePeseeManuelleAction { PESEUR, VERIFICATEUR, VALIDER, OUVRIR }

class ItemCommandePeseeManuelle extends StatefulWidget {
  final Commande item;
  final NavigationMenu menu;
  final Function(ItemCommandePeseeManuelleAction) callback;

  const ItemCommandePeseeManuelle(
      {Key key, this.item, this.callback, this.menu})
      : super(key: key);

  @override
  _ItemCommandePeseeManuelleState createState() =>
      _ItemCommandePeseeManuelleState();
}

class _ItemCommandePeseeManuelleState extends State<ItemCommandePeseeManuelle> {
  String userName;
  Commande commande;
  String dateCommande ="";
  String heureCommande ="";

  @override
  void initState() {
    commande = widget.item;
    dateCommande =commande.creationDate;
        super.initState();
    GetStorageService.getLogin().then((value) => userName = value);
  }
  @override
  void setState(fn) {

    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

 print(dateCommande.substring(0,10));

   heureCommande = dateCommande.substring(12,15);
   print(dateCommande);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "N°: ${commande.no}",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ),

              Text(
                "${dateCommande.substring(0,10) + " à "+dateCommande.substring(11,16)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      commande.sellToCustomerName.isEmpty
                          ? commande.buyFromVendorName
                          : commande.sellToCustomerName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text("Commercial: ${commande.salePersonCode}"),
                    Text("Préparateur: ${commande.preparateur ?? ''}"),
                    Visibility(
                      visible: false,
                      child: Text(

                          "Vérificateur: ${commande.verificateur ?? ''}",),
                    ),
                    Text("Statut pesée: "),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Button("Traiter", onPressed: () {
                    checkPeseur();
                  }),

               /*   Button("Vérificateur", onPressed: () {
                    checkVerificateur();
                  }),
                  Button("Valider",
                      onPressed: () => widget
                          .callback(ItemCommandePeseeManuelleAction.VALIDER)),*/
                ],
              ))
            ],
          ),
          VSpacer.normal,
          Divider(
            height: 1,
            color: Colors.black,
          ),
          VSpacer.normal,
        ],
      ),
    );
  }

  void checkPeseur() {
    if (commande.preparateur == null) {
      widget.callback(ItemCommandePeseeManuelleAction.PESEUR);
      return;
    }
    /*if (commande.preparateur != userName) {
      showInfoDialog(context,
          message: "Vous n'êtes pas peseur pour cette commande");
      return;
    }*/
    openCommande();
  }

  void checkVerificateur() {
    if (commande.verificateur == null) {
      widget.callback(ItemCommandePeseeManuelleAction.VERIFICATEUR);
      return;
    }
    if (commande.verificateur != userName) {
      showInfoDialog(context,
          message: "Vous n'êtes pas vérificateur pour cette commande");
      return;
    }
    openCommande();
  }

  void openCommande() {
    widget.callback(ItemCommandePeseeManuelleAction.OUVRIR);
  }
}
