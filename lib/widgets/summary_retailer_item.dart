import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SummaryRetailerItem extends StatefulWidget {
  final int id;
  final int itemId;
  final String customertName;
  final String itemName;
  final double itemCount;
  final double itemPrice;
  final int status;
  const SummaryRetailerItem(
      {Key? key,
      required this.id,
      required this.itemId,
      required this.customertName,
      required this.itemName,
      required this.itemCount,
      required this.itemPrice,
      required this.status})
      : super(key: key);

  @override
  State<SummaryRetailerItem> createState() => _SummaryRetailerItemState();
}

class _SummaryRetailerItemState extends State<SummaryRetailerItem> {
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
              final TextEditingController _customerController =
                  TextEditingController(text: widget.customertName);
              final TextEditingController _quantityController =
                  TextEditingController(text: number(widget.itemCount));
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              confirmWithContent(
                  context,
                  DialogBody(
                      customerController: _customerController,
                      quantityController: _quantityController,
                      formKey: _formKey,
                      productName: widget.itemName), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  await editSummaryRetailer(
                    context,
                    id: widget.id,
                    reCustomerName: _customerController.text.trim(),
                    reItemId: widget.itemId,
                    reQuantity: double.parse(_quantityController.text.trim()),
                    reAmount: widget.itemPrice,
                  );
                  Navigator.pop(context);
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
              confirm(context, 'Delete this item?', onConfirm: () async {
                await deleteSummaryRetailer(context, widget.id);
                Navigator.pop(context);
                Navigator.pop(context);
              }, okText: 'Delete');
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
            widget.customertName,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  widget.itemName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  numberUnit(widget.itemCount),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          trailing: widget.status == 0
              ? Icon(Icons.keyboard_double_arrow_left_rounded)
              : null,
          shape: _shapeBorder,
          tileColor: Colors.white,
        ),
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final TextEditingController customerController;
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  final String productName;
  DialogBody({
    Key? key,
    required this.customerController,
    required this.quantityController,
    required this.formKey,
    required this.productName,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final FocusNode _productFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.productName,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: widget.customerController,
              validator: (customer) {
                if (customer!.trim().isEmpty) {
                  return 'Customer is required!';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                _productFocus.requestFocus();
              },
              decoration: InputDecoration(
                labelText: 'Customer',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: widget.quantityController,
              focusNode: _quantityFocus,
              validator: (qty) {
                if (qty!.trim().isEmpty) {
                  return 'Quantity is required!';
                } else if (double.parse(qty.trim()) <= 0) {
                  return 'Invalid quantity!';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
