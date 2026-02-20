import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'terms_conditions_screen.dart';

class FormA2DetailsScreen extends StatelessWidget {
  const FormA2DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Send Money Abroad', 
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones_outlined, color: AppColors.textDark),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Purpose of remittance', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
            const Text('Education', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 16)),
            const SizedBox(height: 24),
            const Text('Form A2 details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 16),
            
            _buildDropdown('Source of funds'),
            const SizedBox(height: 16),
            _buildDropdown('Ultimate country name'),
            const SizedBox(height: 16),
            _buildDropdown('Transactor institutional sector code'),
            const SizedBox(height: 16),
            _buildDropdown('Counterparty institutional sector code'),
            const SizedBox(height: 24),
            
            const Text('Remarks', style: TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select', style: TextStyle(fontSize: 14)),
              items: const [],
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }
}
