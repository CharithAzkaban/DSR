import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class ReturnItem extends StatefulWidget {
  final String customertName;
  final String productName;
  final int productId;
  final double quantity;
  final double amount;
  const ReturnItem({
    Key? key,
    required this.customertName,
    required this.productName,
    required this.productId,
    required this.quantity,
    required this.amount,
  }) : super(key: key);

  @override
  State<ReturnItem> createState() => _ReturnItemState();
}

class _ReturnItemState extends State<ReturnItem> {
  bool selected = false;
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
      child: Consumer<DSRProvider>(
        builder: (context, data, child) {
          if (!data.selectableBanking) {
            selected = false;
          }
          return ListTile(
            title: Text(
              widget.customertName,
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    numberUnit(widget.quantity),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            shape: _shapeBorder,
            onLongPress: () {
              if (!data.selectableBanking) {
                data.setSelectableBanking(true);
                setState(() {
                  selected = true;
                });
              }
            },
            onTap: () {
              setState(() {
                if (selected) {
                  selected = false;
                } else if (!selected && data.selectableBanking) {
                  selected = true;
                }
              });
            },
            trailing: IconButton(
                onPressed: () {
                  confirm(context, 'Remove this return?', onConfirm: () async {
                    context.read<DSRProvider>().deleteReturn(widget);
                    Navigator.pop(context);
                  }, okText: 'Remove');
                },
                splashRadius: 20.0,
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                )),
            selected: selected,
            tileColor: Colors.white,
          );
        },
      ),
    );
  }
}
