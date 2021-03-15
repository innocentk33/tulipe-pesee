import 'package:fish_scan/models/commande.dart';
import 'package:flutter/material.dart';

import '../spacers.dart';

class ItemInfoCommande extends StatelessWidget {
  final Commande item;

  const ItemInfoCommande({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "N°: ${item.no}",
          style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
        ),
        Text(
          item.sellToCustomerName.isEmpty
              ? item.buyFromVendorName
              : item.sellToCustomerName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        Text("Commercial: ${item.salePersonCode}"),
        Text("Préparateur: ${item.preparateur}"),
      ],
    );
  }
}
