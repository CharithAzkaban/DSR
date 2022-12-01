import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/issued_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IssuedItemsScreen extends StatefulWidget {
  final List items;
  final DateTime issued_at;
  final int stockId;
  const IssuedItemsScreen(
      {Key? key,
      required this.items,
      required this.issued_at,
      required this.stockId})
      : super(key: key);

  @override
  State<IssuedItemsScreen> createState() => _IssuedItemsScreenState();
}

class _IssuedItemsScreenState extends State<IssuedItemsScreen> {
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
            Text(DateFormat('EEEE, dd MMMM yyyy').format(widget.issued_at)),
            Text(
              DateFormat('hh:mm:ss a').format(widget.issued_at),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn2',
        onPressed: () {
          confirmBulk(context, 'About this bulk?', onConfirm: () async {
            await aboutBulk(context, widget.stockId, 1);
            Navigator.pop(context);
            Navigator.pop(context);
          }, onreject: () async {
            await aboutBulk(context, widget.stockId, 2);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
        child: Icon(
          Icons.question_mark_rounded,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return IssuedItem(
                  productId:
                      int.parse(widget.items[index]['item_id'].toString()),
                  stockId: widget.stockId,
                  productName: widget.items[index]['name'],
                  productQuantity:
                      double.parse(widget.items[index]['qty'].toString()),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 10.0,
                  ),
              itemCount: widget.items.length)),
    );
  }
}
