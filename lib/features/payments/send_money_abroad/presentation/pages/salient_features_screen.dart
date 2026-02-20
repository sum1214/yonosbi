import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class SalientFeaturesScreen extends StatelessWidget {
  const SalientFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Salient features of\nSending Money Abroad',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/2830/2830284.png', // Placeholder for the illustration
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'The forex outward remittance facility is available for customers who meet the following conditions',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  _buildBulletPoint('The customer\'s PAN is updated with the bank (mandatory).'),
                  _buildBulletPoint('The customer has maintained a deposit account with the bank for at least six months prior to the remittance.'),
                  _buildBulletPoint('NRI customers can send permissible remittances through their NRE accounts.'),
                  
                  const SizedBox(height: 24),
                  _buildInfoCard(
                    title: 'Supported currencies',
                    content: 'This facility supports eight currencies:\n• USD, EUR, GBP, SGD, AUD, CAD, NZD and AED.\n• For other currencies, requests must be processed through the branch.',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Daily transfer limit',
                    content: '• Maximum transfer amount: USD 40,000 (or equivalent in foreign currency).',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Charges',
                    content: 'Flat commission fees (inclusive of GST) apply as follows:\n• USD 10, EUR 10, GBP 8, SGD 10, AUD 10, CAD 10, NZD 15, AED 15 (converted using the Bank\'s TT Selling Card rate)',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Processing timelines',
                    content: '• Remittance requests received by 4:30 PM IST are processed the same day.\n• Requests after this time are processed on the next forex business day (excluding weekends and holidays). LRS Limit for Residents\n• Resident individuals can remit up to USD 2,50,000 (or equivalent) in a financial year under the RBI\'s Liberalized Remittance Scheme (LRS).',
                  ),
                  const SizedBox(height: 24),
                  const Text('Contact information', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('For queries regarding foreign outward remittances:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  const Text('Email: fxout.gmuk@sbi.co.in', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textGrey))),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
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
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5)),
        ],
      ),
    );
  }
}
