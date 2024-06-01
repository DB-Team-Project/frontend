import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier{
  late final int _userId;

  int get userId => _userId;

  void setUserId(int id){
    _userId = id;
    notifyListeners();
  }
}