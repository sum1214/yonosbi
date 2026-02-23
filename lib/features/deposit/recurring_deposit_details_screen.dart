import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../dashboard/presentation/bloc/dashboard_bloc.dart';
import 'recurring_deposit_interest_rates_screen.dart';

class RecurringDepositDetailsScreen extends StatefulWidget {
  const RecurringDepositDetailsScreen({super.key});

  @override
  State<RecurringDepositDetailsScreen> createState() => _RecurringDepositDetailsScreenState();
}

class _RecurringDepositDetailsScreenState extends State<RecurringDepositDetailsScreen> {
  bool _isAccountVisible = false;
  bool _isCalendarVisible = false;
  DateTime? _selectedDate;
  
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _roi = '';
  String _maturityDate = '';
  String _numInstallments = '';
  bool _isDurationValid = true;

  @override
  void initState() {
    super.initState();
    _yearsController.addListener(_updateCalculations);
    _monthsController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    String yText = _yearsController.text;
    String mText = _monthsController.text;

    int years = int.tryParse(yText) ?? 0;
    int months = int.tryParse(mText) ?? 0;

    int totalMonths = (years * 12) + months;

    setState(() {
      bool isAnyFieldEntered = yText.isNotEmpty || mText.isNotEmpty;

      if (isAnyFieldEntered) {
        // RD typically 12 months to 120 months (1 year to 10 years)
        _isDurationValid = totalMonths >= 12 && totalMonths <= 120;
        if (_isDurationValid) {
          _roi = _calculateROI(totalMonths);
          _numInstallments = totalMonths.toString();
          
          // Basic maturity calculation: current date + months
          DateTime now = DateTime.now();
          DateTime matDate = DateTime(now.year, now.month + totalMonths, now.day);
          _maturityDate = DateFormat('dd/MM/yyyy').format(matDate);
        } else {
          _roi = '';
          _maturityDate = '';
          _numInstallments = '';
        }
      } else {
        _isDurationValid = true;
        _roi = '';
        _maturityDate = '';
        _numInstallments = '';
      }
    });
  }

  String _calculateROI(int totalMonths) {
    if (totalMonths >= 60) return '6.05%';
    if (totalMonths >= 36) return '6.30%';
    if (totalMonths >= 24) return '6.40%';
    if (totalMonths >= 12) return '6.25%';
    return '5.90%';
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }

  String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    int? amount = int.tryParse(_amountController.text);
    bool isAmountValid = amount != null && amount >= 100 && amount <= 29999990 && amount % 10 == 0;
    
    bool isAnyDurationEntered = _yearsController.text.isNotEmpty || _monthsController.text.isNotEmpty;

    bool isFormFilled = _amountController.text.isNotEmpty && 
        isAmountValid && 
        _isDurationValid && 
        _roi.isNotEmpty && 
        isAnyDurationEntered &&
        _dateController.text.isNotEmpty;

    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year, now.month, now.day);
    DateTime lastDate = DateTime(now.year, now.month + 1, now.day);

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
              'Open Recurring Deposit',
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
                  'Recurring Deposit Details',
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
                _buildAmountField(),
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
                          MaterialPageRoute(
                            builder: (context) => const RecurringDepositInterestRatesScreen(),
                          ),
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
                    Expanded(child: _buildDurationInput(_yearsController, 'Years', maxLength: 2)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDurationInput(_monthsController, 'Months', maxLength: 2)),
                  ],
                ),
                if (!_isDurationValid && isAnyDurationEntered) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter a valid duration between 1 year and 10 years',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 32),
                _buildDateField(),
                if (_isCalendarVisible) ...[
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F3D91),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Colors.white,
                          onPrimary: Color(0xFF3F3D91),
                          surface: Color(0xFF3F3D91),
                          onSurface: Colors.white,
                        ),
                        textTheme: const TextTheme(
                          bodyMedium: TextStyle(color: Colors.white),
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: _selectedDate ?? now,
                        firstDate: firstDate,
                        lastDate: lastDate,
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                            _dateController.text = _getDayWithSuffix(date.day);
                            _isCalendarVisible = false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
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
                _buildInfoDisplayBox('No. of Installments', _numInstallments, fullWidth: true),
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
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.5)),
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

  Widget _buildAmountField() {
    String? errorText;
    if (_amountController.text.isNotEmpty) {
      int? amount = int.tryParse(_amountController.text);
      if (amount != null) {
        if (amount < 100) {
          errorText = "Minimum Amount should be ₹100.00 for the selected deposit type.";
        } else if (amount > 29999990) {
          errorText = "Amount should not exceed ₹2,99,99,990.00 for the selected deposit type.";
        } else if (amount % 10 != 0) {
          errorText = "Invalid Amount. Please enter the amount in multiples of '10'";
        }
      }
    }
    bool isErrorVisible = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Installment Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('₹ ', style: TextStyle(fontSize: 18, color: Colors.black87)),
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
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

  Widget _buildDurationInput(TextEditingController controller, String label, {int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        TextField(
          controller: controller,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          ],
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Installment Date(Monthly)', style: TextStyle(color: Colors.grey, fontSize: 12)),
        InkWell(
          onTap: _toggleCalendar,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateController.text.isEmpty ? 'Select Date' : _dateController.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: _dateController.text.isEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, color: AppColors.primaryPurple, size: 20),
              ],
            ),
          ),
        ),
      ],
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
