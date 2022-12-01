import 'package:dsr_app/models/user.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _loadSignin = false;
  bool _approved = true;
  User? _currentUser = null;

  bool get loadSignin => _loadSignin;
  bool get approved => _approved;
  loggedinUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentId') ?? 0;
  }

  User get currentUser => _currentUser!;

  setSignin(bool loadSignin) {
    _loadSignin = loadSignin;
    notifyListeners();
  }

  setLoggedinUser(int loggedinUser) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentId', loggedinUser);
    notifyListeners();
  }

  Future setApproved(BuildContext context, DateTime date) async {
    if (await getApproveStatus(context, date) == 1 ||
        await getApproveStatus(context, date) == 2) {
      _approved = true;
    } else {
      _approved = false;
    }
    notifyListeners();
  }

  setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }
}
