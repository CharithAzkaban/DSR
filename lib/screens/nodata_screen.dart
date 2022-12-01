import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NodataScreen extends StatelessWidget {
  final String title;
  const NodataScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/nodata.json', repeat: false),
              Text(
                title,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
