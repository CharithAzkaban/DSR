import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/balance_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'nodata_screen.dart';

class StockBalanceScreen extends StatefulWidget {
  const StockBalanceScreen({Key? key}) : super(key: key);

  @override
  State<StockBalanceScreen> createState() => _StockBalanceScreenState();
}

class _StockBalanceScreenState extends State<StockBalanceScreen> {
  Future loadBalance(BuildContext context) async {
    List<BalanceItem> _balanceList = [];
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final response = await Dio().post('$baseUrl/mobile_get_item_count',
        data: {"dsr_id": await loginProvider.loggedinUser()});
    List balanceList = response.data['data']['info'];
    for (dynamic respo in balanceList) {
      double qty = double.parse(respo['qty_sum'].toString());

      if (qty > 0.0) {
        var productResponse = await Dio().post('$baseUrl/mobile_getItems_byId',
            data: {"item_id": respo['item_id']});

        Product product =
            Product.fromJson(productResponse.data['data']['info'][0]);
        _balanceList.add(BalanceItem(
          productId: product.id,
          productName: product.name,
          productPrice: product.selling_price,
          productQuantity: double.parse(respo['qty_sum'].toString()),
          returnedQty: respo['return_qty'] != null
              ? double.parse(respo['return_qty'].toString())
              : 0,
          
        ));
      }
    }
    return _balanceList;
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Balance for today'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                toast(
                    msg: 'Refreshing...',
                    toastStatus: TS.REGULAR,
                    toastLength: Toast.LENGTH_LONG);
              });
            },
            icon: Icon(Icons.refresh_rounded),
            splashRadius: 20.0,
          )
        ],
      ),
      body: FutureBuilder(
          future: loadBalance(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NodataScreen(
                        title: 'No items available!',
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                snapshot.data[index],
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10.0,
                                ),
                            itemCount: snapshot.data.length),
                      );
              } else {
                return NodataScreen(title: 'No items available!');
              }
            }
          }),
    );
  }
}
