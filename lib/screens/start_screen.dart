import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/login_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    final _mainTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 55.0);
    Future.delayed(Duration(seconds: 5), () async {
      int loggedinUser = await _loginProvider.loggedinUser();
      if (loggedinUser == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        await loginWithId(loggedinUser, context);
      }
    });
    return Scaffold(
      bottomSheet: Container(
        color: Colors.black,
        height: 50.0,
        width: double.infinity,
        child: Center(
          child: Text(
            'Copyright © 2022 Jayawardena Network (Pvt) Ltd.\nAll rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/dialog.png',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'DSR',
              style: _mainTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
