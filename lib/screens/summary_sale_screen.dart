import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/widgets/summary_sale_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'nosummary_screen.dart';

class SummarySalesScreen extends StatefulWidget {
  final DateTime selectedDate;
  const SummarySalesScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<SummarySalesScreen> createState() => _SummarySalesScreenState();
}

class _SummarySalesScreenState extends State<SummarySalesScreen> {
  Future loadSummary(BuildContext context) async {
    List<SummarySaleItem> _summaryList = [];
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final int dsrId = loginProvider.currentUser.id!;
    final int status = context.read<DSRProvider>().status;
    final response =
        await Dio().post('$baseUrl/mobile_get_sale_summary', data: {
      "dsr_id": await loginProvider.loggedinUser(),
      "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
    });
    List summaryList = response.data['data']['info'];
    for (dynamic respo in summaryList) {
      final id = int.parse(respo['id'].toString());
      final stockBalance = double.parse(respo['stock_balance'].toString());
      final summaryResponse = await Dio().post('$baseUrl/mobile_getItems_byId',
          data: {"item_id": respo['item_id']});

      Product product =
          Product.fromJson(summaryResponse.data['data']['info'][0]);
      _summaryList.add(SummarySaleItem(
        id: id,
        date: widget.selectedDate,
        productId: product.id,
        dsrId: dsrId,
        productName: product.name,
        stockBalance: stockBalance,
        productPrice: product.selling_price,
        quantity: double.parse(respo['qty'].toString()),
        totalAmount: double.parse(respo['sub_total'].toString()),
        status: status,
      ));
    }

    return _summaryList;
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
            Text('Sales summary on'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
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
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: loadSummary(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NosummaryScreen(
                        title: 'No sales!',
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
                return NosummaryScreen(title: 'No sales!');
              }
            }
          }),
    );
  }
}
