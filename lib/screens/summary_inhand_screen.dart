import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/inhand_data.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SummaryInhandScreen extends StatefulWidget {
  final DateTime selectedDate;
  const SummaryInhandScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<SummaryInhandScreen> createState() => _SummaryInhandScreenState();
}

class _SummaryInhandScreenState extends State<SummaryInhandScreen> {
  Future<InhandData> _loadInhands(
    BuildContext context,
  ) async {
    InhandData? inhand;
    try {
      final response =
          await Dio().post('$baseUrl/mobile_get_inhand_summary', data: {
        "dsr_id": context.read<LoginProvider>().currentUser.id,
        "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate)
      });
      if (response.statusCode == 200) {
        List data = response.data['data']['info'];

        if (data.isNotEmpty) {
          inhand = InhandData(
              cashAmount: double.parse(data[0]['cash'].toString()),
              chequeAmount: double.parse(data[0]['cheque'].toString()));
        }
      }
    } on Exception catch (e) {
      toast(msg: 'Inhand loading failed!');
    }

    return Future.value(inhand);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
              Text('Inhand summary on'),
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
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<InhandData>(
                  future: _loadInhands(context),
                  builder: (context, AsyncSnapshot<InhandData> snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Lottie.asset('assets/inhand.json'),
                          height: 200.0,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircularProgressIndicator()
                              : (snapshot.hasData
                                  ? (TextFormField(
                                      enabled: false,
                                      initialValue:
                                          price(snapshot.data!.cashAmount),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700]),
                                        labelText: 'Cash',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    ))
                                  : TextFormField(
                                      enabled: false,
                                      initialValue: price(0),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700]),
                                        labelText: 'Cash',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    )),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircularProgressIndicator()
                              : (snapshot.hasData
                                  ? (TextFormField(
                                      enabled: false,
                                      initialValue:
                                          price(snapshot.data!.chequeAmount),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700]),
                                        labelText: 'Cheque',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    ))
                                  : TextFormField(
                                      enabled: false,
                                      initialValue: price(0),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700]),
                                        labelText: 'Cheque',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    )),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        snapshot.connectionState == ConnectionState.waiting
                            ? CircularProgressIndicator()
                            : snapshot.hasData
                                ? (Text(
                                    price(snapshot.data!.cashAmount +
                                        snapshot.data!.chequeAmount),
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ))
                                : Text(
                                    price(0),
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
