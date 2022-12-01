import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/status.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/banking_screen.dart';
import 'package:dsr_app/screens/credit_collection_screen.dart';
import 'package:dsr_app/screens/credit_screen.dart';
import 'package:dsr_app/screens/direct_banking_screen.dart';
import 'package:dsr_app/screens/inhand_screen.dart';
import 'package:dsr_app/screens/return_screen.dart';
import 'package:dsr_app/screens/sales_screen.dart';
import 'package:dsr_app/screens/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DaySummary extends StatefulWidget {
  const DaySummary({Key? key}) : super(key: key);

  @override
  State<DaySummary> createState() => _DaySummaryState();
}

class _DaySummaryState extends State<DaySummary> {
  ValueNotifier<bool> _visible = ValueNotifier<bool>(false);
  DateTime selectedDate = DateTime.now();

  Future<Status> _loadStatus(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    Status? status;
    await context.read<LoginProvider>().setApproved(context, selectedDate);
    try {
      final response =
          await Dio().post('$baseUrl/mobile_get_summary_status', data: {
        "dsr_id": context.read<LoginProvider>().currentUser.id,
        "date": DateFormat('yyyy-MM-dd').format(selectedDate)
      });
      if (response.statusCode == 200) {
        List data = response.data['data']['info'];

        if (data.isNotEmpty) {
          status = Status.fromJson(data[0]);
        }
      }
    } on Exception catch (e) {
      toast(msg: 'Status loading failed!');
    }

    return Future.value(status);
  }

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));
    LoginProvider _loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 10.0, left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: _visible,
                  builder: (context, data, _) {
                    return Visibility(
                        visible: data,
                        child: CalendarDatePicker(
                            initialDate: selectedDate,
                            firstDate: DateTime(2020, 1, 1),
                            lastDate: DateTime.now(),
                            onDateChanged: (date) {
                              _visible.value = !_visible.value;
                              setState(() {
                                selectedDate = date;
                              });
                            }));
                  }),
              Material(
                shape: _shapeBorder,
                elevation: 2.0,
                child: Container(
                  height: 220.0,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(child: Lottie.asset('assets/cloud.json')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _visible.value = !_visible.value;
                            },
                            child: Material(
                              color: Colors.white,
                              elevation: 2,
                              shape: _shapeBorder,
                              child: Container(
                                width: 170.0,
                                height: 170.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      DateFormat('MMM').format(selectedDate),
                                      style: TextStyle(
                                          fontSize: 50, color: Colors.blue),
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Visibility(
                                          visible: DateFormat('yyyyMMdd')
                                                  .format(selectedDate) ==
                                              DateFormat('yyyyMMdd')
                                                  .format(DateTime.now()),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('d').format(selectedDate),
                                          style: TextStyle(
                                              fontSize: 90,
                                              color: Colors.black45),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    'assets/dialog.png',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                  Text(
                                    'DSR\nsummary',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.black54),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FloatingActionButton(
                                    heroTag: 'btn1',
                                    elevation: 2,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SummaryScreen(
                                                      selectedDate:
                                                          selectedDate)));
                                    },
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.summarize_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  FloatingActionButton(
                                    heroTag: 'btn3',
                                    elevation: 2,
                                    onPressed: () {
                                      setState(() {
                                        toast(
                                            msg: 'Refreshing...',
                                            toastStatus: TS.REGULAR,
                                            toastLength: Toast.LENGTH_LONG);
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder<Status>(
                  future: _loadStatus(context, selectedDate),
                  builder: (context, AsyncSnapshot<Status> snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Sales',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update sales',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('sale'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.sales_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SalesScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Inhand',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update inhand money',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('inhand'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.inhand_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InhandScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Banking',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update banked money',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('banking'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.banking_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BankingScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Direct banking',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update direct banking',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('direct_banking'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.direct_banking_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DirectBankingScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Credit',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update credit',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('credit'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.credit_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreditScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Retailer returns',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update returns',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('return'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.retialer_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ReturnScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Material(
                          shape: _shapeBorder,
                          elevation: 10.0,
                          child: ListTile(
                            enabled: snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                !_loginProvider.approved,
                            title: Text(
                              'Credit collection',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 23.0),
                            ),
                            subtitle: Text(
                              'Update credit collection',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            shape: _shapeBorder,
                            leading: icon('collection'),
                            trailing: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : (snapshot.hasData
                                    ? (snapshot.data!.credit_collection_sum == 1
                                        ? Icon(
                                            Icons.done,
                                            size: 45.0,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.warning_rounded,
                                            size: 45.0,
                                            color: Colors.orange,
                                          ))
                                    : Icon(Icons.error_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreditCollectionScreen(
                                            selectedDate: selectedDate,
                                          ))).then((value) {
                                setState(() {});
                              });
                            },
                            tileColor: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
