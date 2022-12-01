import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankingItem extends StatefulWidget {
  final String bName;
  final int bId;
  final double amount;
  final String refno;
  const BankingItem({
    Key? key,
    required this.bName,
    required this.bId,
    required this.amount,
    required this.refno,
  }) : super(key: key);

  @override
  State<BankingItem> createState() => _BankingItemState();
}

class _BankingItemState extends State<BankingItem> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));

    return Material(
      shape: _shapeBorder,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          widget.bName,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
            onPressed: () {
              confirm(context, 'Remove this banking?', onConfirm: () async {
                context.read<DSRProvider>().deleteBanking(widget);
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
            price(widget.amount),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        shape: _shapeBorder,
        tileColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Image.asset(
            'assets/${widget.bName == 'People\'s Bank' ? 'peoples.png' : widget.bName == 'Cargills Bank' ? 'cargills.png' : 'sampath.png'}',
          ),
        ),
      ),
    );
  }
}
