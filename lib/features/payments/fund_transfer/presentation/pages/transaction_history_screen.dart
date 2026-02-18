import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../../domain/models/transaction_model.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for display
    final List<TransactionModel> transactions = [
      TransactionModel(
        bankIcon: 'https://vignette.wikia.nocookie.net/logopedia/images/b/b8/HDFC_Bank_logo.png',
        type: 'IMPS',
        title: 'Transfer to Payee',
        accountNumber: '1255000100261586',
        dateTime: '18/02/2025 at 9:48 AM',
        amount: 1.00,
        isSuccessful: true,
        category: 'Transfer to Family or friends',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(Icons.filter_list, color: Colors.grey.shade700),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionItem(tx);
              },
            ),
          ),
          _buildBottomInfo(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.network(
                  tx.bankIcon,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, color: Colors.blue, size: 20),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.type,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tx.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Acc No ${tx.accountNumber}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      tx.dateTime,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ ${tx.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tx.isSuccessful ? 'SUCCESSFUL' : 'FAILED',
                        style: TextStyle(
                          color: tx.isSuccessful ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (tx.isSuccessful)
                        const Icon(Icons.check_circle, color: Colors.green, size: 14),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.label_outline, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  tx.category,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Divider(color: Colors.grey.shade200, height: 1),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.blue.shade300),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Only last 150 transactions made over the past 12 months can be displayed here.',
              style: TextStyle(color: Color(0xFF5A7EA8), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
