import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../dashboard/presentation/bloc/dashboard_bloc.dart';

class AnnuityDepositDetailsScreen extends StatefulWidget {
  const AnnuityDepositDetailsScreen({super.key});

  @override
  State<AnnuityDepositDetailsScreen> createState() => _AnnuityDepositDetailsScreenState();
}

class _AnnuityDepositDetailsScreenState extends State<AnnuityDepositDetailsScreen> {
  bool _isAccountVisible = false;
  final TextEditingController _amountController = TextEditingController();
  
  String? _selectedDuration;
  String _roi = '';
  String _maturityDate = '';
  String _monthlyPayout = '';

  final List<Map<String, String>> _durationOptions = [
    {'label': '3 Years', 'rate': '6.30%', 'years': '3'},
    {'label': '5 Years', 'rate': '6.05%', 'years': '5'},
    {'label': '7 Years', 'rate': '6.05%', 'years': '7'},
    {'label': '10 Years', 'rate': '6.05%', 'years': '10'},
  ];

  @override
  void initState() {
    super.initState();
    // 3 Years is selected by default
    _selectedDuration = '3 Years';
    _roi = '6.30%';
    _maturityDate = DateFormat('dd/MM/yyyy').format(
      DateTime.now().add(const Duration(days: 3 * 365)),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onDurationSelected(Map<String, String> option) {
    setState(() {
      _selectedDuration = option['label'];
      _roi = option['rate']!;
      int years = int.parse(option['years']!);
      _maturityDate = DateFormat('dd/MM/yyyy').format(
        DateTime.now().add(Duration(days: years * 365)),
      );
      _updateMonthlyPayout();
    });
  }

  void _updateMonthlyPayout() {
    if (_amountController.text.isEmpty || _selectedDuration == null) {
      _monthlyPayout = '';
      return;
    }
    
    double amount = double.tryParse(_amountController.text) ?? 0;
    double rate = double.parse(_roi.replaceAll('%', '')) / 100;
    int months = int.parse(_durationOptions.firstWhere((e) => e['label'] == _selectedDuration)['years']!) * 12;
    
    if (amount > 0) {
      // Simplified Payout = (Principal + Interest) / Months
      double payout = (amount * (1 + rate)) / months;
      _monthlyPayout = '₹ ${payout.toStringAsFixed(2)}';
    } else {
      _monthlyPayout = '';
    }
  }

  String? _getAmountError() {
    if (_amountController.text.isEmpty) return null;
    
    int? amount = int.tryParse(_amountController.text);
    if (amount == null) return null;

    // 1. Duration-based minimum check (Highest priority)
    if (_selectedDuration == '3 Years') {
      if (amount < 32730) return 'Minimum Amount should be ₹32,730.00 for the selected deposit type.';
    } else if (_selectedDuration == '5 Years') {
      if (amount < 51670) return 'Minimum Amount should be ₹51,670.00 for the selected deposit type.';
    } else if (_selectedDuration == '7 Years') {
      if (amount < 68350) return 'Minimum Amount should be ₹68,350.00 for the selected deposit type.';
    } else if (_selectedDuration == '10 Years') {
      if (amount < 89880) return 'Minimum Amount should be ₹89,880.00 for the selected deposit type.';
    }

    // 2. Maximum Limit check
    if (amount > 29999990) {
      return 'Amount should not exceed ₹2,99,99,990.00 for the selected deposit type.';
    }

    // 3. Multiples of 10 check
    if (amount % 10 != 0) {
      return 'Amount should be in multiples of 10';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String? errorText = _getAmountError();
    bool isAmountValid = _amountController.text.isNotEmpty && errorText == null;
    bool isFormFilled = isAmountValid && _selectedDuration != null;

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
              'Open Annuity Deposit',
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
                  'Annuity Deposit Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Debit Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildAccountCard(state),
                const SizedBox(height: 32),
                _buildAmountField(errorText),
                const SizedBox(height: 32),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Duration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
                _buildDurationOptions(),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildInfoDisplayBox('Rate of Interest', _roi)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoDisplayBox('Maturity Date', _maturityDate)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoDisplayBox('Monthly Payout', _monthlyPayout, fullWidth: true),
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
                      _isAccountVisible ? 'XXXXXXXX4135' : 'XXXXXXXX4135',
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

  Widget _buildAmountField(String? errorText) {
    bool isErrorVisible = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('₹ ', style: TextStyle(fontSize: 18, color: Colors.black87)),
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  setState(() {
                    _updateMonthlyPayout();
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isErrorVisible ? Colors.red.shade300 : Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isErrorVisible ? Colors.red : AppColors.primaryPurple),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isErrorVisible) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade900, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationOptions() {
    return Column(
      children: _durationOptions.map((option) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => _onDurationSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedDuration == option['label'] ? AppColors.primaryPurple : Colors.grey.shade300,
                width: _selectedDuration == option['label'] ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option['label']!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
                Text(
                  option['rate']!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3D91)),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildInfoDisplayBox(String label, String value, {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? label : value,
            style: TextStyle(
              color: value.isEmpty ? Colors.grey : Colors.black87,
              fontWeight: value.isEmpty ? FontWeight.normal : FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
