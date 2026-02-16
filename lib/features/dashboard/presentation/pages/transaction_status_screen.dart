import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class TransactionStatusScreen extends StatelessWidget {
  final bool isSuccess;
  final String amount;
  final String contactName;
  final String upiId;

  const TransactionStatusScreen({
    super.key,
    required this.isSuccess,
    required this.amount,
    required this.contactName,
    required this.upiId,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('dd/MM/yyyy').format(now);
    final time = DateFormat('hh:mm aa').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isSuccess ? Colors.green : const Color(0xFFD32F2F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          isSuccess ? 'Transaction Successful' : 'Transaction Failed',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.green : const Color(0xFFD32F2F),
                    size: 60,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '₹$amount',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildRecipientCard(),
                  if (!isSuccess) _buildFailureReason(),
                  const SizedBox(height: 10),
                  _buildDateTimeCard(date, time),
                  const SizedBox(height: 10),
                  _buildBankDetailsCard(),
                  const SizedBox(height: 30),
                  _buildActionButton(context),
                  const SizedBox(height: 20),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple.shade50,
            child: Text(contactName[0], style: const TextStyle(color: AppColors.primaryPurple)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contactName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(upiId, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFailureReason() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFA39E)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Money was not debited', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFD32F2F))),
                SizedBox(height: 4),
                Text(
                  'You entered an invalid UPI PIN. After 3 unsuccessful attempts, you will be asked to reset your UPI PIN. Note that this is not your ATM PIN.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateTimeCard(String date, String time) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Transaction Date', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Transaction Time', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transferred from', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('STATE BANK OF INDIA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('8881', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              if (!isSuccess)
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.account_balance, size: 16),
                  label: const Row(
                    children: [
                      Text('Reset UPI PIN', style: TextStyle(fontSize: 12)),
                      Icon(Icons.chevron_right, size: 16),
                    ],
                  ),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue.shade800),
                )
            ],
          ),
          const Divider(height: 20),
          const Text('UPI transaction ID', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const Text('100432936509', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (isSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(
          isSuccess ? 'Go to Home' : 'Retry Payment',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Powered by | ', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          'UPI',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
