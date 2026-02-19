import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class InterestRatesScreen extends StatelessWidget {
  const InterestRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deposits',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interest Rates',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            _buildRateSection(
              title: 'Domestic Term Deposit - General',
              rates: [
                ['7 Days to 45 Days', '3.05%'],
                ['46 Days to 180 Days', '4.90%'],
                ['181 Days to 210 Days', '5.65%'],
                ['211 Days to less than 1 Year', '5.90%'],
                ['1 Year to less than 2 Years', '6.25%'],
                ['Amrit Vrishiti 444', '6.45%'],
                ['2 Years to less than 3 Years', '6.40%'],
                ['3 Years to less than 5 Years', '6.30%'],
                ['5 Years and upto 10 Years', '6.05%'],
              ],
            ),
            const SizedBox(height: 32),
            _buildRateSection(
              title: 'Green Rupee TD - General',
              rates: [
                ['1111 Days', '6.20%'],
                ['1777 Days', '6.20%'],
                ['2222 Days', '5.95%'],
              ],
            ),
            const SizedBox(height: 32),
            _buildRateSection(
              title: 'Non-callable Deposit - General',
              rates: [
                ['1 Year', '6.55%'],
                ['2 Years', '6.80%'],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRateSection({required String title, required List<List<String>> rates}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Duration', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Interest Rate', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        ...rates.asMap().entries.map((entry) {
          int idx = entry.key;
          List<String> rate = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: idx % 2 == 0 ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rate[0],
                    style: const TextStyle(
                      color: Color(0xFF303F9F),
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  rate[1],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
