class Transaction {
  final int? id;
  final int? userId;
  final int? bookingId;
  final String transactionType;
  final double amount;
  final String status;
  final String? paymentMethod;
  final String? transactionRef;
  final DateTime? createdAt;

  Transaction({
    this.id,
    this.userId,
    this.bookingId,
    required this.transactionType,
    required this.amount,
    this.status = 'pending',
    this.paymentMethod,
    this.transactionRef,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      bookingId: json['booking_id'] is String ? int.parse(json['booking_id']) : json['booking_id'],
      transactionType: json['transaction_type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'],
      transactionRef: json['transaction_ref'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'booking_id': bookingId,
      'transaction_type': transactionType,
      'amount': amount,
      'status': status,
      'payment_method': paymentMethod,
      'transaction_ref': transactionRef,
    };
  }

  bool get isCredit => transactionType == 'credit' || transactionType == 'refund';
  bool get isDebit => transactionType == 'debit' || transactionType == 'payment';
}

class Wallet {
  final double balance;
  final List<Transaction> recentTransactions;

  Wallet({
    required this.balance,
    this.recentTransactions = const [],
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] ?? 0).toDouble(),
      recentTransactions: (json['transactions'] as List?)
          ?.map((t) => Transaction.fromJson(t))
          .toList() ?? [],
    );
  }
}
