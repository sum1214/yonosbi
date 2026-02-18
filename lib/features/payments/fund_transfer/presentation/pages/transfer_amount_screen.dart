import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class TransferAmountScreen extends StatefulWidget {
  final String name;
  final String accNo;

  const TransferAmountScreen({
    super.key,
    required this.name,
    required this.accNo,
  });

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          'Transfer',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.account_balance, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(widget.accNo, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: '0',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Remark (Optional)', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _remarkController,
              decoration: const InputDecoration(
                hintText: 'What is this for?',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showSuccessDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text('Payment Successful', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('₹ ${_amountController.text} sent to ${widget.name}', textAlign: TextAlign.center),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
