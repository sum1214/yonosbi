import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../../domain/models/payee_model.dart';
import 'package:intl/intl.dart';
import '../../../quicktrasfer/presentation/pages/review_transaction_screen.dart';

class PayPayeeScreen extends StatefulWidget {
  final Payee payee;

  const PayPayeeScreen({super.key, required this.payee});

  @override
  State<PayPayeeScreen> createState() => _PayPayeeScreenState();
}

class _PayPayeeScreenState extends State<PayPayeeScreen> {
  bool _isTransferNow = true;
  String _selectedMode = 'IMPS';
  String _selectedFrequency = 'One Time';
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPurpose;
  DateTime _selectedDate = DateTime.now();
  int _noOfPayments = 2;
  double _currentBalance = 10000.0;

  final List<String> _modes = ['IMPS', 'NEFT', 'RTGS'];
  final List<String> _frequencies = ['One Time', 'Weekly', 'Monthly'];
  final List<String> _purposes = [
    'Transfer to Family or friends',
    'Loan Repayment',
    'Business in service sector',
    'Deposit or Investment',
    'Rent',
    'Bill Payment',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentBalance = prefs.getDouble('account_balance') ?? 18494.55;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    if (_amountController.text.isEmpty) return false;
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return false;
    if (amount > widget.payee.limit) return false;
    if (_selectedPurpose == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'HI', symbol: '₹', decimalDigits: 2);
    String formattedBalance = currencyFormat.format(_currentBalance);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fund Transfer',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPayeeHeader(),
                  const SizedBox(height: 20),
                  _buildCustomTabBar(),
                  const SizedBox(height: 25),
                  if (!_isTransferNow) ...[
                    const Text('Payment Frequency', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _buildFrequencySelector(),
                    const SizedBox(height: 25),
                    _buildDatePicker(),
                    if (_selectedFrequency != 'One Time') ...[
                      const SizedBox(height: 20),
                      _buildNoOfPaymentsSelector(),
                    ],
                    const SizedBox(height: 25),
                  ],
                  const Text('Transaction Details', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildAmountInput(),
                  const SizedBox(height: 25),
                  const Text('Mode of Transfer', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildModeSelector(),
                  const SizedBox(height: 10),
                  Text(
                    _getModeInfo(),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 25),
                  _buildPurposeDropdown(),
                  const SizedBox(height: 25),
                  const Text('Paying from', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildSourceAccount(formattedBalance),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildProceedButton(),
        ],
      ),
    );
  }

  Widget _buildPayeeHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            widget.payee.name[0],
            style: const TextStyle(color: AppColors.primaryPurple, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.payee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${widget.payee.bankName} ${widget.payee.accountNumber}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              Text('Payee Limit ₹${NumberFormat('#,##,###').format(widget.payee.limit)}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Verify', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _isTransferNow = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isTransferNow ? AppColors.primaryPurple.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Transfer Now',
                    style: TextStyle(
                      color: _isTransferNow ? AppColors.primaryPurple : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _isTransferNow = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isTransferNow ? AppColors.primaryPurple.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Schedule Pay',
                    style: TextStyle(
                      color: !_isTransferNow ? AppColors.primaryPurple : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: _frequencies.map((freq) {
          bool isSelected = _selectedFrequency == freq;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedFrequency = freq),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    freq,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryPurple : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDatePicker() {
    String label = _selectedFrequency == 'One Time' ? 'Payment Date' : 'Start Date';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16)),
                const Icon(Icons.calendar_today_outlined, color: AppColors.primaryPurple, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoOfPaymentsSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('No of Payments', style: TextStyle(color: Colors.grey, fontSize: 14)),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_noOfPayments > 1) setState(() => _noOfPayments--);
                },
                icon: const Icon(Icons.remove, size: 18),
              ),
              Text('$_noOfPayments', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => setState(() => _noOfPayments++),
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 14)),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            prefixText: '₹ ',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: _modes.map((mode) {
          bool isSelected = _selectedMode == mode;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedMode = mode),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    mode,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryPurple : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getModeInfo() {
    if (_selectedMode == 'IMPS') return 'Instant Transfer upto ₹5,00,000 per transaction';
    if (_selectedMode == 'NEFT') return 'Transfer any amount within approximately 30 mins';
    return 'Real time gross settlement for amounts above ₹2 Lakhs';
  }

  Widget _buildPurposeDropdown() {
    return InkWell(
      onTap: _showPurposeBottomSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedPurpose ?? 'Purpose (Recommended)',
                  style: TextStyle(
                    color: _selectedPurpose == null ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryPurple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPurposeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF3F81C5), // Blue color from image
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Purpose (Recommended)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _purposes.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white24, height: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      title: Text(
                        _purposes[index],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPurpose = _purposes[index];
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

  Widget _buildSourceAccount(String formattedBalance) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('XXXXXXXX8881', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text('Savings Account', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),
          Text('Available Balance: $formattedBalance/-', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isFormValid ? () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ReviewTransactionScreen(
                bankName: widget.payee.bankName,
                accountNumber: widget.payee.accountNumber,
                amount: _amountController.text,
              ),
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFormValid ? AppColors.primaryPurple : Colors.grey.shade200,
            disabledBackgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: 0,
          ),
          child: Text(
            'Proceed',
            style: TextStyle(
              color: _isFormValid ? Colors.white : Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
