import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/widgets/summary_retailer_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'nosummary_screen.dart';

class SummaryRetailerScreen extends StatefulWidget {
  final selectedDate;
  const SummaryRetailerScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<SummaryRetailerScreen> createState() => _SummaryRetailerScreenState();
}

class _SummaryRetailerScreenState extends State<SummaryRetailerScreen> {
  Future<List<SummaryRetailerItem>> _loadRetailer(BuildContext context) async {
    List<SummaryRetailerItem> creditList = [];
    final int status = context.read<DSRProvider>().status;
    try {
      final response =
          await Dio().post('$baseUrl/mobile_get_retailer_summary', data: {
        "dsr_id": context.read<LoginProvider>().currentUser.id,
        "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
      });
      if (response.statusCode == 200) {
        List dataList = response.data['data']['info'];
        if (dataList.isNotEmpty) {
          for (var data in dataList) {
            final id = int.parse(data['id'].toString());
            final respo = await Dio().post('$baseUrl/mobile_getItems_byId',
                data: {"item_id": data['item_id']});
            Product product = Product.fromJson(respo.data['data']['info'][0]);
            creditList.add(SummaryRetailerItem(
                id: id,
                customertName: data['re_customer_name'].toString(),
                itemCount: double.parse(data['item_count'].toString()),
                itemName: product.name,
                status: status,
                itemId: product.id,
                itemPrice: product.selling_price));
          }
        }
      }
    } on Exception catch (e) {
      toast(msg: 'Retailer returns load failed!');
    }

    return Future.value(creditList);
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
            Text('R:Return summary on'),
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
          future: _loadRetailer(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NosummaryScreen(
                        title: 'No retailer returns!',
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
                return NosummaryScreen(title: 'No retailer returns!');
              }
            }
          }),
    );
  }
}
