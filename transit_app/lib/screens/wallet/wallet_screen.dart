import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/custom_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      await Provider.of<WalletProvider>(context, listen: false)
          .fetchWalletData(authProvider.user!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show transaction history
            },
          ),
        ],
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wallet, child) {
          if (wallet.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _loadWalletData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(wallet.balance),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildRecentTransactions(wallet),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddMoneyDialog(),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Money'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Withdraw money
                  },
                  icon: const Icon(Icons.arrow_upward, size: 20),
                  label: const Text('Withdraw'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: AppTheme.headingSmall),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _actionItem(Icons.receipt_long, 'Invoices', () {}),
            _actionItem(Icons.card_giftcard, 'Offers', () {}),
            _actionItem(Icons.help_outline, 'Help', () {}),
            _actionItem(Icons.settings, 'Settings', () {}),
          ],
        ),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(WalletProvider wallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: AppTheme.headingSmall),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (wallet.transactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No transactions yet',
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...wallet.transactions.take(5).map((txn) {
            final isCredit = txn.isCredit;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isCredit ? AppTheme.successColor : AppTheme.errorColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
                title: Text(
                  txn.transactionType.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  txn.transactionRef ?? '',
                  style: AppTheme.bodySmall,
                ),
                trailing: Text(
                  '${isCredit ? '+' : '-'}₹${txn.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  void _showAddMoneyDialog() {
    final amountController = TextEditingController();
    String selectedMethod = 'UPI';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Money', style: AppTheme.headingMedium),
                  const SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹ ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment Method', style: AppTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['UPI', 'Card', 'Net Banking'].map((method) {
                      final isSelected = selectedMethod == method;
                      return ChoiceChip(
                        label: Text(method),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() => selectedMethod = method);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Add Money',
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text);
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid amount'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                        return;
                      }

                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final success = await Provider.of<WalletProvider>(context, listen: false)
                          .addMoney(authProvider.user!.id!, amount, selectedMethod);

                      if (success && mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Money added successfully'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
