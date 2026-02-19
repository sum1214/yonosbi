import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'package:yonosbi/features/payments/upi/presentation/bloc/payment_bloc.dart';
import 'upi_pin_screen.dart';

class TransactionScreen extends StatefulWidget {
  final String contactName;
  final String contactPhone;
  final bool shouldShowLoader;

  const TransactionScreen({
    super.key, 
    required this.contactName, 
    required this.contactPhone,
    this.shouldShowLoader = false,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _errorText;
  bool _isPayEnabled = false;
  bool _isInitialLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(ResetBalanceVisibility());
    _amountController.addListener(_validateAmount);
    
    if (widget.shouldShowLoader) {
      _startInitialLoading();
    }
  }

  Future<void> _startInitialLoading() async {
    setState(() {
      _isInitialLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    final String value = _amountController.text;
    if (value.isEmpty) {
      setState(() {
        _errorText = null;
        _isPayEnabled = false;
      });
      return;
    }

    final double? amount = double.tryParse(value);
    if (amount == null || amount < 1.0) {
      setState(() {
        _errorText = 'Cannot make payment less than ₹1.\nThe minimum amount you can enter is ₹1.\nPlease try again.';
        _isPayEnabled = false;
      });
    } else {
      setState(() {
        _errorText = null;
        _isPayEnabled = true;
      });
    }
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPaymentMethodSheet(),
    );
  }

  Widget _buildPaymentMethodSheet() {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose method to pay with',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BANK ACCOUNTS',
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add New'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primaryPurple),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryPurple.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryPurple.withOpacity(0.02),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0054A6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STATE BANK OF INDIA 8881',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Savings Account',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  context.read<PaymentBloc>().add(CheckBalance());
                                },
                                child: Text(
                                  state.showBalance 
                                      ? '₹ ${state.balance.toStringAsFixed(2)}' 
                                      : 'Check Balance',
                                  style: TextStyle(
                                    color: AppColors.primaryPurple, 
                                    fontSize: 12, 
                                    decoration: state.showBalance ? TextDecoration.none : TextDecoration.underline,
                                    fontWeight: state.showBalance ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.radio_button_checked, color: AppColors.primaryPurple),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isPayEnabled ? () {
                    Navigator.pop(context); // Close sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpiPinScreen(
                          amount: _amountController.text,
                          contactName: widget.contactName,
                        ),
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Pay ₹${_amountController.text.isEmpty ? '0' : _amountController.text}',
                    style: TextStyle(color: _isPayEnabled ? Colors.white : Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Powered by | ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      'UPI',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = widget.contactName;
    final String initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
    
    // Clean phone number: remove +91 and any non-digit characters
    String cleanedPhone = widget.contactPhone.replaceAll(RegExp(r'^(\+91|91)'), '').replaceAll(RegExp(r'[^0-9]'), '');
    
    final String upiId = cleanedPhone.isNotEmpty ? '$cleanedPhone@sbi' : widget.contactName.replaceAll(" ", "").toLowerCase()+"@sbi";

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading || _isInitialLoading,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Paying',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    upiId,
                                    style: TextStyle(color: Colors.blue.shade900, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              initials,
                              style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '₹',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                IntrinsicWidth(
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: '0',
                                      hintStyle: TextStyle(color: AppColors.primaryPurple, fontSize: 48, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Add Note',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade800, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorText!,
                                  style: TextStyle(color: Colors.red.shade900, fontSize: 12, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          'PAYING WITH',
                          style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _showPaymentMethodSheet,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0054A6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'STATE BANK OF INDIA 8881',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      'Savings Account',
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isPayEnabled ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpiPinScreen(
                                  amount: _amountController.text,
                                  contactName: widget.contactName,
                                ),
                              ),
                            );
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Pay ${_amountController.text.isEmpty ? '' : '₹${_amountController.text}'}',
                            style: TextStyle(color: _isPayEnabled ? Colors.white : Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Powered by | ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(
                              'UPI',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
