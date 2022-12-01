import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dsr_app/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SummaryBankingItem extends StatefulWidget {
  final int id;
  final int sumId;
  final String bankName;
  final double amount;
  final String refno;
  final int status;
  const SummaryBankingItem(
      {Key? key,
      required this.id,
      required this.sumId,
      required this.bankName,
      required this.amount,
      required this.refno,
      required this.status})
      : super(key: key);

  @override
  State<SummaryBankingItem> createState() => _SummaryBankingItemState();
}

class _SummaryBankingItemState extends State<SummaryBankingItem> {
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
              String _dropdownValue = widget.bankName;
              final TextEditingController _amountController =
                  TextEditingController(text: number(widget.amount));
              final TextEditingController _refnoController =
                  TextEditingController(text: widget.refno);
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              callBack(String dropdownValue) {
                _dropdownValue = dropdownValue;
              }

              confirmWithContent(
                  context,
                  DialogBody(
                    dropdownValue: _dropdownValue,
                    amountController: _amountController,
                    refnoController: _refnoController,
                    formKey: _formKey,
                    callBack: callBack,
                  ), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  await editSummaryBanking(
                    context,
                    id: widget.id,
                    sumId: widget.sumId,
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
              confirm(context, 'Delete this banking?', onConfirm: () async {
                await deleteSummaryBanking(
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
            widget.bankName,
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
          trailing: widget.status == 0
              ? Icon(Icons.keyboard_double_arrow_left_rounded)
              : null,
          shape: _shapeBorder,
          tileColor: Colors.white,
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
  String dropdownValue;
  final TextEditingController amountController;
  final TextEditingController refnoController;
  final GlobalKey<FormState> formKey;
  final Function callBack;
  DialogBody({
    Key? key,
    required this.dropdownValue,
    required this.amountController,
    required this.refnoController,
    required this.formKey,
    required this.callBack,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final FocusNode _refnoFocus = FocusNode();

  final items = const [
    'Sampath Bank',
    'People\'s Bank',
    'Cargills Bank',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Edit Banking',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        SizedBox(
          height: 10.0,
        ),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
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
                  } else if (double.parse(amount.trim()) < 0) {
                    return 'Invalid amount!';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (_) {
                  _refnoFocus.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
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
                onFieldSubmitted: (_) {},
                decoration: InputDecoration(
                  labelText: 'Ref No:',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
