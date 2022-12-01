import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NosummaryScreen extends StatelessWidget {
  final String title;
  const NosummaryScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/nosummary.json'),
            SizedBox(
              height: 20.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
