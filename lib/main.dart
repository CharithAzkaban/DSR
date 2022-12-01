import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/screens/accept_stock_screen.dart';
import 'package:dsr_app/screens/home_screen.dart';
import 'package:dsr_app/screens/login_screen.dart';
import 'package:dsr_app/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/login_provider.dart';

main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DSRProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
        ],
        child: const Main(),
      ),
    );

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DSR App',
        home: StartScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/accept': (context) => AcceptStockScreen(),
          '/home': (context) => HomeScreen(),
        });
  }
}
