import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/summary.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/nosummary_screen.dart';
import 'package:dsr_app/screens/summary_banking_screen.dart';
import 'package:dsr_app/screens/summary_cc_screen.dart';
import 'package:dsr_app/screens/summary_inhand_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'summary_credit_screen.dart';
import 'summary_dbanking_screen.dart';
import 'summary_retailer_screen.dart';
import 'summary_sale_screen.dart';

class SummaryScreen extends StatefulWidget {
  final DateTime selectedDate;

  const SummaryScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<Summary> loadSummary(BuildContext context) async {
    context
        .read<DSRProvider>()
        .setStatus(await getApproveStatus(context, widget.selectedDate));
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final response = await Dio().post('$baseUrl/mobile_dsr_summary', data: {
      "dsr_id": loginProvider.currentUser.id,
      "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
    });

    return Summary.fromJson(response.data['data']['info'][0]);
  }

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));
    Color titleColor = Colors.grey.shade700;
    Color subtitleColor = Color.fromRGBO(97, 97, 97, 1);

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
      appBar: AppBar(
        title: Column(
          children: [
            Text('Summary on'),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: Text(
                    'Refresh Summary',
                  )),
              PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Approve Summary',
                    style: TextStyle(color: Colors.green[700]),
                  )),
            ],
            onSelected: (index) async {
              int status = await getApproveStatus(context, widget.selectedDate);
              context.read<DSRProvider>().setStatus(status);
              if (index == 1) {
                if (status == 1) {
                  info(context, Popup.INFO,
                      'Your summary is under review on the admin',
                      ok: 'Ok, I\'ll check');
                } else if (status == 2) {
                  info(context, Popup.INFO,
                      'Your summary has already approved by the admin',
                      ok: 'Ok, I\'ll check');
                } else if (status == 3) {
                  info(context, Popup.INFO, 'There\'s no summary to approve',
                      ok: 'Oops! 😁');
                } else {
                  confirm(context,
                      'You are about to approving your daily summary. After you approve this once, you will not be able to modify your Day Summary anymore.',
                      onConfirm: () async {
                    await approveSummary(context, widget.selectedDate);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  }, okText: 'Approve', iconPath: 'popup_warning');
                }
              }
              if (index == 0) {
                setState(() {
                  toast(
                      msg: 'Refreshing...',
                      toastStatus: TS.REGULAR,
                      toastLength: Toast.LENGTH_LONG);
                });
              }
            },
          )
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: loadSummary(context),
          builder: (context, AsyncSnapshot<Summary> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Sales',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SummarySalesScreen(
                                          selectedDate: widget
                                              .selectedDate))).then((value) {
                                setState(() {});
                              });
                            },
                            subtitle: Text(
                              price(snapshot.data!.sales_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: _shapeBorder,
                            leading: Icon(
                              Icons.auto_graph_rounded,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Inhand',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.inhand_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SummaryInhandScreen(
                                          selectedDate: widget.selectedDate)));
                            },
                            shape: _shapeBorder,
                            leading: Icon(
                              Icons.attach_money,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Banking',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.banking_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: _shapeBorder,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SummaryBankingScreen(
                                                  selectedDate:
                                                      widget.selectedDate)))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            leading: Icon(
                              Icons.other_houses,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Direct Banking',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.direct_banking_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: _shapeBorder,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SummaryDBankingScreen(
                                                  selectedDate:
                                                      widget.selectedDate)))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            leading: Icon(
                              Icons.money_outlined,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Credit',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.credit_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: _shapeBorder,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SummaryCreditScreen(
                                          selectedDate: widget
                                              .selectedDate))).then((value) {
                                setState(() {});
                              });
                            },
                            leading: Icon(
                              Icons.money_off_csred_outlined,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Credit Collection',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.credit_collection_sum),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SummaryCreditCollectionScreen(
                                                  selectedDate:
                                                      widget.selectedDate)))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            shape: _shapeBorder,
                            leading: Icon(
                              Icons.cases_outlined,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Retailer Returns',
                              style:
                                  TextStyle(color: titleColor, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              numberItem(snapshot.data!.retialer_item_count),
                              style: TextStyle(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SummaryRetailerScreen(
                                                  selectedDate:
                                                      widget.selectedDate)))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            shape: _shapeBorder,
                            leading: Icon(
                              Icons.u_turn_left_rounded,
                              size: 45.0,
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              'Variance',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              price(snapshot.data!.sales_sum +
                                  snapshot.data!.credit_collection_sum -
                                  snapshot.data!.inhand_sum -
                                  snapshot.data!.banking_sum -
                                  snapshot.data!.direct_banking_sum -
                                  snapshot.data!.credit_sum),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: _shapeBorder,
                            leading: Icon(
                              Icons.clear_all_outlined,
                              color: Colors.white,
                              size: 45.0,
                            ),
                            tileColor: Colors.red[900],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return NosummaryScreen(
                    title:
                        'No summary available on\n${DateFormat('EEEE, dd MMMM yyyy').format(widget.selectedDate)}');
              }
            }
          }),
    );
  }
}
