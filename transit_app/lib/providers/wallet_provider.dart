import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  
  double _balance = 0;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWalletData(int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _walletService.getWalletBalance(userId);
    
    _isLoading = false;
    
    if (result['success']) {
      _balance = result['balance'];
      _transactions = result['transactions'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  Future<bool> addMoney(int userId, double amount, String paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _walletService.addMoney(
      userId: userId,
      amount: amount,
      paymentMethod: paymentMethod,
    );
    
    _isLoading = false;
    
    if (result['success']) {
      _balance += amount;
      await fetchWalletData(userId);
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  Future<bool> makePayment(int userId, int bookingId, double amount, String paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _walletService.makePayment(
      userId: userId,
      bookingId: bookingId,
      amount: amount,
      paymentMethod: paymentMethod,
    );
    
    _isLoading = false;
    
    if (result['success']) {
      _balance -= amount;
      await fetchWalletData(userId);
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
