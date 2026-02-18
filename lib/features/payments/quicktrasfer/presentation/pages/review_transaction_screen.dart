import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/payments/quicktrasfer/presentation/pages/otp_confirmation_screen.dart';

class ReviewTransactionScreen extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final String amount;

  const ReviewTransactionScreen({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.amount,
  });

  @override
  State<ReviewTransactionScreen> createState() => _ReviewTransactionScreenState();
}

class _ReviewTransactionScreenState extends State<ReviewTransactionScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Review Transaction Details',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '₹ ${widget.amount.isEmpty ? "1" : widget.amount}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Transfer to Family or friends',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mode of Transfer: IMPS',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            _buildSection('To', [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple.shade50,
                    child: const Text(
                      'SK',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shubham Kumar',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.bankName.toUpperCase()}:',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                        Text(
                          widget.accountNumber.isEmpty ? '1255000105261585' : widget.accountNumber,
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('From', [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1a469a), // SBI Blue
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 4,
                              height: 6,
                              color: const Color(0xFF1a469a),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Savings Account',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Account Number: XXXXXXXX8881',
                          style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 24),
            _buildInfoBox(
              'Your financial well-being is our priority. Make sure you know the beneficiary to whom you are sending money. Be cautious of scams involving promises of high returns or fraudsters impersonating government officials. Stay vigilant!',
            ),
            const SizedBox(height: 12),
            _buildInfoBox(
              'Please verify the details and accept the "terms and conditions".',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isAgreed,
                    onChanged: (v) => setState(() => _isAgreed = v ?? false),
                    activeColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I have read & agreed to the ',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isAgreed
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const OtpConfirmationScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAgreed ? AppColors.primaryPurple : Colors.grey.shade200,
                      foregroundColor: _isAgreed ? Colors.white : Colors.grey,
                      elevation: 0,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: Color(0xFF1967D2)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1967D2), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
