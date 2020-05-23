import '../models/transaction.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class ListItemDeleteButton extends StatelessWidget {
  final double width;
  final Function deleteTx;
  final Transaction tx;

  ListItemDeleteButton({this.width, this.deleteTx, this.tx});

  @override
  Widget build(BuildContext context) {
    return width > 460
        ? FlatButton.icon(
            color: Util.deleteBtnBg,
            onPressed: () => deleteTx(tx.id),
            icon: const Icon(
              Icons.delete,
              color: Util.deleteIconColor,
            ),
            label: const Text('Delete'),
            textColor: Util.deleteIconColor,
          )
        : IconButton(
            icon: const Icon(
              Icons.delete,
              color: Util.deleteIconColor,
            ),
            color: Util.deleteIconColor,
            onPressed: () => deleteTx(tx.id),
          );
  }
}
