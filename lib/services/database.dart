import 'package:dio/dio.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/dsr_provider.dart';
import 'package:dsr_app/models/bank.dart';
import 'package:dsr_app/models/banking.dart';
import 'package:dsr_app/models/banking_item.dart';
import 'package:dsr_app/models/credit.dart';
import 'package:dsr_app/models/credit_collection.dart';
import 'package:dsr_app/models/credit_collection_item.dart';
import 'package:dsr_app/models/credit_item.dart';
import 'package:dsr_app/models/direct_banking.dart';
import 'package:dsr_app/models/direct_banking_item.dart';
import 'package:dsr_app/models/inhand.dart';
import 'package:dsr_app/models/product.dart';
import 'package:dsr_app/models/response.dart';
import 'package:dsr_app/models/return.dart';
import 'package:dsr_app/models/return_item.dart';
import 'package:dsr_app/models/sale.dart';
import 'package:dsr_app/models/sale_item.dart';
import 'package:dsr_app/models/user.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/screens/home_screen.dart';
import 'package:dsr_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future login(User user, BuildContext context) async {
  LoginProvider _loginProvider =
      Provider.of<LoginProvider>(context, listen: false);
  try {
    final response =
        await Dio().post('$baseUrl/mobile_login', data: user.toJson());

    if (response.statusCode == 200) {
      Respo respo = Respo.fromJson(response.data);

      if (respo.error == null) {
        _loginProvider.setLoggedinUser(respo.info!.id!);
        _loginProvider.setCurrentUser(respo.info!);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
        toast(
            msg: 'Logged in successfully!',
            toastStatus: TS.SUCCESS,
            toastLength: Toast.LENGTH_LONG);
      } else if (respo.error == 0) {
        toast(
            msg: 'Email does not exist!',
            toastStatus: TS.ERROR,
            toastLength: Toast.LENGTH_LONG);
      } else if (respo.error == 1) {
        toast(
            msg: 'Password is incorrect!',
            toastStatus: TS.ERROR,
            toastLength: Toast.LENGTH_LONG);
      } else {
        toast(
            msg: 'Check your credentials!',
            toastStatus: TS.ERROR,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  } finally {
    _loginProvider.setSignin(false);
  }
}

Future<List<Product>> getProducts() async {
  final response = await Dio().post('$baseUrl/mobile_getItems');
  List list = response.data['data']['info'];

  return list.map((value) => Product.fromJson(value)).toList();
}

Future returnItem(
    BuildContext context, List<int> stockIds, int itemId, double qty) async {
  try {
    final response = await Dio().post('$baseUrl/mobile_add_dsr_return', data: {
      "dsr_stock_ids": stockIds.map((e) => {"id": e}).toList(),
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "item_id": itemId,
      "qty": qty
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'This return is under review',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future<List<Bank>> getBanks() async {
  final response = await Dio().post('$baseUrl/mobile_banks');
  List list = response.data['data']['info'];

  return list.map((value) => Bank.fromJson(value)).toList();
}

Future returnIssuedItem(
    BuildContext context, int stockId, int itemId, double qty) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_issue_dsr_return', data: {
      "dsr_stock_id": stockId,
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "item_id": itemId,
      "qty": qty
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Items returned successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    print(e);
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummarySale(BuildContext context, int id) async {
  try {
    final response = await Dio()
        .post('$baseUrl/mobile_remove_sale_summary', data: {"id": id});

    if (response.statusCode == 200) {
      toast(
          msg: 'Items deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummarySale(
  BuildContext context, {
  required int id,
  required String itemName,
  required double itemQty,
  required double itemPrice,
  required int dsrId,
  required String date,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_edit_sale_summary', data: {
      "id": id,
      "itemName": itemName,
      "itemQty": itemQty,
      "itemPrice": itemPrice,
      "date": date,
      "dsr_id": dsrId,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Items deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummaryBanking(
  BuildContext context, {
  required int id,
  required int sumId,
  String? bankName,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_remove_banking_summary', data: {
      "id": id,
      "sum_id": sumId,
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "bank_name": bankName,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Banking deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummaryBanking(
  BuildContext context, {
  required int id,
  required int sumId,
  required String bank,
  required String refno,
  required double amount,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_edit_banking_summary', data: {
      "id": id,
      "sum_id": sumId,
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "bank": bank,
      "refno": refno,
      "amount": amount,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Banking edited successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummaryDBanking(
  BuildContext context, {
  required int id,
  required int sumId,
  required String bankName,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_remove_dbanking_summary', data: {
      "id": id,
      "sum_id": sumId,
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "bank_name": bankName,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Items deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummaryDBanking(
  BuildContext context, {
  required int id,
  required int sumId,
  required String customerName,
  required String bank,
  required String refno,
  required double amount,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_edit_dbanking_summary', data: {
      "id": id,
      "sum_id": sumId,
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "customerName": customerName,
      "bank": bank,
      "refno": refno,
      "amount": amount,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Items deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummaryCredit(BuildContext context, int id) async {
  try {
    final response = await Dio()
        .post('$baseUrl/mobile_remove_credit_summary', data: {"id": id});

    if (response.statusCode == 200) {
      toast(
          msg: 'Credit deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummaryCredit(
  BuildContext context, {
  required int id,
  required String customerName,
  required double amount,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_edit_credit_summary', data: {
      "id": id,
      "customerName": customerName,
      "amount": amount,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Credit deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummaryCC(BuildContext context, int id) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_remove_cc_summary', data: {"id": id});

    if (response.statusCode == 200) {
      toast(
          msg: 'Credit collection deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummaryCC(
  BuildContext context, {
  required int id,
  required String customerName,
  required double amount,
}) async {
  try {
    final response = await Dio().post('$baseUrl/mobile_edit_cc_summary', data: {
      "id": id,
      "ccName": customerName,
      "ccAmount": amount,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Credit collection deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future deleteSummaryRetailer(BuildContext context, int id) async {
  try {
    final response = await Dio()
        .post('$baseUrl/mobile_remove_retailer_summary', data: {"id": id});

    if (response.statusCode == 200) {
      toast(
          msg: 'Retailer return deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future editSummaryRetailer(
  BuildContext context, {
  required int id,
  required String reCustomerName,
  required int reItemId,
  required double reQuantity,
  required double reAmount,
}) async {
  try {
    final response =
        await Dio().post('$baseUrl/mobile_edit_retailer_summary', data: {
      "id": id,
      "reCustomerName": reCustomerName,
      "reItemId": reItemId,
      "reQuantity": reQuantity,
      "reAmount": reAmount,
    });

    if (response.statusCode == 200) {
      toast(
          msg: 'Retailer return deleted successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future loginWithId(int userId, BuildContext context) async {
  LoginProvider _loginProvider =
      Provider.of<LoginProvider>(context, listen: false);
  try {
    final response = await Dio()
        .post('$baseUrl/mobile_get_userbyId', data: {"user_id": userId});

    if (response.statusCode == 200) {
      Respo respo = Respo.fromJson(response.data);
      if (respo.error == null) {
        if (respo.info == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          _loginProvider.setLoggedinUser(userId);
          _loginProvider.setCurrentUser(respo.info!);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    }
  } on Exception catch (e) {
    print(e);
    toast(
      msg: 'Something wrong!',
      toastStatus: TS.ERROR,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

Future logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('currentId');
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}

Future aboutBulk(BuildContext context, int stock_id, int stock_status) async {
  try {
    final response = await Dio().post('$baseUrl/mobile_update_stock_status',
        data: {"stock_id": stock_id, "stock_status": stock_status});

    if (response.statusCode == 200) {
      toast(
          msg: stock_status == 1
              ? 'Bulk approved successfully'
              : 'Bulk rejected successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future changePassword(BuildContext context, String password) async {
  User currentUser = context.read<LoginProvider>().currentUser;
  try {
    final response = await Dio().post('$baseUrl/mobile_update_password', data: {
      "user_id": currentUser.id,
      "email": currentUser.email,
      "password": password
    });

    if (response.statusCode == 200) {
      await logout(context);
      toast(
          msg: 'Password has changed successfully',
          toastStatus: TS.SUCCESS,
          toastLength: Toast.LENGTH_LONG);
    }
  } on Exception catch (e) {
    toast(
        msg: 'Something wrong!',
        toastStatus: TS.ERROR,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future sendSale(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> sale_items = [];
    _dsrProvider.productList.forEach((product) {
      sale_items.add(SaleItem(
              dsrStockIds: product.stockIds.map((e) => {"id": e}).toList(),
              itemId: product.productId,
              itemName: product.productName,
              itemQty: product.productQuantity!,
              itemPrice: product.productPrice)
          .toJson());
    });

    final response = await Dio().post('$baseUrl/mobile_dsr_sales',
        data: Sale(
                dsr_id: context.read<LoginProvider>().currentUser.id!,
                date: DateFormat('yyyy-MM-dd').format(selectedDate),
                sales: sale_items)
            .toJson());
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllProducts();
      toast(msg: 'Sale sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future sendInhand(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    final response = await Dio().post('$baseUrl/mobile_dsr_inhands',
        data: Inhand(
          dsr_id: context.read<LoginProvider>().currentUser.id!,
          cash: _dsrProvider.totalCashInhand,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
          cheques: _dsrProvider.chequeList,
        ).toJson());
    if (response.statusCode == 200) {
      toast(msg: 'Inhands sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    print(e);
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future approveSummary(BuildContext context, DateTime selectedDate) async {
  try {
    final response = await Dio().post('$baseUrl/mobile_approve_summary', data: {
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "date": DateFormat('yyyy-MM-dd').format(selectedDate)
    });
    if (response.statusCode == 200) {
      toast(msg: 'Summary has approved successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (_) {
    toast(msg: 'Summary approving failed!', toastStatus: TS.ERROR);
  }
}

Future<int> getApproveStatus(
    BuildContext context, DateTime selectedDate) async {
  int status = 0;

  try {
    final response = await Dio().post('$baseUrl/mobile_approve_status', data: {
      "dsr_id": context.read<LoginProvider>().currentUser.id,
      "date": DateFormat('yyyy-MM-dd').format(selectedDate)
    });
    if (response.statusCode == 200) {
      List list = response.data['data']['info'];
      status = list.isNotEmpty ? int.parse(list[0]['status'].toString()) : 3;
    }
  } on Exception catch (e) {
    toast(msg: 'Some connection problem!', toastStatus: TS.ERROR);
  }
  return Future.value(status);
}

Future sendBanking(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> banking_items = [];
    _dsrProvider.bankingList.forEach((banking) {
      banking_items.add(BankingItem(
        amount: banking.amount,
        ref_no: banking.refno,
        bank_id: banking.bId,
      ).toJson());
    });

    final response = await Dio().post('$baseUrl/mobile_dsr_bankings',
        data: Banking(
          dsr_id: context.read<LoginProvider>().currentUser.id!,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
          bankings: banking_items,
        ).toJson());
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllBankings();
      toast(msg: 'Banking sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    print(e);
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future sendDirectBanking(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> direct_banking_items = [];
    _dsrProvider.directBankingList.forEach((directBanking) {
      direct_banking_items.add(DirectBankingItem(
              customerName: directBanking.customertName,
              bank: directBanking.bank,
              refno: directBanking.refno,
              amount: directBanking.bankedAmount)
          .toJson());
    });

    final response = await Dio().post(
      '$baseUrl/mobile_dsr_direct_bankings',
      data: DirectBanking(
        dsr_id: context.read<LoginProvider>().currentUser.id!,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        dbankings: direct_banking_items,
      ).toJson(),
    );
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllDirectBankings();
      toast(msg: 'Direct Banking sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future sendCredit(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> credit_items = [];
    _dsrProvider.creditList.forEach((credit) {
      credit_items.add(CreditItem(
        amount: credit.creditAmount,
        customerName: credit.customertName,
      ).toJson());
    });

    final response = await Dio().post('$baseUrl/mobile_dsr_credits',
        data: Credit(
                dsr_id: context.read<LoginProvider>().currentUser.id!,
                date: DateFormat('yyyy-MM-dd').format(selectedDate),
                credits: credit_items)
            .toJson());
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllCredits();
      toast(msg: 'Credit sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future sendReturn(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> return_items = [];
    _dsrProvider.returnList.forEach((returned) {
      return_items.add(ReturnItem(
              reAmount: returned.amount,
              reCustomerName: returned.customertName,
              reQuantity: returned.quantity,
              reitemId: returned.productId)
          .toJson());
    });

    final response = await Dio().post('$baseUrl/mobile_dsr_retialers',
        data: Return(
                dsr_id: context.read<LoginProvider>().currentUser.id!,
                date: DateFormat('yyyy-MM-dd').format(selectedDate),
                retilers: return_items)
            .toJson());
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllReturns();
      toast(msg: 'Return sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}

Future sendCC(BuildContext context, DateTime selectedDate) async {
  try {
    DSRProvider _dsrProvider = Provider.of<DSRProvider>(context, listen: false);
    List<Map<String, dynamic>> cc_items = [];
    _dsrProvider.creditCollectionList.forEach((cc) {
      cc_items.add(CreditCollectionItem(
        ccName: cc.customertName,
        ccAmount: cc.creditAmount,
      ).toJson());
    });

    final response = await Dio().post('$baseUrl/mobile_dsr_creditcollections',
        data: CreditCollection(
                dsr_id: context.read<LoginProvider>().currentUser.id!,
                date: DateFormat('yyyy-MM-dd').format(selectedDate),
                creditcollections: cc_items)
            .toJson());
    if (response.statusCode == 200) {
      _dsrProvider.deleteAllCreditCollection();
      toast(
          msg: 'Credit collection sent successfully', toastStatus: TS.SUCCESS);
    }
  } on Exception catch (e) {
    toast(msg: 'Sending failed!', toastStatus: TS.ERROR);
  }
}
