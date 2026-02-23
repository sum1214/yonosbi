import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String amount;
  final String payeeName;
  final String bankName;
  final String accountNumber;
  final String remark;

  const TransactionSuccessScreen({
    super.key,
    this.amount = '1.00',
    this.payeeName = 'Shubham Kumar',
    this.bankName = 'PUNJAB NATIONAL BANK',
    this.accountNumber = '1255000105261585',
    this.remark = 'Transfer to Family or friends',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // Green color
            ),
            child: Column(
              children: [
                const Text(
                  'Transaction Successful!',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check, color: Color(0xFF4CAF50), size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  '₹ ${amount.isEmpty ? "1.00" : amount}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  remark,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoCard([
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.purple.shade50,
                            child: Text(
                              payeeName.isNotEmpty ? payeeName[0].toUpperCase() : 'P', 
                              style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12)
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${bankName.toUpperCase()}:', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              Text(accountNumber, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                            ],
                          ),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Do you want to save payee?', style: TextStyle(fontSize: 13, color: AppColors.primaryPurple)),
                          Switch(
                            value: false,
                            onChanged: (v) {},
                          ),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transaction Date', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              Text('18/02/2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transaction Time', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              Text('09:48 AM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      const Text('Debit Account', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      const Text('Savings Account - XXXXXXXX1234', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 12),
                      const Text('Transaction Number', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      const Text('Y2M1239803510304804864', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('View Details >', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
