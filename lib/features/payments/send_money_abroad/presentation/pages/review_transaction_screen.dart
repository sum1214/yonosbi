import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'form_a2_details_screen.dart';

class ReviewTransactionScreen extends StatelessWidget {
  final String amount;
  const ReviewTransactionScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Review transaction details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 24),
          Text(
            '₹$amount',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Education', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1),
          const SizedBox(height: 24),
          
          _buildDetailSection(
            label: 'To',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE8EAF6),
                  child: const Text('JD', style: TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jane D', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('ABCD bank : 19327643547', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                    Text('SWIFT code : NARBNPKA', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          _buildDetailSection(
            label: 'From',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFF0054A6), shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Savings Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('Account number: 012345678901', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FormA2DetailsScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDetailSection({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
