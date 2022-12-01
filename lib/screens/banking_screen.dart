import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/bank.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/banking_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BankingScreen extends StatefulWidget {
  final selectedDate;
  const BankingScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> {
  @override
  Widget build(BuildContext context) {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
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
            Text('Banked Money on'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (index) {
              if (index == 0) {
                confirm(context, 'Remove all items?', onConfirm: () async {
                  _dsrProvider.deleteAllBankings();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                enabled: _dsrProvider.bankingList.isNotEmpty,
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
              Bank _dropdownValue = Bank(id: 3, bank_name: 'Sampath Bank');
              final TextEditingController _amountController =
                  TextEditingController();
              final TextEditingController _refnoController =
                  TextEditingController();
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

              callBack(Bank dropdownValue) {
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
                  context.read<DSRProvider>().addBanking(BankingItem(
                        bName: _dropdownValue.bank_name,
                        bId: _dropdownValue.id,
                        amount: double.parse(_amountController.text.trim()),
                        refno: _refnoController.text.trim(),
                      ));
                  _amountController.clear();
                  _refnoController.clear();
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
              if (context.read<DSRProvider>().bankingList.isNotEmpty) {
                confirm(context, 'Approve this banking?', onConfirm: () async {
                  await sendBanking(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No bankings to approve!',
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
        builder: (context, data, child) => data.bankingList.isEmpty
            ? NodataScreen(title: 'No banking yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.bankingList.length,
                    itemBuilder: (context, index) {
                      return data.bankingList[index];
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
  Bank dropdownValue;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Banking',
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
                  child: FutureBuilder<List<Bank>>(
                    future: getBanks(),
                    builder: (context, AsyncSnapshot<List<Bank>> snapshot) => DropdownButtonFormField<Bank>(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0),),),
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
                  onFieldSubmitted: (_) {
                    if (widget.formKey.currentState!.validate()) {
                      context.read<DSRProvider>().addBanking(BankingItem(
                            bName: widget.dropdownValue.bank_name,
                            bId: widget.dropdownValue.id,
                            amount:
                                double.parse(widget.amountController.text.trim()),
                            refno: widget.refnoController.text.trim(),
                          ));
                      widget.amountController.clear();
                      widget.refnoController.clear();
                      return;
                    }
                  },
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
      ),
    );
  }
}
