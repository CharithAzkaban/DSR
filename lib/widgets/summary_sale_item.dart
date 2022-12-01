import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummarySaleItem extends StatefulWidget {
  final int id;
  final int productId;
  final int dsrId;
  final String productName;
  final double productPrice;
  final double quantity;
  final double stockBalance;
  final double totalAmount;
  final int status;
  final DateTime date;
  const SummarySaleItem({
    Key? key,
    required this.id,
    required this.productId,
    required this.dsrId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.stockBalance,
    required this.totalAmount,
    required this.status,
    required this.date,
  }) : super(key: key);

  @override
  State<SummarySaleItem> createState() => _SummarySaleItemState();
}

class _SummarySaleItemState extends State<SummarySaleItem> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));

    return Slidable(
      enabled: widget.status == 0,
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              final TextEditingController quantityController =
                  TextEditingController();
              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

              confirmWithContent(
                  context,
                  DialogBody(
                    productId: widget.productId,
                    dsrId: widget.dsrId,
                    productName: widget.productName,
                    formKey: formKey,
                    quantityController: quantityController,
                    productQuantity: widget.quantity,
                    stockBalance: widget.stockBalance,
                  ), onConfirm: () async {
                if (formKey.currentState!.validate()) {
                  await editSummarySale(context,
                      id: widget.id,
                      itemName: widget.productName,
                      itemQty: double.parse(quantityController.text.trim()),
                      itemPrice: widget.productPrice,
                      dsrId: context.read<LoginProvider>().currentUser.id!,
                      date: DateFormat('yyyy-MM-dd').format(widget.date));
                  Navigator.pop(context);
                  return;
                }
              }, okText: 'Edit');
            },
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0)),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              confirm(
                context,
                'Delete ${widget.productName}?',
                onConfirm: () async {
                  await deleteSummarySale(context, widget.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                okText: 'Delete',
              );
            },
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: Material(
        shape: _shapeBorder,
        elevation: 2.0,
        child: ListTile(
          title: Text(
            widget.productName,
            style: TextStyle(
                color: Color.fromRGBO(97, 97, 97, 1),
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          trailing: widget.status == 0
              ? Icon(Icons.keyboard_double_arrow_left_rounded)
              : null,
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  numberUnit(widget.quantity),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  '  ->  ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  price(widget.totalAmount),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          shape: _shapeBorder,
        ),
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final int dsrId;
  final int productId;
  final String productName;
  final double productQuantity;
  final double stockBalance;
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  const DialogBody({
    Key? key,
    required this.dsrId,
    required this.productId,
    required this.productName,
    required this.quantityController,
    required this.formKey,
    required this.productQuantity,
    required this.stockBalance,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
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
            decoration: InputDecoration(
              prefixText: '${number(widget.productQuantity)} to ',
              labelText: 'Changing quantity',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            onFieldSubmitted: (qty) async {
              if (widget.formKey.currentState!.validate()) {
                return;
              }
            },
            validator: (qty) {
              if (qty!.trim().isEmpty) {
                return 'Quantity is required!';
              } else {
                if (double.parse(qty.trim()) <= 0) {
                  return 'Invalid quantity!';
                } else if (double.parse(qty.trim()) > widget.stockBalance) {
                  return 'Maximum quantity ${number(widget.stockBalance)} is exceeded!';
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
