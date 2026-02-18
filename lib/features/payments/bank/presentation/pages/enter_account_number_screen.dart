import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/payments/upi/presentation/pages/transaction_screen.dart';

class EnterAccountNumberScreen extends StatefulWidget {
  final String bankName;
  final String bankLogo;

  const EnterAccountNumberScreen({
    super.key,
    required this.bankName,
    required this.bankLogo,
  });

  @override
  State<EnterAccountNumberScreen> createState() => _EnterAccountNumberScreenState();
}

class _EnterAccountNumberScreenState extends State<EnterAccountNumberScreen> {
  final TextEditingController _accountNumberController = TextEditingController();
  bool _isVerifyEnabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _accountNumberController.addListener(_validateInput);
  }

  void _validateInput() {
    final text = _accountNumberController.text;
    setState(() {
      if (text.isEmpty) {
        _errorText = null;
        _isVerifyEnabled = false;
      } else if (text.length <= 8) {
        _errorText = 'Invalid Account Number';
        _isVerifyEnabled = false;
      } else {
        _errorText = null;
        _isVerifyEnabled = true;
      }
    });
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pay to Bank Account',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.account_balance, color: AppColors.primaryPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.bankName.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Change', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(
                labelText: 'Enter Account Number',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _errorText != null ? Colors.red : Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _errorText != null ? Colors.red : AppColors.primaryPurple),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            if (_errorText != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                ),
                child: Text(
                  _errorText!,
                  style: TextStyle(color: Colors.red.shade800, fontSize: 12),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isVerifyEnabled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionScreen(
                              contactName: 'SHUBHAM KUMAR',
                              contactPhone: '50100803999811',
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: AppColors.primaryPurple.withOpacity(0.2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: _isVerifyEnabled ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
