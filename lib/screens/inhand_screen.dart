import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/cheque.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/cheque_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InhandScreen extends StatefulWidget {
  final DateTime selectedDate;
  const InhandScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<InhandScreen> createState() => _InhandScreenState();
}

class _InhandScreenState extends State<InhandScreen> {
  final _chequedFocus = FocusNode();
  final TextEditingController _cashController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double totalCash = 0;
  double totalCheque = 0;
  ValueNotifier<double> subtotal = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    DSRProvider dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
        appBar: AppBar(
          title: Column(
            children: [
              Text('Inhand Money on'),
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: () {
            dsrProvider.setTotalCashInhand(totalCash);
            dsrProvider.setTotalChequeInhand(totalCheque);
            if (formKey.currentState!.validate()) {
              confirm(context, 'Send inhands?', onConfirm: () async {
                await sendInhand(context, widget.selectedDate);
                Navigator.pop(context);
                Navigator.pop(context);
              });
              return;
            }
          },
          child: Icon(Icons.done),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Lottie.asset('assets/inhand.json'),
                      height: 200.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                        controller: _cashController,
                        validator: (cash) {
                          if (cash!.trim().isNotEmpty &&
                              double.parse(cash.trim()) < 0) {
                            return 'Invalid cash amount!';
                          } else {
                            return null;
                          }
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Cash',
                          prefixText: 'Rs. ',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        onFieldSubmitted: (_) {
                          _chequedFocus.requestFocus();
                        },
                        onChanged: (cash) {
                          if (cash.isNotEmpty) {
                            totalCash = double.parse(cash);
                            subtotal.value = totalCash + totalCheque;
                          } else {
                            totalCash = 0;
                            subtotal.value = totalCheque;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Container(
                          width: double.infinity,
                          height: 60.0,
                          child: OutlinedButton(
                              onPressed: () {
                                final chequeNumberController = TextEditingController();
                                final chequeAmountController = TextEditingController();
                                final formKey = GlobalKey<FormState>();

                                confirmWithContent(
                                  context, 
                                  DialogBody(
                                    chequeNumberController: chequeNumberController, 
                                    chequeAmountController: chequeAmountController, 
                                    formKey: formKey,
                                  ), 
                                  onConfirm: () async{
                                    if (formKey.currentState!.validate()) {
                                      dsrProvider.addCheque(
                                        Cheque(
                                          cheque_no: chequeNumberController.text.trim(), 
                                          cheque_amount: double.parse(chequeAmountController.text.trim())
                                        )
                                      );
                                      chequeAmountController.clear();
                                      chequeNumberController.clear();
                                    }
                                  },
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                              child: Text(
                                'Add Cheque',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.blue[800]),
                              ))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Consumer<DSRProvider>(
                      builder: (context, data, _) => Column(
                        children: [
                          ...data.chequeList.map((cheque) => Column(
                            children: [
                              ChequedItem(cheque: cheque),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          )).toList(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: subtotal,
                      builder: (context, data, _) => Consumer<DSRProvider>(
                        builder: (context, provider, _) => Text(
                          price(data + provider.getTotalChequeAmount()),
                          style: TextStyle(
                              fontSize: 30.0, 
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  final TextEditingController chequeNumberController;
  final TextEditingController chequeAmountController;
  final GlobalKey<FormState> formKey;
  DialogBody({
    Key? key,
    required this.chequeNumberController,
    required this.chequeAmountController,
    required this.formKey,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final FocusNode amountFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add Cheque',
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
              TextFormField(
                controller: widget.chequeNumberController,
                validator: (cn) {
                  if (cn!.trim().isEmpty) {
                    return 'Cheque number required!';
                  } else if (cn.trim().length != 6) {
                    return 'Invalid cheque number!';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (_) {
                  amountFocus.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: 'Cheque Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: widget.chequeAmountController,
                focusNode: amountFocus,
                validator: (amount) {
                  if (amount!.trim().isEmpty) {
                    return 'Amount is required!';
                  }
                  else if(double.parse(amount.trim()) <= 0){
                    return 'Invalid amount!';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (widget.formKey.currentState!.validate()) {
                    context.read<DSRProvider>().addCheque(
                      Cheque(cheque_no: widget.chequeNumberController.text.trim(), cheque_amount: double.parse(widget.chequeAmountController.text.trim()))
                    );
                    widget.chequeAmountController.clear();
                    widget.chequeNumberController.clear();
                    return;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Cheque Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
