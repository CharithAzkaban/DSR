import 'package:dsr_app/dsr_provider.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final int productId;
  final List<int> stockIds;
  final String productName;
  final double productPrice;
  final double? productQuantity;
  const ProductItem(
      {Key? key,
      required this.productId,
      required this.stockIds,
      required this.productName,
      required this.productPrice,
      required this.productQuantity})
      : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {

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
          widget.productName,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
            onPressed: () {
              confirm(context, 'Remove this item?', onConfirm: () async{
                context.read<DSRProvider>().deleteProduct(widget);
                Navigator.pop(context);
              }, okText: 'Remove');
            },
            splashRadius: 20.0,
            icon: Icon(
              Icons.close_rounded,
              color: Colors.red,
            )),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                price(widget.productPrice),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                '  x  ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                number(widget.productQuantity!),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '  =  ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                price(widget.productPrice * (widget.productQuantity ?? 0)),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        shape: _shapeBorder,
      ),
    );
  }
}
