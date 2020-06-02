import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../util.dart';

class ListItemEditButton extends StatelessWidget {
  final double width;
  final Function editTx;
  final Transaction tx;

  ListItemEditButton({this.width, this.editTx, this.tx});

  @override
  Widget build(BuildContext context) {
    return width > 460
        ? FlatButton.icon(
            color: Util.editBtnBg,
            onPressed: () => editTx(tx),
            icon: const Icon(
              Icons.edit,
              color: Util.editIconColor,
            ),
            label: const Text('Edit'),
            textColor: Util.editIconColor,
          )
        : IconButton(
            icon: const Icon(
              Icons.edit,
              color: Util.editIconColor,
            ),
            color: Util.editIconColor,
            onPressed: () => editTx(tx),
          );
  }
}
