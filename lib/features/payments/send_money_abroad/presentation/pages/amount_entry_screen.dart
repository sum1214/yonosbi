import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/payments/upi/presentation/bloc/payment_bloc.dart';
import 'review_transaction_screen.dart';

class AmountEntryScreen extends StatefulWidget {
  const AmountEntryScreen({super.key});

  @override
  State<AmountEntryScreen> createState() => _AmountEntryScreenState();
}

class _AmountEntryScreenState extends State<AmountEntryScreen> {
  final TextEditingController _inrController = TextEditingController();
  final TextEditingController _usdController = TextEditingController();
  final double _exchangeRate = 82.35;
  bool _isProceedEnabled = false;

  @override
  void initState() {
    super.initState();
    _inrController.addListener(_onInrChanged);
  }

  @override
  void dispose() {
    _inrController.dispose();
    _usdController.dispose();
    super.dispose();
  }

  void _onInrChanged() {
    final text = _inrController.text;
    if (text.isEmpty) {
      _usdController.text = "";
      setState(() => _isProceedEnabled = false);
      return;
    }

    final double? inr = double.tryParse(text.replaceAll(',', ''));
    if (inr != null) {
      final double usd = inr / _exchangeRate;
      _usdController.text = usd.toStringAsFixed(2);
      setState(() => _isProceedEnabled = inr > 0);
    } else {
      _usdController.text = "";
      setState(() => _isProceedEnabled = false);
    }
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewTransactionScreen(amount: _inrController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double inrValue = double.tryParse(_inrController.text.replaceAll(',', '')) ?? 0;
    final double usdValue = double.tryParse(_usdController.text) ?? 0;
    final double payeeTransferAmount = (usdValue - 10).clamp(0, double.infinity);
    final double totalDebitAmount = inrValue > 0 ? inrValue + 274.54 : 0;

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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can transfer max of USD 2,50,000 equivalent in a financial year and max of USD 40,000 per day',
                      style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Amount', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          radius: 16,
                          child: const Text('₹', style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(width: 12),
                        const Text('INR', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Expanded(
                          child: TextField(
                            controller: _inrController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(border: InputBorder.none, hintText: "0.00"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_vert, color: Colors.white, size: 20),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          radius: 16,
                          child: const Text('\$', style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(width: 12),
                        const Text('USD', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Expanded(
                          child: TextField(
                            controller: _usdController,
                            textAlign: TextAlign.right,
                            readOnly: true,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(border: InputBorder.none, hintText: "0.00"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Min \$25 - Max \$40,000', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Amount in USD', 'USD ${usdValue.toStringAsFixed(2)}'),
                  _buildDetailRow('Exchange rate USD', 'INR $_exchangeRate', isSubtitle: true),
                  const Divider(),
                  _buildDetailRow('Amount in rupees', 'INR ${inrValue.toStringAsFixed(2)}'),
                  _buildDetailRow('Bank commission (Payee)', 'USD 10', isSubtitle: true),
                  const Divider(),
                  _buildDetailRow('Charge type (Payee)', 'USD 00'),
                  const Divider(),
                  _buildDetailRow('Payee transfer amount', 'USD ${payeeTransferAmount.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildDetailRow('Tax collected at source', 'INR 0.0', hasInfo: true),
                  const Divider(),
                  _buildDetailRow('GST', 'INR 274.54'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildDetailRow('Total debit amount', 'INR ${totalDebitAmount.toStringAsFixed(2)}', isBold: true),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose account to pay with', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color(0xFF0054A6), shape: BoxShape.circle),
                              child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('XXXXXXXX4776', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const Text('Savings Account', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                  Text('Available Balance: ₹ ${state.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: ElevatedButton(
                onPressed: _isProceedEnabled ? _showReviewBottomSheet : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: AppColors.primaryPurple.withOpacity(0.2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Proceed', style: TextStyle(color: _isProceedEnabled ? Colors.white : Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isSubtitle = false, bool isBold = false, bool hasInfo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isSubtitle ? 11 : 13,
                      color: isSubtitle ? AppColors.textGrey : AppColors.textDark,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasInfo) const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Icon(Icons.info_outline, size: 14, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
