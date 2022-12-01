import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DirectBankingItem extends StatefulWidget {
  final String customertName;
  final double bankedAmount;
  final String bank;
  final String refno;
  const DirectBankingItem({
    Key? key,
    required this.customertName,
    required this.bankedAmount,
    required this.bank,
    required this.refno,
  }) : super(key: key);

  @override
  State<DirectBankingItem> createState() => _DirectBankingItemState();
}

class _DirectBankingItemState extends State<DirectBankingItem> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));

    final DSRProvider dsrProvider =
        Provider.of<DSRProvider>(context, listen: false);

    return Material(
      shape: _shapeBorder,
      elevation: 10.0,
      child: Consumer<DSRProvider>(
        builder: (context, data, child) {
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
                    price(widget.bankedAmount),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.refno,
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
                dsrProvider.selectDirectBanking(widget);
                data.setSelectableBanking(true);
                setState(() {
                  selected = true;
                });
              }
            },
            onTap: () {
              if (selected) {
                dsrProvider.deselectDirectBanking(widget);
                setState(() {
                  selected = false;
                });
              } else if (data.selectableBanking) {
                dsrProvider.selectDirectBanking(widget);
                setState(() {
                  selected = true;
                });
              }
            },
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Image.asset(
                  'assets/${widget.bank == 'People\'s Bank' ? 'peoples.png' : widget.bank == 'Cargills Bank' ? 'cargills.png' : 'sampath.png'}'),
            ),
            trailing: IconButton(
                onPressed: () {
                  confirm(context, 'Remove this direct banking?',
                      onConfirm: () async {
                    context.read<DSRProvider>().deleteDirectBanking(widget);
                    Navigator.pop(context);
                  }, okText: 'Remove');
                },
                splashRadius: 20.0,
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                )),
            tileColor: Colors.white,
          );
        },
      ),
    );
  }
}
