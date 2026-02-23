import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'fixed_deposit_details_screen.dart';
import 'interest_rates_screen.dart';

class OpenFixedDepositScreen extends StatefulWidget {
  const OpenFixedDepositScreen({super.key});

  @override
  State<OpenFixedDepositScreen> createState() => _OpenFixedDepositScreenState();
}

class _OpenFixedDepositScreenState extends State<OpenFixedDepositScreen> {
  int? _expandedIndex;

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Open Fixed Deposit',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Header
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              'Select FD Variant',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ),

          // Scrollable List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                _buildFdVariantOption(
                  index: 0,
                  icon: Icons.savings_outlined,
                  title: 'Regular FD',
                  subtitle: 'Duration up to 10 years',
                  details: [
                    'Duration up to 10 years',
                    'Withdraw anytime',
                    'Avail overdraft against regular FD',
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedDepositDetailsScreen(initialVariant: 'Regular FD'),
                      ),
                    );
                  },
                ),
                _buildFdVariantOption(
                  index: 1,
                  icon: Icons.money_outlined,
                  title: 'Tax Saver FD',
                  subtitle: 'Save Tax',
                  details: [
                    'Save tax under Section 80C',
                    'Maximum ₹1,50,000 per financial year',
                    'Minimum 5 years lock-in',
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedDepositDetailsScreen(initialVariant: 'Tax Saver FD'),
                      ),
                    );
                  },
                ),
                _buildFdVariantOption(
                  index: 2,
                  icon: Icons.shield_outlined,
                  title: 'Multi Option Deposit',
                  subtitle: 'Flexi FD for higher liquidity',
                  details: [
                    'Minimum ₹15000.00',
                    'Linked to transaction account',
                    'Automatic partial withdrawal in case of low balance in transaction account',
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedDepositDetailsScreen(initialVariant: 'Multi Option Deposit'),
                      ),
                    );
                  },
                ),
                _buildFdVariantOption(
                  index: 3,
                  icon: Icons.eco_outlined,
                  title: 'Green FD',
                  subtitle: 'Contribute to a better environment',
                  details: [
                    'Fixed duration of 1111 days, 1777 days, or 2222 days',
                    'Your funds are used towards environmentally responsible investments',
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedDepositDetailsScreen(initialVariant: 'Green FD'),
                      ),
                    );
                  },
                ),
                _buildFdVariantOption(
                  index: 4,
                  icon: Icons.auto_graph_outlined,
                  title: 'Non-Callable FD',
                  subtitle: 'Higher rate of interest',
                  details: [
                    'Higher rate of interest',
                    'Minimum ₹1 Crore',
                    'Fixed duration of 1 year or 2 years',
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedDepositDetailsScreen(initialVariant: 'Non-Callable FD'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Static Bottom Actions
          Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomActionItem(Icons.calculate_outlined, 'Payout Calculator', onTap: () {}),
                _buildBottomActionItem(
                  Icons.trending_up, 
                  'Interest Rates',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InterestRatesScreen()),
                    );
                  },
                ),
                _buildBottomActionItem(Icons.help_outline, 'FAQs', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFdVariantOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> details,
    VoidCallback? onTap,
  }) {
    bool isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryPurple, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _toggleExpand(index),
                        child: Row(
                          children: [
                            Text(
                              isExpanded ? 'Know less' : 'Know more',
                              style: const TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: AppColors.primaryPurple,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
                  onPressed: onTap,
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details
                    .map((detail) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Icon(Icons.circle, size: 4, color: Colors.black87),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  detail,
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionItem(IconData icon, String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon, color: Colors.grey.shade600, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
