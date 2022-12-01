import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/widgets/summary_dbanking_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'nosummary_screen.dart';

class SummaryDBankingScreen extends StatefulWidget {
  final selectedDate;
  const SummaryDBankingScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<SummaryDBankingScreen> createState() => _SummaryDBankingScreenState();
}

class _SummaryDBankingScreenState extends State<SummaryDBankingScreen> {
  Future<List<SummaryDBankingItem>> _loadDBanking(BuildContext context) async {
    List<SummaryDBankingItem> bankingList = [];
    final int status = context.read<DSRProvider>().status;
    try {
      final response =
          await Dio().post('$baseUrl/mobile_get_direct_banking_summary', data: {
        "dsr_id": context.read<LoginProvider>().currentUser.id,
        "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
      });
      if (response.statusCode == 200) {
        List dataList = response.data['data']['info'];
        if (dataList.isNotEmpty) {
          for (var data in dataList) {
            final id = int.parse(data['id'].toString());
            final sumId = int.parse(data['sum_id'].toString());
            bankingList.add(SummaryDBankingItem(
              id: id,
              sumId: sumId,
              bankName: data['direct_bank_name'].toString(),
              customerName: data['direct_bank_customer_name'].toString(),
              amount: double.parse(data['direct_bank_amount'].toString()),
              refno: data['direct_bank_ref_no'],
              status: status,
            ));
          }
        }
      }
    } on Exception catch (e) {
      toast(
          msg: 'Banking load failed!',
          toastStatus: TS.ERROR,
          toastLength: Toast.LENGTH_LONG);
    }

    return Future.value(bankingList);
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
            Text('D:Banking summary on'),
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
          future: _loadDBanking(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NosummaryScreen(
                        title: 'No direct bankings!',
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
                return NosummaryScreen(title: 'No direct bankings!');
              }
            }
          }),
    );
  }
}
