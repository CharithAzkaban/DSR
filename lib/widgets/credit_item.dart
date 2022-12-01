import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class CreditItem extends StatefulWidget {
  final String customertName;
  final double creditAmount;
  const CreditItem({
    Key? key,
    required this.customertName,
    required this.creditAmount,
  }) : super(key: key);

  @override
  State<CreditItem> createState() => _CreditItemState();
}

class _CreditItemState extends State<CreditItem> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(10)));

    return Material(
      shape: _shapeBorder,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          widget.customertName,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
            onPressed: () {
              confirm(context, 'Remove this credit?', onConfirm: () async{
                context.read<DSRProvider>().deleteCredit(widget);
                Navigator.pop(context);
              }, okText: 'Remove');
            },
            splashRadius: 20.0,
            icon: Icon(
              Icons.clear,
              color: Colors.red,
            )),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            price(widget.creditAmount),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        shape: _shapeBorder,
        tileColor: Colors.white,
      ),
    );
  }
}
