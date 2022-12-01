import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

final String baseUrl = 'http://10.0.2.2:8000/api';
final String imageUrl = 'http://10.0.2.2:8000';
// final String baseUrl = 'https://jayawardenanetwork.lk/api';
// final String imageUrl = 'https://jayawardenanetwork.lk';

checkForUpdate(BuildContext context) {
  final newVersion =
      NewVersion(androidId: 'com.example.dsr_app', iOSId: 'com.example.dsrApp');
  newVersion.showAlertIfNecessary(context: context);
}

price(double amount) {
  MoneyFormatter fmf = new MoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
          symbol: 'Rs',
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: '.',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short));
  return fmf.output.symbolOnLeft;
}

number(double number) {
  if (number == number.toInt()) {
    return number.toInt().toString();
  }
  return number.toString();
}

numberUnit(double number) {
  if (number == number.toInt()) {
    return number.toInt().toString() + ' ${number == 1 ? ' unit' : ' units'}';
  }
  return number.toString() + ' ${number == 1 ? ' unit' : ' units'}';
}

numberItem(double number) {
  if (number == number.toInt()) {
    return number.toInt().toString() + ' ${number == 1 ? ' item' : ' items'}';
  }
  return number.toString() + ' ${number == 1 ? ' item' : ' items'}';
}

icon(String icon, {double? height}) {
  return Image.asset(
    'assets/icons/$icon.png',
    height: height,
  );
}

confirm(BuildContext context, String message,
    {required Future<void> Function() onConfirm,
    String? okText,
    String? iconPath}) {
  ValueNotifier<bool> _confirmed = ValueNotifier<bool>(false);
  Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                title: icon(iconPath ?? 'popup_confirm', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                  ValueListenableBuilder<bool>(
                      valueListenable: _confirmed,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data,
                          child: TextButton(
                              onPressed: () async {
                                _confirmed.value = true;
                                await onConfirm();
                                _confirmed.value = false;
                              },
                              child: data
                                  ? CircularProgressIndicator()
                                  : Text(
                                      okText ?? 'Confirm',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                ],
              ))
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: icon(iconPath ?? 'popup_confirm', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                  ValueListenableBuilder<bool>(
                      valueListenable: _confirmed,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data,
                          child: TextButton(
                              onPressed: () async {
                                _confirmed.value = true;
                                await onConfirm();
                                _confirmed.value = false;
                              },
                              child: data
                                  ? CircularProgressIndicator()
                                  : Text(
                                      okText ?? 'Confirm',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                ],
              ));
}

confirmWithContent(BuildContext context, Widget content,
    {required Future<void> Function() onConfirm, String? okText}) {
  ValueNotifier<bool> _confirmed = ValueNotifier<bool>(false);
  Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                title: icon('popup_confirm', height: 50.0),
                content: Card(
                    elevation: 0.0, color: Colors.transparent, child: content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                  ValueListenableBuilder<bool>(
                      valueListenable: _confirmed,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data,
                          child: TextButton(
                              onPressed: () async {
                                _confirmed.value = true;
                                await onConfirm();
                                _confirmed.value = false;
                              },
                              child: data
                                  ? CircularProgressIndicator()
                                  : Text(
                                      okText ?? 'Confirm',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                ],
              ))
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: icon('popup_confirm', height: 50.0),
                content: Card(
                    elevation: 0.0, color: Colors.transparent, child: content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                  ValueListenableBuilder<bool>(
                      valueListenable: _confirmed,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data,
                          child: TextButton(
                              onPressed: () async {
                                _confirmed.value = true;
                                await onConfirm();
                                _confirmed.value = false;
                              },
                              child: data
                                  ? CircularProgressIndicator()
                                  : Text(
                                      okText ?? 'Confirm',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                ],
              ));
}

confirmBulk(BuildContext context, String message,
    {required void Function() onConfirm, required void Function() onreject}) {
  ValueNotifier<int> _approved = ValueNotifier<int>(0);
  ValueNotifier<int> _rejected = ValueNotifier<int>(0);
  Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                title: icon('popup_confirm', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                actions: [
                  ValueListenableBuilder<int>(
                      valueListenable: _approved,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data != 0,
                          child: TextButton(
                              onPressed: () {
                                _approved.value = 1;
                                _rejected.value = 2;
                                onConfirm();
                              },
                              child: data == 1
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Approve',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                  ValueListenableBuilder<int>(
                      valueListenable: _rejected,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data != 0,
                          child: TextButton(
                              onPressed: () {
                                _rejected.value = 1;
                                _approved.value = 2;
                                onreject();
                              },
                              child: data == 1
                                  ? CircularProgressIndicator(
                                      color: Colors.red,
                                    )
                                  : Text(
                                      'Reject',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18.0),
                                    )),
                        );
                      }),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                ],
              ))
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: icon('popup_confirm', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  ValueListenableBuilder<int>(
                      valueListenable: _approved,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data != 0,
                          child: TextButton(
                              onPressed: () {
                                _approved.value = 1;
                                _rejected.value = 2;
                                onConfirm();
                              },
                              child: data == 1
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Approve',
                                      style: TextStyle(fontSize: 18.0),
                                    )),
                        );
                      }),
                  ValueListenableBuilder<int>(
                      valueListenable: _rejected,
                      builder: (context, data, _) {
                        return AbsorbPointer(
                          absorbing: data != 0,
                          child: TextButton(
                              onPressed: () {
                                _rejected.value = 1;
                                _approved.value = 2;
                                onreject();
                              },
                              child: data == 1
                                  ? CircularProgressIndicator(
                                      color: Colors.red,
                                    )
                                  : Text(
                                      'Reject',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18.0),
                                    )),
                        );
                      }),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      )),
                ],
              ));
}

info(BuildContext context, Popup status, String message, {String? ok}) {
  Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                title: (status == Popup.SUCCESS)
                    ? icon('popup_ok', height: 50.0)
                    : (status == Popup.ERROR)
                        ? icon('popup_error', height: 50.0)
                        : (status == Popup.WARNING)
                            ? icon('popup_warning', height: 50.0)
                            : (status == Popup.CONFIRM)
                                ? icon('popup_confirm', height: 50.0)
                                : icon('popup_info', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        ok ?? 'Ok',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ],
              ))
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: (status == Popup.SUCCESS)
                    ? icon('popup_ok', height: 50.0)
                    : (status == Popup.ERROR)
                        ? icon('popup_error', height: 50.0)
                        : (status == Popup.WARNING)
                            ? icon('popup_warning', height: 50.0)
                            : (status == Popup.CONFIRM)
                                ? icon('popup_confirm', height: 50.0)
                                : icon('popup_info', height: 50.0),
                content: Text(message,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        ok ?? 'Ok',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ],
              ));
}

callAdmin(
  BuildContext context,
) {
  Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                title: icon('popup_call', height: 50.0),
                content: Text(
                    'If you have any problem when login, please contact your DSR admin. Would you like to call the admin?',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Not now',
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            '+94763593506');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Call',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ],
              ))
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: icon('popup_call', height: 50.0),
                content: Text(
                    'If you have any problem when login, please contact your DSR admin. Would you like to call the admin?',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Not now',
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            '+94763593506');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Call',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ],
              ));
}

enum Popup { ERROR, SUCCESS, WARNING, INFO, CONFIRM }

toast(
    {required String msg,
    Toast? toastLength,
    ToastGravity? gravity,
    int? timeInSecForIosWeb,
    TS? toastStatus,
    Color? textColor}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
      backgroundColor: toastStatus == TS.ERROR
          ? Colors.red[900]
          : toastStatus == TS.SUCCESS
              ? Colors.green[900]
              : Colors.black87,
      textColor: textColor ?? Colors.white,
      fontSize: 16.0);
}

even(int integer) {
  return integer % 2 == 0;
}

enum TS { SUCCESS, ERROR, REGULAR }

// changePassword(BuildContext context) {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController newPasswordController = TextEditingController();

//   Platform.isIOS
//       ? showCupertinoDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => CupertinoAlertDialog(
//                 title: Text('Change Password',
//                     style: TextStyle(fontSize: 20.0, color: Colors.grey[700])),
//                 content: ChangePassword(),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.red, fontSize: 18.0),
//                       )),
//                   TextButton(
//                       onPressed: () async {
//                         if (formKey.currentState!.validate()) {
//                           await db.changePassword(
//                               context, newPasswordController.text);
//                           return;
//                         }
//                       },
//                       child: Text(
//                         'Confirm',
//                         style: TextStyle(fontSize: 18.0),
//                       )),
//                 ],
//               ))
//       : showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => AlertDialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0)),
//                 content: ChangePassword(),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.red, fontSize: 18.0),
//                       )),
//                   TextButton(
//                       onPressed: () async {
//                         if (formKey.currentState!.validate()) {
//                           await db.changePassword(
//                               context, newPasswordController.text);
//                           return;
//                         }
//                       },
//                       child: Text(
//                         'Confirm',
//                         style: TextStyle(fontSize: 18.0),
//                       )),
//                 ],
//               ));
// }
