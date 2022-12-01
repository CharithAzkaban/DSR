import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/screens/accept_stock_screen.dart';
import 'package:dsr_app/screens/stock_balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(child: Lottie.asset('assets/stock.json')),
              SizedBox(
                height: 30.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    shape: _shapeBorder,
                    elevation: 1.0,
                    child: ListTile(
                      title: Text(
                        'Issued stocks',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 23.0),
                      ),
                      shape: _shapeBorder,
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.done_all_rounded)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AcceptStockScreen()));
                      },
                      tileColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Material(
                    shape: _shapeBorder,
                    elevation: 1.0,
                    child: ListTile(
                      title: Text(
                        'View balance',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 23.0),
                      ),
                      shape: _shapeBorder,
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.view_agenda),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StockBalanceScreen()));
                      },
                      tileColor: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
