import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  late final int _userId;
  late final String _userName;

  int get userId => _userId;
  String get userName => _userName;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  void setUserName(String username) {
    _userName = username;
    notifyListeners();
  }
}
