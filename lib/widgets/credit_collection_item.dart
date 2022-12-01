import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class CreditCollectionItem extends StatefulWidget {
  final String customertName;
  final double creditAmount;
  const CreditCollectionItem({
    Key? key,
    required this.customertName,
    required this.creditAmount,
  }) : super(key: key);

  @override
  State<CreditCollectionItem> createState() => _CreditCollectionItemState();
}

class _CreditCollectionItemState extends State<CreditCollectionItem> {
  @override
  Widget build(BuildContext context) {

    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));

    return Material(
      shape: _shapeBorder,
      elevation: 10.0,
      child: ListTile(
        title: Text(
          widget.customertName,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        trailing: IconButton(
            onPressed: () {
              confirm(context, 'Remove this credit collection?', onConfirm: () async{
                context.read<DSRProvider>().deleteCreditCollection(widget);
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        shape: _shapeBorder,
        tileColor: Colors.white,
      ),
    );
  }
}
