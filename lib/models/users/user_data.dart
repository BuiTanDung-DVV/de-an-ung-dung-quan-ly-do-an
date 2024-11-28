import 'package:flutter/material.dart';
import 'package:quan_ly_do_an_online/models/users/user.dart';


class UserData with ChangeNotifier {
  User? _user;
  int get userId => _user?.userId ?? 0;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
