import 'package:dio/dio.dart';
import 'package:dsr_app/models/stock.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:provider/provider.dart';

class BalanceItem extends StatefulWidget {
  final int productId;
  final String productName;
  final double productPrice;
  final double productQuantity;
  final double returnedQty;
  const BalanceItem({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.returnedQty,
  }) : super(key: key);

  @override
  State<BalanceItem> createState() => _BalanceItemState();
}

class _BalanceItemState extends State<BalanceItem> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));

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
              // Text(
              //   price(widget.productPrice),
              //   style:
              //       TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              // ),
              // Text(
              //   '  x  ',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
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
        trailing: widget.returnedQty != 0
            ? Text(
                numberUnit(widget.returnedQty),
                style: TextStyle(
                    color: Colors.red[700], fontWeight: FontWeight.bold),
              )
            : null,
        shape: _shapeBorder,
        onLongPress: () async {
          final TextEditingController quantityController =
              TextEditingController();
          final FocusNode quantityFocus = FocusNode();
          final GlobalKey<FormState> formKey = GlobalKey<FormState>();
          final int? dsrId = await context.read<LoginProvider>().currentUser.id;
          List<int> _stockIdList = [];
          callBack(List<int> stockIdList) {
            _stockIdList = stockIdList;
          }

          confirmWithContent(
              context,
              DialogBody(
                productId: widget.productId,
                dsrId: dsrId!,
                productName: widget.productName,
                formKey: formKey,
                callBack: callBack,
                quantityController: quantityController,
                quantityFocus: quantityFocus,
                productQuantity: widget.productQuantity,
              ), onConfirm: () async {
            if (formKey.currentState!.validate()) {
              await returnItem(context, _stockIdList, widget.productId,
                  double.parse(quantityController.text.trim()));
              Navigator.pop(context);
              Navigator.pop(context);
              return;
            }
          }, okText: 'Return');
        },
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final int dsrId;
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
              labelText: 'Return quantity',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            onFieldSubmitted: (qty) async {
              if (widget.formKey.currentState!.validate()) {
                await returnItem(context, stockIdList, widget.productId,
                    double.parse(qty.trim()));
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
