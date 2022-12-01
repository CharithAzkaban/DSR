import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/user.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/day_summary.dart';
import 'package:dsr_app/screens/stock_screen.dart';
import 'package:dsr_app/services/database.dart';
import 'package:dsr_app/widgets/change_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<int> issuedCount(BuildContext context) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final response = await Dio().post('$baseUrl/mobile_dsr_stock',
        data: {"id": await loginProvider.loggedinUser()});
    List issuedList = response.data['data']['info'];
    return issuedList.length;
  }

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)));
    User _currentUser = context.read<LoginProvider>().currentUser;
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 2.0,
                        child: Container(
                          height: 200.0,
                          width: double.infinity,
                          child: Lottie.asset('assets/cloud.json'),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        elevation: 0.0,
                        child: Container(
                          height: 180.0,
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl +
                                  '/' +
                                  _currentUser.profile_photo_path!),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(100.0)),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10.0,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.grey[300],
                      //       shape: BoxShape.rectangle,
                      //       borderRadius: BorderRadius.circular(5.0)),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 10, right: 10, top: 2, bottom: 2),
                      //     child: Text(
                      //       _currentUser.email,
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //           fontSize: 15.0, fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        _currentUser.name!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        _currentUser.route!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    shape: _shapeBorder,
                    elevation: 0.0,
                    child: ListTile(
                      title: Text(
                        'Day summary',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 23.0),
                      ),
                      shape: _shapeBorder,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.auto_graph_rounded),
                      ),
                      onTap: () {
                        Navigator.push(context,
                                MaterialPageRoute(builder: (_) => DaySummary()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      tileColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SwipeTo(
                    onLeftSwipe: () {
                      setState(() {});
                    },
                    leftSwipeWidget:
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    child: Material(
                      shape: _shapeBorder,
                      elevation: 0.0,
                      child: ListTile(
                        title: Text(
                          'Stocks',
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 23.0),
                        ),
                        shape: _shapeBorder,
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.style_rounded),
                        ),
                        subtitle: Text(
                          '<< Swipe left to refresh',
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 12.0),
                        ),
                        trailing: FutureBuilder(
                            future: issuedCount(context),
                            builder: (context, AsyncSnapshot<int> snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? CircularProgressIndicator()
                                  : (snapshot.hasData && snapshot.data != 0
                                      ? ConstrainedBox(
                                          constraints: new BoxConstraints(
                                            minWidth: 27.0,
                                            minHeight: 27.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[700],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                snapshot.data.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(''));
                            }),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => StockScreen())).then((value) {
                            setState(() {});
                          });
                        },
                        tileColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Material(
                  //   shape: _shapeBorder,
                  //   elevation: 0.0,
                  //   child: ListTile(
                  //     title: Text(
                  //       'Announcements',
                  //       style:
                  //           TextStyle(color: Colors.grey[700], fontSize: 23.0),
                  //     ),
                  //     shape: _shapeBorder,
                  //     trailing: ConstrainedBox(
                  //       constraints: new BoxConstraints(
                  //         minWidth: 27.0,
                  //         minHeight: 27.0,
                  //       ),
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.blue,
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(50.0))),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(5.0),
                  //           child: Text(
                  //             '5',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     leading: Padding(
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: Icon(Icons.message_rounded)),
                  //     onTap: () async {
                  //       info(context, Popup.WARNING,
                  //           await ConnectivityResult.wifi.toString(),
                  //           ok: 'Ok, I\'ll check');
                  //     },
                  //     tileColor: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(height: 10.0),
                  Material(
                    shape: _shapeBorder,
                    elevation: 0.0,
                    child: ListTile(
                      title: Text(
                        'Change password',
                        style:
                            TextStyle(color: Colors.red[700], fontSize: 23.0),
                      ),
                      shape: _shapeBorder,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.red[700],
                        ),
                      ),
                      onTap: () {
                        final TextEditingController newPasswordController =
                            TextEditingController();
                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();
                        confirmWithContent(
                            context,
                            ChangePassword(
                                newPasswordController: newPasswordController,
                                formKey: formKey), onConfirm: () async {
                          if (formKey.currentState!.validate()) {
                            await changePassword(
                                context, newPasswordController.text);
                            return;
                          }
                        }, okText: 'Change');
                      },
                      tileColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Material(
                    shape: _shapeBorder,
                    elevation: 0.0,
                    child: ListTile(
                      title: Text(
                        'Sign out',
                        style:
                            TextStyle(color: Colors.red[700], fontSize: 23.0),
                      ),
                      shape: _shapeBorder,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.red[700],
                        ),
                      ),
                      onTap: () {
                        confirm(context, 'Do you need to sign here out?',
                            onConfirm: () async {
                          logout(context);
                        });
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
