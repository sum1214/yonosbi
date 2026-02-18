import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

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
              color: Color(0xFF4CAF50), // Green color from image
            ),
            child: const Column(
              children: [
                Text(
                  'Transaction Successful!',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check, color: Color(0xFF4CAF50), size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  '₹ 1.00',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Transfer to Family or friends',
                  style: TextStyle(color: Colors.white, fontSize: 12),
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
                            child: const Text('SK', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Shubham Kumar', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('PUNJAB NATIONAL BANK:', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              Text('1255000105261585', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
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
                      const Text('Savings Account - 20451208881', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
