import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/models/product_qty.dart';
import 'package:dsr_app/models/stock.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  final selectedDate;
  const SalesScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
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
            Text('Sales on'),
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
                  dsrProvider.deleteAllProducts();
                  Navigator.pop(context);
                }, okText: 'Remove all');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: dsrProvider.productList.isNotEmpty,
                value: 0,
                child: Text(
                  'Remove all',
                  style: TextStyle(
                      color: dsrProvider.productList.isNotEmpty
                          ? Colors.red[900]
                          : Colors.grey),
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
              final TextEditingController _quantityController =
                  TextEditingController();
              final GlobalKey<FormState> formKey = GlobalKey<FormState>();
              ProductQty? _dropdownValue;
              List<int> _stockIds = [];
              double _quantity = _quantityController.text.trim().isNotEmpty
                  ? double.parse(_quantityController.text.trim())
                  : 0.0;

              callBack(ProductQty dropdownValue, List<int> stockIds) {
                _dropdownValue = dropdownValue;
                _stockIds = stockIds;
              }

              confirmWithContent(
                  context,
                  DialogBody(
                    formKey: formKey,
                    dsrId: context.read<LoginProvider>().currentUser.id!,
                    quantityController: _quantityController,
                    callBack: callBack,
                    dropdownValue: _dropdownValue,
                  ),
                  okText: 'Add', onConfirm: () async {
                if (formKey.currentState!.validate()) {
                  dsrProvider.addProduct(ProductItem(
                      productId: _dropdownValue!.product.id,
                      stockIds: _stockIds,
                      productName: _dropdownValue!.product.name,
                      productPrice: _dropdownValue!.product.selling_price,
                      productQuantity:
                          double.parse(_quantityController.text.trim())));
                  dsrProvider.setTotalSale(dsrProvider.totalSale +
                      _quantity * _dropdownValue!.product.selling_price);
                  _quantityController.clear();
                  return;
                }
              });
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
              if (dsrProvider.productList.isNotEmpty) {
                confirm(context, 'Approve this sale?', onConfirm: () async {
                  await sendSale(context, widget.selectedDate);
                  Navigator.pop(context);
                }, okText: 'Approve');
              } else {
                toast(
                    msg: 'No sales to approve!',
                    toastStatus: TS.ERROR,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
          )
        ],
      ),
      body: Consumer<DSRProvider>(
        builder: (context, data, child) => data.productList.isEmpty
            ? NodataScreen(title: 'No sales yet...')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: data.productList.length,
                    itemBuilder: (context, index) {
                      return data.productList[index];
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
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  final int dsrId;
  final Function callBack;
  ProductQty? dropdownValue;
  DialogBody({
    Key? key,
    required this.quantityController,
    required this.formKey,
    required this.dsrId,
    required this.callBack,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  late final Future<List<DropdownMenuItem<ProductQty>>> items;
  List<int> stockIds = [];
  final FocusNode quantityFocus = FocusNode();

  @override
  void initState() {
    items = _loadItems(context);
    super.initState();
  }

  Future<List<DropdownMenuItem<ProductQty>>> _loadItems(
      BuildContext context) async {
    List<DropdownMenuItem<ProductQty>> itemList = [];

    try {
      final productResponse = await Dio().post('$baseUrl/mobile_get_item_count',
          data: {"dsr_id": context.read<LoginProvider>().currentUser.id});
      List list = productResponse.data['data']['info'];
      for (final respo in list) {
        double qty = double.parse(respo['qty_sum'].toString());

        if (qty > 0.0) {
          var productResponse = await Dio().post(
              '$baseUrl/mobile_getItems_byId',
              data: {"item_id": respo['item_id']});
          Product product =
              Product.fromJson(productResponse.data['data']['info'][0]);
          itemList.add(DropdownMenuItem(
            value: ProductQty(product, qty),
            child: Text(product.name),
          ));
        }
      }
    } on Exception catch (e) {
      toast(msg: 'Items loading failed!', toastStatus: TS.ERROR);
    }
    return itemList;
  }

  Future _loadStocks(ProductQty dropdownValue) async {
    stockIds.clear();
    try {
      final stockResponse = await Dio().post('$baseUrl/mobile_get_dsr_stockIds',
          data: {"dsr_id": widget.dsrId, "item_id": dropdownValue.product.id});
      if (stockResponse.statusCode == 200) {
        List list = stockResponse.data['data']['info'];
        for (var stock in list) {
          Stock stk = Stock.fromJson(stock);
          stockIds.add(stk.stock_id);
        }
        widget.callBack(dropdownValue, stockIds);
      }
    } on Exception catch (e) {
      toast(msg: 'Stocks loading error!', toastStatus: TS.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    DSRProvider dsrProvider = Provider.of<DSRProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add Sales',
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
              FutureBuilder(
                  future: items,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<ProductQty>(
                            validator: (value) {
                              return value == null
                                  ? 'Please select an item'
                                  : null;
                            },
                            decoration: InputDecoration(
                              labelText: snapshot.data.isNotEmpty
                                  ? 'Select item'
                                  : 'No items available',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: snapshot.data,
                            onChanged: (newValue) async {
                              await _loadStocks(newValue!);
                              widget.quantityController.clear();
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: quantityFocus,
                controller: widget.quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onFieldSubmitted: (qty) {
                  if (widget.formKey.currentState!.validate()) {
                    dsrProvider.addProduct(ProductItem(
                        productId: widget.dropdownValue!.product.id,
                        stockIds: stockIds,
                        productName: widget.dropdownValue!.product.name,
                        productPrice:
                            widget.dropdownValue!.product.selling_price,
                        productQuantity: double.parse(
                            widget.quantityController.text.trim())));
                    dsrProvider.setTotalSale(dsrProvider.totalSale +
                        double.parse(widget.quantityController.text.trim()) *
                            widget.dropdownValue!.product.selling_price);
                    widget.quantityController.clear();
                    return;
                  }
                },
                validator: (qty) {
                  if (qty!.trim().isEmpty) {
                    return 'Quantity is required!';
                  } else {
                    if (double.parse(qty.trim()) <= 0) {
                      return 'Invalid quantity!';
                    } else if (widget.dropdownValue != null &&
                        double.parse(qty.trim()) >
                            widget.dropdownValue!.productQty) {
                      return 'Quantity exceeded!';
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
