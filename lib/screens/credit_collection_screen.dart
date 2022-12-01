import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/credit_collection_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreditCollectionScreen extends StatefulWidget {
  final selectedDate;
  const CreditCollectionScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<CreditCollectionScreen> createState() => _CreditCollectionScreenState();
}

class _CreditCollectionScreenState extends State<CreditCollectionScreen> {
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
            Text('Credited Collection on'),
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
                  dsrProvider.deleteAllCreditCollection();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: dsrProvider.creditCollectionList.isNotEmpty,
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
              final TextEditingController _customerController =
                  TextEditingController();
              final TextEditingController _amountController =
                  TextEditingController();
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              confirmWithContent(
                  context,
                  DialogBody(
                      customerController: _customerController,
                      amountController: _amountController,
                      formKey: _formKey), onConfirm: () async {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<DSRProvider>()
                      .addCreditCollection(CreditCollectionItem(
                        customertName: _customerController.text.trim(),
                        creditAmount:
                            double.parse(_amountController.text.trim()),
                      ));
                  _customerController.clear();
                  _amountController.clear();
                  toast(
                      msg: 'A credit collection is added',
                      toastStatus: TS.SUCCESS,
                      toastLength: Toast.LENGTH_LONG);
                  return;
                }
              }, okText: 'Add');
            },
            child: Icon(
              Icons.add,
              color: Colors.pink[900],
            ),
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              if (context.read<DSRProvider>().creditCollectionList.isNotEmpty) {
                confirm(context, 'Approve this credit collection?',
                    onConfirm: () async {
                  await sendCC(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No credit collections to approve!',
                    toastStatus: TS.ERROR,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
      body: Consumer<DSRProvider>(
        builder: (context, data, child) => data.creditCollectionList.isEmpty
            ? NodataScreen(title: 'No credit collection yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.creditCollectionList.length,
                    itemBuilder: (context, index) {
                      return data.creditCollectionList[index];
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
  final TextEditingController customerController;
  final TextEditingController amountController;
  final GlobalKey<FormState> formKey;
  const DialogBody({
    Key? key,
    required this.customerController,
    required this.amountController,
    required this.formKey,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  FocusNode _amountFocus = FocusNode();

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
              'Add Credit Collection',
              textAlign: TextAlign.center,
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
                _amountFocus.requestFocus();
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: widget.amountController,
              focusNode: _amountFocus,
              validator: (amount) {
                if (amount!.trim().isEmpty) {
                  return 'Amount is required!';
                } else if (double.parse(amount.trim()) <= 0) {
                  return 'Invalid amount!';
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
            ),
          ],
        ),
      ),
    );
  }
}
