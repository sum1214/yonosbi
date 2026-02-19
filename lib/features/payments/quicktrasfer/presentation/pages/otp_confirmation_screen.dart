import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'transaction_success_screen.dart';
import '../../../scheduled_payments/data/repositories/scheduled_payment_repository.dart';
import '../../../scheduled_payments/domain/models/scheduled_payment_model.dart';
import 'package:intl/intl.dart';

class OtpConfirmationScreen extends StatefulWidget {
  final bool isScheduled;
  final String? date;
  final String? frequency;
  final String? remark;
  final String? payeeName;
  final String? bankName;
  final String? accountNumber;
  final String? amount;

  const OtpConfirmationScreen({
    super.key,
    this.isScheduled = false,
    this.date,
    this.frequency,
    this.remark,
    this.payeeName,
    this.bankName,
    this.accountNumber,
    this.amount,
  });

  @override
  State<OtpConfirmationScreen> createState() => _OtpConfirmationScreenState();
}

class _OtpConfirmationScreenState extends State<OtpConfirmationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isSubmitEnabled = false;
  final ScheduledPaymentRepository _repository = ScheduledPaymentRepository();

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkOtp);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _checkOtp() {
    setState(() {
      _isSubmitEnabled = _controllers.every((c) => c.text.isNotEmpty);
    });
  }

  Future<void> _handleSuccess() async {
    if (widget.isScheduled) {
      final payment = ScheduledPayment(
        payeeName: widget.payeeName ?? 'Unknown',
        bankName: widget.bankName ?? 'Unknown',
        accountNumber: widget.accountNumber ?? '',
        amount: widget.amount ?? '0',
        date: widget.date ?? '',
        frequency: widget.frequency ?? 'One Time',
        remark: widget.remark ?? 'Transfer to Family or friends',
        scheduledTime: DateFormat('dd/MM/yyyy at hh:mm a').format(DateTime.now()),
      );
      await _repository.saveScheduledPayment(payment);
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionSuccessScreen()),
    );
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
          'Quick Transfer',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.black.withOpacity(0.05),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF3b67c9), // Blue color from image
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'OTP Confirmation',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white.withOpacity(0.1),
                    child: const Text(
                      'An OTP has been sent to the registered mobile number. The OTP will expire in 00:45s',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.textGrey, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Only one OTP validation is allowed per request. Please verify before submitting',
                            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _otpBox(index),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Text('RESEND OTP ', style: TextStyle(color: Colors.white, fontSize: 12)),
                        const Text('15s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _isSubmitEnabled ? _handleSuccess : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSubmitEnabled ? Colors.white : Colors.white.withOpacity(0.3),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: _isSubmitEnabled ? const Color(0xFF3b67c9) : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return Container(
      width: 40,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
