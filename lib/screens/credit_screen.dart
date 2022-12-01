import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/credit_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreditScreen extends StatefulWidget {
  final selectedDate;
  const CreditScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  @override
  Widget build(BuildContext context) {
    DSRProvider dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            bool visibility = snapshot.hasData &&
                !(snapshot.data == ConnectivityResult.mobile ||
                    snapshot.data == ConnectivityResult.wifi);

            return Visibility(
              visible: visibility,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 30.0,
                color: Colors.red,
                child: Text(
                  'No connection!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Column(
          children: [
            Text('Credited Money on'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            onSelected: (index) {
              if (index == 0) {
                confirm(context, 'Remove all items?', onConfirm: () async {
                  dsrProvider.deleteAllCredits();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: dsrProvider.creditList.isNotEmpty,
                value: 0,
                child: Text(
                  'Remove all',
                ),
              ),
            ],
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              final TextEditingController _amountController =
                  TextEditingController();
              final TextEditingController _customerController =
                  TextEditingController();
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              confirmWithContent(
                  context,
                  DialogBody(
                      amountController: _amountController,
                      customerController: _customerController,
                      formKey: _formKey), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<DSRProvider>().addCredit(CreditItem(
                        customertName: _customerController.text.trim(),
                        creditAmount:
                            double.parse(_amountController.text.trim()),
                      ));
                  _amountController.clear();
                  _customerController.clear();
                  toast(
                      msg: 'A credit is added',
                      toastStatus: TS.SUCCESS,
                      toastLength: Toast.LENGTH_LONG);
                  return;
                }
              }, okText: 'Add');
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Colors.pink[900],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              if (context.read<DSRProvider>().creditList.isNotEmpty) {
                confirm(context, 'Approve this credit?', onConfirm: () async {
                  await sendCredit(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No credits to approve!',
                    toastStatus: TS.ERROR,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.done,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Consumer<DSRProvider>(
        builder: (context, data, child) => data.creditList.isEmpty
            ? NodataScreen(title: 'No crediting yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.creditList.length,
                    itemBuilder: (context, index) {
                      return data.creditList[index];
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        )),
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
              'Add Credit',
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
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            DropdownButtonHideUnderline(
              child: FutureBuilder<List<Product>>(
                future: getProducts(),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) =>
                    DropdownButtonFormField<Product>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
                    labelText:
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading...'
                            : (snapshot.hasData && snapshot.data!.isNotEmpty
                                ? 'Select Product'
                                : 'Failed!'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  items: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data!
                          .map(
                            (product) => DropdownMenuItem(
                              value: product,
                              child: Text(
                                product.name.length > 20
                                    ? product.name.substring(0, 20)
                                    : product.name,
                              ),
                            ),
                          )
                          .toList()
                      : null,
                  onChanged: (newValue) {
                    // widget.callBack(newValue);
                  },
                ),
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
