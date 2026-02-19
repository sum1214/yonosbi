import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'package:yonosbi/features/payments/fund_transfer/data/repositories/payee_repository.dart';
import 'package:yonosbi/features/payments/fund_transfer/domain/models/payee_model.dart';
import 'package:yonosbi/features/payments/fund_transfer/presentation/pages/pay_payee_screen.dart';
import 'review_transaction_screen.dart';
import 'package:intl/intl.dart';

class QuickTransferDetailsScreen extends StatefulWidget {
  final String bankName;

  const QuickTransferDetailsScreen({super.key, required this.bankName});

  @override
  State<QuickTransferDetailsScreen> createState() => _QuickTransferDetailsScreenState();
}

class _QuickTransferDetailsScreenState extends State<QuickTransferDetailsScreen> {
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _savePayee = false;
  String _selectedPurpose = 'Purpose (Recommended)';
  double _currentBalance = 10000.0;
  bool _isLoading = false;
  final PayeeRepository _payeeRepository = PayeeRepository();

  final List<String> _purposes = [
    'Transfer to Family or friends',
    'Loan Repayment',
    'Business in service sector',
    'Deposit or Investment',
    'Rent',
    'Bill Payment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _accountNumberController.addListener(_updateState);
    _confirmController.addListener(_onConfirmAccountNumberChanged);
    _nameController.addListener(_updateState);
    _amountController.addListener(_updateState);
  }

  void _onConfirmAccountNumberChanged() async {
    if (_confirmController.text.length >= 9) {
      final payees = await _payeeRepository.getPayees();
      final existingPayee = payees.cast<Payee?>().firstWhere(
        (p) => p?.accountNumber == _confirmController.text,
        orElse: () => null,
      );
      
      if (existingPayee != null && mounted) {
        _showPayeeExistsPopup(existingPayee);
      }
    }
    _updateState();
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentBalance = prefs.getDouble('account_balance') ?? 10000.0;
    });
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  bool _isFormValid() {
    return _accountNumberController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty &&
        _accountNumberController.text == _confirmController.text &&
        _nameController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedPurpose != 'Purpose (Recommended)';
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'HI', symbol: '₹', decimalDigits: 2);
    String formattedBalance = currencyFormat.format(_currentBalance);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                    Text(
                      widget.bankName.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Funds will be transferred on the basis of account number only. IFSC code is not required.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Payee Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              _buildTextField(
                _accountNumberController,
                'Account Number',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                _confirmController,
                'Confirm Account Number',
                keyboardType: TextInputType.number,
                suffixIcon: (_accountNumberController.text.isNotEmpty &&
                        _accountNumberController.text == _confirmController.text)
                    ? const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 20)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _buildTextField(_nameController, 'Account Name', padding: 0)),
                    TextButton(
                      onPressed: () => _showVerificationPopup(),
                      child: const Text('Verify', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Do you want to save payee?', style: TextStyle(fontSize: 13, color: AppColors.primaryPurple)),
                    Switch(
                      value: _savePayee,
                      onChanged: (val) => setState(() => _savePayee = val),
                      activeColor: AppColors.primaryPurple,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Transaction Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              _buildTextField(
                _amountController,
                'Amount',
                helperText: 'Transfer a maximum of ₹50,000 via quick transfer',
                keyboardType: TextInputType.number,
                prefixText: '₹ ',
              ),
              _buildDropdownField(_selectedPurpose),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Paying from', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textGrey)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('XXXXXXXX8881', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Savings Account', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    Text('Current Balance: $formattedBalance/-', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? () async {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(seconds: 2));
                      if (!mounted) return;
                      setState(() => _isLoading = false);
                      
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ReviewTransactionScreen(
                          payeeName: _nameController.text,
                          bankName: widget.bankName,
                          accountNumber: _accountNumberController.text,
                          amount: _amountController.text,
                          remark: _selectedPurpose,
                        ),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid() ? AppColors.primaryPurple : Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: _isFormValid() ? Colors.white : Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? helperText,
    double padding = 16,
    TextInputType? keyboardType,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              prefixText: prefixText,
              suffixIcon: suffixIcon,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
            ),
          ),
          if (helperText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              color: AppColors.primaryPurple.withOpacity(0.05),
              child: Text(helperText, style: const TextStyle(fontSize: 10, color: AppColors.primaryPurple)),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String value) {
    return InkWell(
      onTap: () => _showPurposeSelection(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (value != 'Purpose (Recommended)')
              const Text('Purpose (Recommended)', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: value == 'Purpose (Recommended)' ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showPurposeSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF3b67c9), // Blue color from image
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Purpose (Recommended)',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _purposes.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white24, height: 1),
                  itemBuilder: (context, index) {
                    final purpose = _purposes[index];
                    final isSelected = purpose == _selectedPurpose;
                    return ListTile(
                      title: Text(
                        purpose,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_circle_outline, color: Colors.white) : null,
                      onTap: () {
                        setState(() {
                          _selectedPurpose = purpose;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPayeeExistsPopup(Payee payee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Payee Already Exists',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple.shade50,
                child: Text(payee.name.isNotEmpty ? payee.name[0].toUpperCase() : '?', 
                  style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(payee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(payee.nickname, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Account Number', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    Text(payee.accountNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: const Text('Back', style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PayPayeeScreen(payee: payee)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVerificationPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Payee name verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Payee verification ensures that funds reach the correct recipient', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                const Text('As per the payee\'s bank, name of the account holder is SHUBHAM KUMAR', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Do you want to proceed?', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: AppColors.textGrey),
                      SizedBox(width: 12),
                      Expanded(child: Text('By clicking \'Yes\', you are providing explicit consent to proceed with the transaction for the above payee.', style: TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('No'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
