import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/bank.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/direct_banking_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DirectBankingScreen extends StatefulWidget {
  final selectedDate;
  const DirectBankingScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<DirectBankingScreen> createState() => _DirectBankingScreenState();
}

class _DirectBankingScreenState extends State<DirectBankingScreen> {
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
            Text('Direct Banked Money on'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              dsrProvider.setSelectableBanking(false);
              dsrProvider.deselectAllDirectBanking();
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          PopupMenuButton(
            onSelected: (index) {
              if (index == 0) {
                confirm(context, 'Remove all items?', onConfirm: () async {
                  dsrProvider.deleteAllDirectBankings();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: dsrProvider.directBankingList.isNotEmpty,
                value: 0,
                child: Text(
                  'Remove all',
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              TextEditingController _amountController = TextEditingController();
              TextEditingController _refnoController = TextEditingController();
              TextEditingController _customerController =
                  TextEditingController();
              Bank _dropdownValue = Bank(id: 3, bank_name: 'Sampath Bank');
              GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              callBack(Bank dropdownValue) {
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
                  dsrProvider.addDirectBanking(
                    DirectBankingItem(
                      customertName: _customerController.text.trim(),
                      bankedAmount: double.parse(_amountController.text.trim()),
                      bank: _dropdownValue.bank_name,
                      refno: _refnoController.text.trim(),
                    ),
                  );
                  _amountController.clear();
                  _refnoController.clear();
                  _customerController.clear();
                  toast(
                      msg: 'A direct banking is added',
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
              if (dsrProvider.directBankingList.isNotEmpty) {
                confirm(context, 'Approve this direct banking?',
                    onConfirm: () async {
                  await sendDirectBanking(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No D:Bankings to approve!',
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
        builder: (context, data, child) => data.directBankingList.isEmpty
            ? NodataScreen(title: 'No direct banking yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.directBankingList.length,
                    itemBuilder: (context, index) {
                      return data.directBankingList[index];
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
  final TextEditingController refnoController;
  final TextEditingController customerController;
  final GlobalKey<FormState> formKey;
  Bank dropdownValue;
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
              'Add Direct Banking',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            DropdownButtonHideUnderline(
              child: FutureBuilder<List<Bank>>(
                future: getBanks(),
                builder: (context, AsyncSnapshot<List<Bank>> snapshot) =>
                    DropdownButtonFormField<Bank>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  value: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data![2]
                      : null,
                  decoration: InputDecoration(
                    labelText:
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading...'
                            : (snapshot.hasData && snapshot.data!.isNotEmpty
                                ? 'Select Bank'
                                : 'Failed!'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  items: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data!
                          .map((bank) => DropdownMenuItem(
                                value: bank,
                                child: Text(bank.bank_name),
                              ))
                          .toList()
                      : null,
                  onChanged: (newValue) {
                    widget.callBack(newValue);
                  },
                ),
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
