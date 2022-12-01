import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SummaryCreditItem extends StatefulWidget {
  final int id;
  final String customertName;
  final double creditAmount;
  final int status;
  const SummaryCreditItem(
      {Key? key,
      required this.id,
      required this.customertName,
      required this.creditAmount,
      required this.status})
      : super(key: key);

  @override
  State<SummaryCreditItem> createState() => _SummaryCreditItemState();
}

class _SummaryCreditItemState extends State<SummaryCreditItem> {
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
              final TextEditingController _amountController =
                  TextEditingController(text: number(widget.creditAmount));
              final TextEditingController _customerController =
                  TextEditingController(text: widget.customertName);
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              confirmWithContent(
                  context,
                  DialogBody(
                      amountController: _amountController,
                      customerController: _customerController,
                      formKey: _formKey), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  await editSummaryCredit(
                    context,
                    id: widget.id,
                    customerName: _customerController.text.trim(),
                    amount: double.parse(_amountController.text.trim()),
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
              confirm(context, 'Delete this credit?', onConfirm: () async {
                await deleteSummaryCredit(context, widget.id);
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
            child: Text(
              price(widget.creditAmount),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
  final TextEditingController amountController;
  final TextEditingController customerController;
  final GlobalKey<FormState> formKey;
  const DialogBody({
    Key? key,
    required this.amountController,
    required this.customerController,
    required this.formKey,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  FocusNode _customerFocus = FocusNode();

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
              'Edit Credit',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: widget.amountController,
              validator: (amount) {
                if (amount!.trim().isEmpty) {
                  return 'Amount is required!';
                } else if (double.parse(amount.trim()) <= 0) {
                  return 'Invalid amount!';
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (_) {
                _customerFocus.requestFocus();
              },
              decoration: InputDecoration(
                prefixText: 'Rs. ',
                labelText: 'Amount',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: widget.customerController,
              focusNode: _customerFocus,
              validator: (customer) {
                if (customer!.trim().isEmpty) {
                  return 'Customer is required!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Customer',
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
