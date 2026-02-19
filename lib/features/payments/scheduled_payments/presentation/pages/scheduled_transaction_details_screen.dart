import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../../domain/models/scheduled_payment_model.dart';

class ScheduledTransactionDetailsScreen extends StatelessWidget {
  final ScheduledPayment payment;

  const ScheduledTransactionDetailsScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scheduled Transaction Details',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildScheduledInfo(),
                        const SizedBox(height: 15),
                        _buildTransactionSummary(),
                        const SizedBox(height: 15),
                        _buildPayeeDetails(),
                        const SizedBox(height: 20),
                        _buildWarningBox(),
                        const SizedBox(height: 20),
                        _buildLodgeComplaint(),
                        const SizedBox(height: 20),
                        _buildPromoBanner(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 25,
            child: Text(payment.payeeName[0], style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.payeeName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${payment.bankName}: XXXXXXXX1234',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${payment.frequency} Payment Scheduled for',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            payment.date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('Amount', '₹${payment.amount}'),
          const Divider(height: 20),
          _buildDetailRow('Mode of Transfer', 'IMPS'),
          const Divider(height: 20),
          _buildDetailRow('Transaction Date & Time:', payment.scheduledTime),
        ],
      ),
    );
  }

  Widget _buildPayeeDetails() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailColumn('Name', payment.payeeName),
          const Divider(height: 20),
          _buildDetailColumn('Account Number', 'XXXXXXXX1234'),
          const Divider(height: 20),
          _buildDetailColumn('Bank', payment.bankName),
          const Divider(height: 20),
          _buildDetailColumn('Bank IFSC', '${payment.bankName.substring(0, payment.bankName.length > 4 ? 4 : payment.bankName.length).toUpperCase()}0001960'),
          const Divider(height: 20),
          _buildDetailColumn('Debit Account', 'Savings Account - XXXXXXXX1234'),
          const Divider(height: 20),
          _buildDetailColumn('Payment Frequency', payment.frequency),
          const Divider(height: 20),
          _buildDetailColumn('Acknowledgement Number', '1240172071783251968'),
          const Divider(height: 20),
          _buildDetailColumn('Remarks', payment.remark),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Please maintain sufficient balance in the account and transaction limits on the scheduled date of transfer to avoid any transaction failures.',
              style: TextStyle(color: Colors.blue.shade900, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLodgeComplaint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Having any issues? ', style: TextStyle(fontSize: 13)),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Lodge a complaint here',
            style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 13, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x100?text=YONO+SBI+Banner'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: double.infinity,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
