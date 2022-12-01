import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/nodata_screen.dart';
import 'package:dsr_app/widgets/stock_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'view_issue_screen.dart';

class AcceptStockScreen extends StatefulWidget {
  const AcceptStockScreen({Key? key}) : super(key: key);

  @override
  State<AcceptStockScreen> createState() => _AcceptStockScreenState();
}

class _AcceptStockScreenState extends State<AcceptStockScreen> {
  Future loadIssue(BuildContext context) async {
    List<StocktItem> _issuedList = [];
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final response = await Dio().post('$baseUrl/mobile_dsr_stock',
        data: {"id": await loginProvider.loggedinUser()});
    List issuedList = response.data['data']['info'];
    for (dynamic respo in issuedList) {
      List items = respo['items'];
      if (items.isNotEmpty) {
        _issuedList.add(StocktItem(
          date: DateTime.parse(respo['bulk_created_at']),
          items: respo['items'],
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => IssuedItemsScreen(
                          items: respo['items'],
                          issued_at: DateTime.parse(respo['bulk_created_at']),
                          stockId: int.parse(respo['bulk_id'].toString()),
                        )))
                .then((value) => setState(() {}));
          },
        ));
      }
    }
    return _issuedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Issued stocks'),
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
      body: FutureBuilder(
          future: loadIssue(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NodataScreen(
                        title: 'No issued stocks!',
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
                return NodataScreen(title: 'No issued stocks!');
              }
            }
          }),
    );
  }
}
