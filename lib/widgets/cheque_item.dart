import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/cheque.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class ChequedItem extends StatelessWidget {
  final Cheque cheque;
  const ChequedItem({
    Key? key,
    required this.cheque,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)));

    return Material(
      shape: _shapeBorder,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          cheque.cheque_no,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            price(cheque.cheque_amount),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: IconButton(
            onPressed: () {
               context.read<DSRProvider>().removeCheque(cheque);
            },
            splashRadius: 20.0,
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.red,
            )),
        shape: _shapeBorder,
      ),
    );
  }
}