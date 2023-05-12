import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isLoadingHome = false;
  bool _isLoadingAccounts = false;
  bool _isLoadingTransactions = false;
  bool _isLoadingTabModules = false;

  int get currentIndex => _currentIndex;

  bool get isLoadingHome => _isLoadingHome;

  bool get isLoadingAccounts => _isLoadingAccounts;

  bool get isLoadingTransactions => _isLoadingTransactions;

  bool get isLoadingTabModules => _isLoadingTabModules;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setLoadingAccounts(bool status) {
    _isLoadingAccounts = status;
    notifyListeners();
  }

  void setLoadingTransactions(bool status) {
    _isLoadingTransactions = status;
    _isLoadingHome = status;
    notifyListeners();
  }

  void setLoadingTabModules(bool status) {
    _isLoadingTabModules = status;
    _isLoadingHome = status;
    notifyListeners();
  }
}
