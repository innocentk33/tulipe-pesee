import 'package:fish_scan/models/commande.dart';
import 'package:flutter/material.dart';

import '../spacers.dart';
import 'item_info_commande.dart';

class ItemCommande extends StatelessWidget {
  final Commande item;

  const ItemCommande({Key key, this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemInfoCommande(item: item),
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
}
