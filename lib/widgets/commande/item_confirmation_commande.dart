import 'package:fish_scan/constants/status_commande_constants.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:flutter/material.dart';

import '../spacers.dart';
import 'item_info_commande.dart';

class ItemConfirmationCommande extends StatelessWidget {
  final Commande item;

  const ItemConfirmationCommande({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ItemInfoCommande(item: item),
            ),
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
