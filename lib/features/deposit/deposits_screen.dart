import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/deposit/annuity_deposit_details_screen.dart';
import 'recurring_deposit_details_screen.dart';
import 'interest_rates_screen.dart';
import 'manage_deposits_screen.dart';
import 'open_fixed_deposit_screen.dart';

class DepositsScreen extends StatelessWidget {
  const DepositsScreen({super.key});

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
          'Deposits',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageDepositsScreen()),
                );
              },
              child: _buildManageDepositsCard(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Text(
                'Open New Deposit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
            _buildDepositGrid(context),
            const SizedBox(height: 40),
            _buildBottomActions(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildManageDepositsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock_outline, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Manage your Deposits',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDepositGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
        children: [
          _buildDepositOption(
            context: context,
            icon: Icons.savings_outlined,
            title: 'Fixed Deposit',
            subtitle: 'Explore a host of FD variants to suit your needs',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OpenFixedDepositScreen()),
              );
            },
          ),
          _buildDepositOption(
            context: context,
            icon: Icons.update,
            title: 'Recurring Deposit',
            subtitle: 'One-time deposit creation that ensures you save every month',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecurringDepositDetailsScreen()),
              );
            },
          ),
          _buildDepositOption(
            context: context,
            icon: Icons.calendar_today_outlined,
            title: 'Annuity Deposit',
            subtitle: 'Invest once and get returns every month',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnnuityDepositDetailsScreen()),
              );
            },
          ),
          _buildDepositOption(
            context: context,
            icon: Icons.sync_alt,
            title: 'Auto Sweep',
            subtitle: 'Let idle funds in your savings account earn more for you',
            isDisabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDepositOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: isDisabled ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: isDisabled ? Colors.grey : Colors.black87, size: 28),
                Icon(Icons.chevron_right, color: isDisabled ? Colors.grey.shade300 : Colors.grey, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.grey : AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDisabled ? Colors.grey.shade400 : Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomActionItem(Icons.calculate_outlined, 'Payout Calculator'),
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
        _buildBottomActionItem(Icons.help_outline, 'FAQs'),
      ],
    );
  }

  Widget _buildBottomActionItem(IconData icon, String label, {VoidCallback? onTap}) {
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
