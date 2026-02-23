import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../dashboard/presentation/bloc/dashboard_bloc.dart';
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

  String _roi = '';
  String _maturityDate = '';
  bool _isDurationValid = true;

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
    _yearsController.addListener(_updateCalculations);
    _monthsController.addListener(_updateCalculations);
    _daysController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    String yText = _yearsController.text;
    String mText = _monthsController.text;
    String dText = _daysController.text;

    int years = int.tryParse(yText) ?? 0;
    int months = int.tryParse(mText) ?? 0;
    int days = int.tryParse(dText) ?? 0;

    // Handle 10 years limit logic
    if (years >= 10) {
      if ((months > 0 || days > 0) || (mText.isNotEmpty && mText != '0') || (dText.isNotEmpty && dText != '0')) {
        _monthsController.text = '0';
        _daysController.text = '0';
        return; // Listener will fire again
      }
    }

    int totalDays = (years * 365) + (months * 30) + days;

    setState(() {
      bool isAnyFieldEntered = yText.isNotEmpty || mText.isNotEmpty || dText.isNotEmpty;

      if (isAnyFieldEntered) {
        // Valid if between 7 days and 10 years (3650 days)
        _isDurationValid = totalDays >= 7 && totalDays <= 3650;
        if (_isDurationValid) {
          _roi = _calculateROI(years, months, days);
          _maturityDate = DateFormat('dd/MM/yyyy').format(
            DateTime.now().add(Duration(days: totalDays)),
          );
        } else {
          _roi = '';
          _maturityDate = '';
        }
      } else {
        _isDurationValid = true; // Don't show error if all empty
        _roi = '';
        _maturityDate = '';
      }
    });
  }

  String _calculateROI(int y, int m, int d) {
    int totalDays = (y * 365) + (m * 30) + d;

    if (_selectedVariant == 'Tax Saver FD') {
      if (totalDays >= 1825 && totalDays <= 3650) return '6.05%';
      return '';
    }

    if (_selectedVariant == 'Multi Option Deposit') {
      if (totalDays >= 365 && totalDays < 730) return '6.25%';
      if (totalDays >= 730 && totalDays < 1095) return '6.40%';
      if (totalDays >= 1095 && totalDays < 1825) return '6.30%';
      if (totalDays >= 1825 && totalDays <= 3650) return '6.05%';
      return '';
    }

    if (_selectedVariant == 'Green FD') {
      if (totalDays == 1111) return '6.20%';
      if (totalDays == 1777) return '6.20%';
      if (totalDays == 2222) return '5.95%';
      return '';
    }

    if (_selectedVariant == 'Non-Callable FD') {
      if (totalDays == 365) return '6.55%';
      if (totalDays == 730) return '6.80%';
      return '';
    }

    // Default/Regular FD logic
    if (totalDays < 7) return '';
    if (totalDays == 444) return '6.45%'; // Specific Amrit Vrishti
    if (totalDays <= 45) return '3.05%';
    if (totalDays <= 180) return '4.90%';
    if (totalDays <= 210) return '5.65%';
    if (totalDays < 365) return '5.90%';
    if (totalDays < 730) return '6.25%';
    if (totalDays < 1095) return '6.40%';
    if (totalDays < 1825) return '6.30%';
    if (totalDays <= 3650) return '6.05%';

    return '';
  }

  void _applySuggestion(String years, String months, String days) {
    setState(() {
      _yearsController.text = years;
      _monthsController.text = months;
      _daysController.text = days;
    });
    _updateCalculations();
  }

  void _applyGreenFDDuration(int days, String roi) {
    setState(() {
      if (days == 1111) {
        _yearsController.text = '3';
        _monthsController.text = '0';
        _daysController.text = '16';
      } else if (days == 1777) {
        _yearsController.text = '4';
        _monthsController.text = '10';
        _daysController.text = '17';
      } else if (days == 2222) {
        _yearsController.text = '6';
        _monthsController.text = '1';
        _daysController.text = '2';
      }
      _roi = roi;
      _maturityDate = DateFormat('dd/MM/yyyy').format(
        DateTime.now().add(Duration(days: days)),
      );
    });
  }

  void _applyNonCallableFDDuration(int years, String roi) {
    setState(() {
      _yearsController.text = years.toString();
      _monthsController.text = '0';
      _daysController.text = '0';
      _roi = roi;
      _maturityDate = DateFormat('dd/MM/yyyy').format(
        DateTime.now().add(Duration(days: years * 365)),
      );
    });
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
                            _yearsController.clear();
                            _monthsController.clear();
                            _daysController.clear();
                            _roi = '';
                            _maturityDate = '';
                            _updateCalculations();
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: Colors.white.withOpacity(0.2), height: 1),
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
    double? enteredAmount = double.tryParse(_amountController.text);
    bool isAmountValid = _amountController.text.isEmpty || (enteredAmount != null && enteredAmount >= 1000);

    bool isAnyDurationEntered = _yearsController.text.isNotEmpty || _monthsController.text.isNotEmpty || _daysController.text.isNotEmpty;

    bool isFormFilled = _amountController.text.isNotEmpty && isAmountValid && 
        ((_selectedVariant == 'Green FD' || _selectedVariant == 'Non-Callable FD') 
            ? _roi.isNotEmpty 
            : (_isDurationValid && _roi.isNotEmpty && isAnyDurationEntered));

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
                            builder: (context) => InterestRatesScreen(variant: _selectedVariant),
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
                if (_selectedVariant == 'Green FD')
                  _buildGreenFDDurationOptions()
                else if (_selectedVariant == 'Non-Callable FD')
                  _buildNonCallableFDDurationOptions()
                else ...[
                  Row(
                    children: [
                      Expanded(child: _buildDurationInput(_yearsController, 'Years', maxLength: 2)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDurationInput(_monthsController, 'Months', maxLength: 2, isDisabled: _yearsController.text == '10')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDurationInput(_daysController, 'days', maxLength: 2, isDisabled: _yearsController.text == '10')),
                    ],
                  ),
                  if (!_isDurationValid && isAnyDurationEntered) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Please enter a valid duration between 7 days and 10 years',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  if (isAnyDurationEntered) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Suggestions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    ..._buildSuggestions(),
                  ],
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

  Widget _buildGreenFDDurationOptions() {
    return Column(
      children: [
        _buildGreenFDCard('1111 Days', '(3 Years 16 Days)', '6.20%', 1111),
        const SizedBox(height: 12),
        _buildGreenFDCard('1777 Days', '(4 Years 10 Months 17 Days)', '6.20%', 1777),
        const SizedBox(height: 12),
        _buildGreenFDCard('2222 Days', '(6 Years 1 Month 2 Days)', '5.95%', 2222),
      ],
    );
  }

  Widget _buildGreenFDCard(String daysText, String durationText, String rate, int days) {
    bool isSelected = (_roi == rate && _yearsController.text.isNotEmpty);
    if (days == 1111 && _yearsController.text == '3') isSelected = true;
    else if (days == 1777 && _yearsController.text == '4') isSelected = true;
    else if (days == 2222 && _yearsController.text == '6') isSelected = true;
    else isSelected = false;

    return GestureDetector(
      onTap: () => _applyGreenFDDuration(days, rate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(daysText, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
                Text(durationText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            Text(rate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          ],
        ),
      ),
    );
  }

  Widget _buildNonCallableFDDurationOptions() {
    return Column(
      children: [
        _buildNonCallableFDCard('1 Year', '6.55%', 1),
        const SizedBox(height: 12),
        _buildNonCallableFDCard('2 Years', '6.80%', 2),
      ],
    );
  }

  Widget _buildNonCallableFDCard(String durationText, String rate, int years) {
    bool isSelected = (_yearsController.text == years.toString() && _monthsController.text == '0' && _daysController.text == '0');

    return GestureDetector(
      onTap: () => _applyNonCallableFDDuration(years, rate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(durationText, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
            Text(rate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSuggestions() {
    if (_selectedVariant == 'Tax Saver FD') {
      return [
        _buildSuggestionCard('5 Years', '6.05%', () => _applySuggestion('5', '0', '0')),
        _buildSuggestionCard('10 Years', '6.05%', () => _applySuggestion('10', '0', '0')),
      ];
    }
    if (_selectedVariant == 'Multi Option Deposit') {
      return [
        _buildSuggestionCard('1 Year', '6.25%', () => _applySuggestion('1', '0', '0')),
        _buildSuggestionCard('2 Years', '6.40%', () => _applySuggestion('2', '0', '0')),
        _buildSuggestionCard('5 Years', '6.05%', () => _applySuggestion('5', '0', '0')),
      ];
    }
    return [
      _buildSuggestionCard('Amrit Vrishti 444', '6.45%', () => _applySuggestion('1', '2', '19')),
      _buildSuggestionCard('2 Years', '6.40%', () => _applySuggestion('2', '0', '0')),
      _buildSuggestionCard('1 Year', '6.25%', () => _applySuggestion('1', '0', '0')),
    ];
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
                      _isAccountVisible ? 'XXXXXXXX1234' : 'XXXXXXXX1234',
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
    double? enteredAmount = double.tryParse(_amountController.text);
    bool isErrorVisible = _amountController.text.isNotEmpty && (enteredAmount == null || enteredAmount < 1000);

    return Column( crossAxisAlignment: CrossAxisAlignment.start,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
              'Minimum Amount should be ₹ 1,000.00 for the selected deposit type and deposit variant',
              style: TextStyle(color: Colors.red.shade900, fontSize: 12, height: 1.2),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationInput(TextEditingController controller, String label, {int? maxLength, bool isDisabled = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        TextField(
          controller: controller,
          enabled: !isDisabled,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          ],
          onSubmitted: (value) {
            if (label == 'Years' && value == '10') {
              _monthsController.text = '0';
              _daysController.text = '0';
              _updateCalculations();
            }
          },
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade100)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(String title, String rate, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            Text(rate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDisplayBox(String label, String value) {
    return Container(
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
