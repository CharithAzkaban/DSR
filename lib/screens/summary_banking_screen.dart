import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/nosummary_screen.dart';
import 'package:dsr_app/widgets/summary_banking_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryBankingScreen extends StatefulWidget {
  final selectedDate;
  const SummaryBankingScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<SummaryBankingScreen> createState() => _SummaryBankingScreenState();
}

class _SummaryBankingScreenState extends State<SummaryBankingScreen> {
  Future<List<SummaryBankingItem>> _loadBanking(BuildContext context) async {
    List<SummaryBankingItem> bankingList = [];
    final int status = context.read<DSRProvider>().status;
    try {
      final response =
          await Dio().post('$baseUrl/mobile_get_banking_summary', data: {
        "dsr_id": context.read<LoginProvider>().currentUser.id,
        "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
      });
      if (response.statusCode == 200) {
        List dataList = response.data['data']['info'];
        if (dataList.isNotEmpty) {
          for (var data in dataList) {
            final id = int.parse(data['id'].toString());
            final sumId = int.parse(data['sum_id'].toString());
            bankingList.add(
              SummaryBankingItem(
                id: id,
                sumId: sumId,
                bankName: data['bank_name'].toString(),
                amount: double.parse(data['bank_amount'].toString()),
                refno: data['bank_ref_no'],
                status: status,
              ),
            );
          }
        }
      }
    } on Exception catch (e) {
      toast(msg: 'Banking load failed!');
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
            Text('Banking summary on'),
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
          future: _loadBanking(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return snapshot.data.isEmpty
                    ? NosummaryScreen(
                        title: 'No bankings!',
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
                return NosummaryScreen(title: 'No bankings!');
              }
            }
          }),
    );
  }
}
