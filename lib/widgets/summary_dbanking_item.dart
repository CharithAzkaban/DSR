import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SummaryDBankingItem extends StatefulWidget {
  final int id;
  final int sumId;
  final String bankName;
  final String customerName;
  final double amount;
  final String refno;
  final int status;
  const SummaryDBankingItem(
      {Key? key,
      required this.id,
      required this.sumId,
      required this.bankName,
      required this.customerName,
      required this.amount,
      required this.refno,
      required this.status})
      : super(key: key);

  @override
  State<SummaryDBankingItem> createState() => _SummaryDBankingItemState();
}

class _SummaryDBankingItemState extends State<SummaryDBankingItem> {
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
              TextEditingController _amountController =
                  TextEditingController(text: number(widget.amount));
              TextEditingController _refnoController =
                  TextEditingController(text: widget.refno);
              TextEditingController _customerController =
                  TextEditingController(text: widget.customerName);
              String _dropdownValue = widget.bankName;
              GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              callBack(String dropdownValue) {
                _dropdownValue = dropdownValue;
              }

              confirmWithContent(
                  context,
                  DialogBody(
                    amountController: _amountController,
                    callBack: callBack,
                    customerController: _customerController,
                    dropdownValue: _dropdownValue,
                    formKey: _formKey,
                    refnoController: _refnoController,
                  ), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  await editSummaryDBanking(
                    context,
                    id: widget.id,
                    sumId: widget.sumId,
                    customerName: _customerController.text.trim(),
                    bank: _dropdownValue,
                    refno: _refnoController.text.trim(),
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
              confirm(context, 'Delete this direct banking?',
                  onConfirm: () async {
                await deleteSummaryDBanking(
                  context,
                  id: widget.id,
                  sumId: widget.sumId,
                  bankName: widget.bankName,
                );
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
            widget.customerName,
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
                  price(widget.amount),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 20.0,
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
          tileColor: Colors.white,
          trailing: widget.status == 0
              ? Icon(Icons.keyboard_double_arrow_left_rounded)
              : null,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Image.asset(
                'assets/${widget.bankName == 'Sampath Bank' ? 'sampath.png' : widget.bankName == 'People\'s Bank' ? 'peoples.png' : 'cargills.png'}'),
          ),
        ),
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController refnoController;
  final TextEditingController customerController;
  final GlobalKey<FormState> formKey;
  String dropdownValue;
  final Function callBack;
  DialogBody({
    Key? key,
    required this.amountController,
    required this.refnoController,
    required this.customerController,
    required this.formKey,
    required this.dropdownValue,
    required this.callBack,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final items = [
    'Sampath Bank',
    'People\'s Bank',
    'Cargills Bank',
  ];

  FocusNode _refnoFocus = FocusNode();
  FocusNode _customerFocus = FocusNode();
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Edit Direct Banking',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: widget.dropdownValue,
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  labelText: 'Bank',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (newValue) {
                  widget.callBack(newValue);
                  setState(() {
                    widget.dropdownValue = newValue!;
                  });
                },
              ),
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
                  return 'Invalid amount';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixText: 'Rs. ',
                labelText: 'Amount',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              onFieldSubmitted: (_) {
                _refnoFocus.requestFocus();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: widget.refnoController,
              focusNode: _refnoFocus,
              validator: (refno) {
                if (refno!.trim().isEmpty) {
                  return 'Ref No: is required!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Ref No:',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              onFieldSubmitted: (_) {
                _customerFocus.requestFocus();
              },
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
