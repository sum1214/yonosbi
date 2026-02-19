import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import 'interest_rates_screen.dart';

class FixedDepositDetailsScreen extends StatefulWidget {
  final String initialVariant;
  const FixedDepositDetailsScreen({super.key, this.initialVariant = 'Regular FD'});

  @override
  State<FixedDepositDetailsScreen> createState() => _FixedDepositDetailsScreenState();
}

class _FixedDepositDetailsScreenState extends State<FixedDepositDetailsScreen> {
  bool _isAccountVisible = false;
  late String _selectedVariant;
  
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  final List<String> _fdVariants = [
    'Regular FD',
    'Tax Saver FD',
    'Multi Option Deposit',
    'Green FD',
    'Non-Callable FD',
  ];

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.initialVariant;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _showVariantSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF6A1B9A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FD Variant',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ..._fdVariants.map((variant) => Column(
                children: [
                  ListTile(
                    title: Text(
                      variant,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: _selectedVariant == variant
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Color(0xFF6A1B9A), size: 16),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedVariant = variant;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
                  ),
                ],
              )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFormFilled = _amountController.text.isNotEmpty && 
        (_yearsController.text.isNotEmpty || _monthsController.text.isNotEmpty || _daysController.text.isNotEmpty);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
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
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.headset_mic_outlined, color: Colors.black54),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fixed Deposit Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 32),
                _buildVariantSelector(),
                const SizedBox(height: 32),
                const Text(
                  'Debit Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildAccountCard(state),
                const SizedBox(height: 32),
                _buildTextField(_amountController, 'Enter Amount'),
                const SizedBox(height: 32),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InterestRatesScreen()),
                        );
                      },
                      child: const Text(
                        'Interest Rates',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Deposit Duration',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The interest rates differ based on duration of the deposit. Select your preferred duration.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildDurationInput(_yearsController, 'Years')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDurationInput(_monthsController, 'Months')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDurationInput(_daysController, 'days')),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildInfoDisplayBox('Rate of Interest')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoDisplayBox('Maturity Date')),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormFilled ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormFilled ? AppColors.primaryPurple : Colors.grey.shade200,
                      foregroundColor: isFormFilled ? Colors.white : Colors.grey.shade500,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVariantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FD Variant', style: TextStyle(color: Colors.grey, fontSize: 12)),
        InkWell(
          onTap: _showVariantSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedVariant, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard(DashboardState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF0066B3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _isAccountVisible ? '36991604135' : 'XXXXXXXX4135',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isAccountVisible = !_isAccountVisible),
                      child: Icon(
                        _isAccountVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
                const Text('Savings Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Available Balance: ₹ ${state.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
      ),
    );
  }

  Widget _buildDurationInput(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        TextField(
          controller: controller,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoDisplayBox(String label) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
