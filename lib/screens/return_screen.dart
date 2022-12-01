import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/return_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReturnScreen extends StatefulWidget {
  final selectedDate;
  const ReturnScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
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
            Text('Retailer returns on'),
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
                confirm(context, 'Remove all items?', onConfirm: () async{
                  dsrProvider.deleteAllReturns();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: dsrProvider.returnList.isNotEmpty,
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
              final TextEditingController _quantityController =
                  TextEditingController();
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
              Product? _dropdownValue;

              callBack(Product dropdownValue) {
                _dropdownValue = dropdownValue;
              }

              confirmWithContent(
                  context,
                  DialogBody(
                      customerController: _customerController,
                      quantityController: _quantityController,
                      formKey: _formKey,
                      callBack: callBack), onConfirm: () async{
                if (_formKey.currentState!.validate()) {
                  context.read<DSRProvider>().addReturn(ReturnItem(
                        customertName: _customerController.text.trim(),
                        productName: _dropdownValue!.name,
                        productId: _dropdownValue!.id,
                        amount: _dropdownValue!.selling_price,
                        quantity: double.parse(_quantityController.text.trim()),
                      ));
                  _customerController.clear();
                  _quantityController.clear();
                  toast(
                      msg: 'A return is added',
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
              if (context.read<DSRProvider>().returnList.isNotEmpty) {
                confirm(context, 'Approve this return?', onConfirm: () async {
                  await sendReturn(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No R:Returns to approve!',
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
        builder: (context, data, child) => data.returnList.isEmpty
            ? NodataScreen(title: 'No retailer returns yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.returnList.length,
                    itemBuilder: (context, index) {
                      return data.returnList[index];
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
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  final Function callBack;
  Product? dropdownValue;
  DialogBody({
    Key? key,
    required this.customerController,
    required this.quantityController,
    required this.formKey,
    required this.callBack,
    this.dropdownValue,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final FocusNode _productFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  late final Future<List<DropdownMenuItem<Product>>> items;

  Future<List<DropdownMenuItem<Product>>> _loadItems() async {
    List<DropdownMenuItem<Product>> itemList = [];
    try {
      final productResponse =
          await Dio().post('$baseUrl/mobile_getItems', data: {});
      List list = productResponse.data['data']['info'];
      for (final item in list) {
        Product product = Product.fromJson(item);
        itemList.add(DropdownMenuItem(
          value: product,
          child: Text(product.name),
        ));
      }
    } on Exception catch (e) {
      toast(msg: 'Items loading failed!', toastStatus: TS.ERROR);
    }
    return itemList;
  }

  @override
  void initState() {
    items = _loadItems();
    super.initState();
  }

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
              'Add retailer return',
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
            FutureBuilder(
                future: items,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<Product>(
                          validator: (value) {
                            return widget.dropdownValue == null
                                ? 'Please select a product'
                                : null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Select item',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: snapshot.data,
                          onChanged: (newValue) {
                            widget.quantityController.clear();
                            widget.callBack(newValue);
                            setState(() {
                              widget.dropdownValue = newValue;
                            });
                            if (widget.formKey.currentState!.validate()) {
                              return;
                            }
                          },
                        ),
                      );
                    } else {
                      return Text('Items load faled!');
                    }
                  }
                }),
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
