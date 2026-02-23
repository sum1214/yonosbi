import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'interest_rates_screen.dart';
import 'recurring_deposit_interest_rates_screen.dart';

class PayoutCalculatorScreen extends StatefulWidget {
  const PayoutCalculatorScreen({super.key});

  @override
  State<PayoutCalculatorScreen> createState() => _PayoutCalculatorScreenState();
}

class _PayoutCalculatorScreenState extends State<PayoutCalculatorScreen> {
  String _selectedDepositType = 'Fixed Deposit';
  String _selectedVariant = 'Regular FD';
  String _selectedInterestPayout = 'At Maturity';
  String? _selectedAnnuityDuration;
  
  double _amount = 1000;
  final TextEditingController _amountController = TextEditingController(text: '1000');
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  final List<String> _depositTypes = ['Fixed Deposit', 'Annuity Deposit', 'Recurring Deposit'];
  final List<String> _fdVariants = ['Regular FD'];
  final List<String> _interestPayoutOptions = [
    'Monthly',
    'Quarterly',
    'Half Yearly',
    'Yearly',
    'At Maturity'
  ];

  final List<Map<String, String>> _annuityDurationOptions = [
    {'label': '10 Years', 'rate': '6.05%'},
    {'label': '7 Years', 'rate': '6.05%'},
    {'label': '5 Years', 'rate': '6.05%'},
    {'label': '3 Years', 'rate': '6.30%'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _onDepositTypeChanged(String type) {
    setState(() {
      _selectedDepositType = type;
      if (type == 'Recurring Deposit') {
        _amount = 100;
        _amountController.text = '100';
      } else {
        _amount = 1000;
        _amountController.text = '1000';
      }
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _selectedAnnuityDuration = null;
    });
  }

  void _showSelectionSheet(String title, List<String> items, String currentValue, Function(String) onSelected) {
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
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ...items.map((item) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: currentValue == item
                            ? Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.check, color: Color(0xFF6A1B9A), size: 16),
                              )
                            : null,
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
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
    double minAmount = _selectedDepositType == 'Recurring Deposit' ? 100 : 1000;
    double maxAmount = _selectedDepositType == 'Recurring Deposit' ? 29999990 : 29999999;

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
          'Payout Calculator',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedDepositType == 'Recurring Deposit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecurringDepositInterestRatesScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InterestRatesScreen()),
                );
              }
            },
            child: const Text(
              'Interest Rates',
              style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Deposit Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  _buildSelectionField('Deposit Type', _selectedDepositType, _depositTypes, _onDepositTypeChanged),
                  if (_selectedDepositType == 'Fixed Deposit') ...[
                    const SizedBox(height: 24),
                    _buildSelectionField('FD Variant', _selectedVariant, _fdVariants, (val) {
                      setState(() => _selectedVariant = val);
                    }),
                  ],
                ],
              ),
            ),
            Container(height: 8, color: const Color(0xFFF5F5F5)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Deposit Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _amountController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                          decoration: const InputDecoration(
                            prefixText: '₹',
                            prefixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (val) {
                            double? newVal = double.tryParse(val);
                            if (newVal != null) {
                              setState(() {
                                _amount = newVal.clamp(minAmount, maxAmount);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryPurple,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppColors.primaryPurple,
                      overlayColor: AppColors.primaryPurple.withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _amount.clamp(minAmount, maxAmount),
                      min: minAmount,
                      max: maxAmount,
                      onChanged: (val) {
                        setState(() {
                          _amount = val;
                          _amountController.text = val.toInt().toString();
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${NumberFormat('#,##,###').format(minAmount)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('₹${NumberFormat('#,##,##,###').format(maxAmount)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 16),
                  if (_selectedDepositType == 'Annuity Deposit')
                    _buildAnnuityDurationOptions()
                  else
                    Row(
                      children: [
                        Expanded(child: _buildDurationField('Years', _yearsController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDurationField('Months', _monthsController)),
                        if (_selectedDepositType == 'Fixed Deposit') ...[
                          const SizedBox(width: 16),
                          Expanded(child: _buildDurationField('days', _daysController)),
                        ],
                      ],
                    ),
                  if (_selectedDepositType == 'Fixed Deposit') ...[
                    const SizedBox(height: 32),
                    _buildSelectionField('Interest Payout', _selectedInterestPayout, _interestPayoutOptions, (val) {
                      setState(() => _selectedInterestPayout = val);
                    }),
                  ],
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Calculate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnuityDurationOptions() {
    return Column(
      children: _annuityDurationOptions.map((option) {
        bool isSelected = _selectedAnnuityDuration == option['label'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAnnuityDuration = option['label'];
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option['label']!, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                Text(option['rate']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectionField(String label, String value, List<String> items, Function(String) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        InkWell(
          onTap: () => _showSelectionSheet(label, items, value, onSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
          ),
        ),
      ],
    );
  }
}
