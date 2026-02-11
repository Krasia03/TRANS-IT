import '../models/transaction.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class WalletService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getWalletBalance(int userId) async {
    final response = await _api.get('${ApiConfig.getTransactions}&user_id=$userId');

    if (response['success'] && response['data'] != null) {
      final List<dynamic> transactionsJson = response['data'] is List 
          ? response['data'] 
          : [response['data']];
      
      double balance = 0;
      for (var t in transactionsJson) {
        final transaction = Transaction.fromJson(t);
        if (transaction.status == 'completed') {
          if (transaction.isCredit) {
            balance += transaction.amount;
          } else {
            balance -= transaction.amount;
          }
        }
      }

      return {
        'success': true,
        'balance': balance,
        'transactions': transactionsJson.map((t) => Transaction.fromJson(t)).toList(),
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to fetch wallet',
      'balance': 0.0,
      'transactions': <Transaction>[],
    };
  }

  Future<Map<String, dynamic>> getTransactions({
    required int userId,
    String? type,
    int? limit,
  }) async {
    String url = '${ApiConfig.getTransactions}&user_id=$userId';
    if (type != null) url += '&type=$type';
    if (limit != null) url += '&limit=$limit';

    final response = await _api.get(url);

    if (response['success'] && response['data'] != null) {
      final List<dynamic> transactionsJson = response['data'] is List 
          ? response['data'] 
          : [response['data']];
      return {
        'success': true,
        'transactions': transactionsJson.map((t) => Transaction.fromJson(t)).toList(),
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to fetch transactions',
      'transactions': <Transaction>[],
    };
  }

  Future<Map<String, dynamic>> addMoney({
    required int userId,
    required double amount,
    required String paymentMethod,
  }) async {
    final response = await _api.post(
      ApiConfig.createTransaction,
      data: {
        'user_id': userId,
        'transaction_type': 'credit',
        'amount': amount,
        'payment_method': paymentMethod,
        'status': 'completed',
        'transaction_ref': 'ADD${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Money added successfully',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to add money',
    };
  }

  Future<Map<String, dynamic>> makePayment({
    required int userId,
    required int bookingId,
    required double amount,
    required String paymentMethod,
  }) async {
    final response = await _api.post(
      ApiConfig.createTransaction,
      data: {
        'user_id': userId,
        'booking_id': bookingId,
        'transaction_type': 'payment',
        'amount': amount,
        'payment_method': paymentMethod,
        'status': 'completed',
        'transaction_ref': 'PAY${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Payment successful',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Payment failed',
    };
  }

  Future<Map<String, dynamic>> requestPayout({
    required int userId,
    required double amount,
    required String bankAccount,
  }) async {
    final response = await _api.post(
      ApiConfig.requestPayout,
      data: {
        'user_id': userId,
        'amount': amount,
        'bank_account': bankAccount,
        'status': 'pending',
      },
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Payout request submitted',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Payout request failed',
    };
  }
}
