import 'package:dio/dio.dart';
import 'package:dsr_app/models/stock.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';

class IssuedItem extends StatefulWidget {
  final int productId;
  final int stockId;
  final String productName;
  final double productQuantity;
  const IssuedItem({
    Key? key,
    required this.productId,
    required this.stockId,
    required this.productName,
    required this.productQuantity,
  }) : super(key: key);

  @override
  State<IssuedItem> createState() => _IssuedItemState();
}

class _IssuedItemState extends State<IssuedItem> {
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
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                numberUnit(widget.productQuantity),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        trailing: IconButton(
            onPressed: () {
              confirm(context, 'Reduce ${widget.productName}?',
                      onConfirm: () async {
                await returnIssuedItem(context, widget.stockId,
                    widget.productId, widget.productQuantity);
                Navigator.pop(context);
                Navigator.pop(context);
              }, okText: 'Reduce');
            },
            splashRadius: 20.0,
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.red,
            )),
        // onLongPress: () async {
        //   final TextEditingController quantityController =
        //       TextEditingController();
        //   final FocusNode quantityFocus = FocusNode();
        //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        //   final int? dsrId = await context.read<LoginProvider>().currentUser.id;
        //   callBack(List<int> stockIdList) {
        //   }

        //   confirmWithContent(
        //       context,
        //       DialogBody(
        //         productId: widget.productId,
        //         stockId: widget.stockId,
        //         dsrId: dsrId!,
        //         productName: widget.productName,
        //         formKey: formKey,
        //         callBack: callBack,
        //         quantityController: quantityController,
        //         quantityFocus: quantityFocus,
        //         productQuantity: widget.productQuantity,
        //       ),
        //       callBack: () {}, onConfirm: () async {
        //     if (formKey.currentState!.validate()) {
        //       await returnIssuedItem(context, widget.stockId, widget.productId,
        //           double.parse(quantityController.text.trim()));
        //       Navigator.pop(context);
        //       Navigator.pop(context);
        //       return;
        //     }
        //   }, okText: 'Reduce');
        // },
        shape: _shapeBorder,
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final int dsrId;
  final int stockId;
  final int productId;
  final String productName;
  final double productQuantity;
  final TextEditingController quantityController;
  final FocusNode quantityFocus;
  final GlobalKey<FormState> formKey;
  final Function callBack;
  const DialogBody(
      {Key? key,
      required this.dsrId,
      required this.stockId,
      required this.productId,
      required this.productName,
      required this.quantityController,
      required this.quantityFocus,
      required this.formKey,
      required this.productQuantity,
      required this.callBack})
      : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  List<int> stockIdList = [];

  @override
  void initState() {
    _loadStockIds();
    super.initState();
  }

  Future _loadStockIds() async {
    try {
      final stockResponse = await Dio().post('$baseUrl/mobile_get_dsr_stockIds',
          data: {"dsr_id": widget.dsrId, "item_id": widget.productId});
      List list = stockResponse.data['data']['info'];
      for (final stock in list) {
        Stock stk = Stock.fromJson(stock);
        stockIdList.add(stk.stock_id);
      }
      widget.callBack(stockIdList);
    } on Exception catch (e) {
      print(e.toString());
      toast(msg: 'Stocks loading error!', toastStatus: TS.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.productName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: widget.quantityController,
            focusNode: widget.quantityFocus,
            decoration: InputDecoration(
              labelText: 'Reduce quantity',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            onFieldSubmitted: (qty) async {
              if (widget.formKey.currentState!.validate()) {
                await returnIssuedItem(
                    context,
                    widget.stockId,
                    widget.productId,
                    double.parse(widget.quantityController.text.trim()));
                Navigator.pop(context);
                Navigator.pop(context);
                return;
              }
            },
            validator: (qty) {
              if (qty!.trim().isEmpty) {
                return 'Quantity is required!';
              } else {
                if (double.parse(qty.trim()) <= 0) {
                  return 'Invalid quantity!';
                } else if (double.parse(qty.trim()) > widget.productQuantity) {
                  return 'Quantity exceeded!';
                } else {
                  return null;
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
