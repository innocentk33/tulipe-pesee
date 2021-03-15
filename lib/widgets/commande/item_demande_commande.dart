import 'package:fish_scan/constants/status_commande_constants.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:flutter/material.dart';

import '../spacers.dart';
import 'item_info_commande.dart';

class ItemDemandeCommande extends StatelessWidget {
  final Commande item;
  final Function buttonCallback;

  const ItemDemandeCommande({Key key, this.item, this.buttonCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child:  ItemInfoCommande(item: item),
            ),
            Expanded(child: Button("Traiter", onPressed: () => buttonCallback()))
          ],
        ),
        VSpacer.normal,
        Divider(
          height: 1,
          color: Colors.black,
        ),
        VSpacer.normal,
      ],
    );
  }
}
