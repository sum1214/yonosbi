import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_bloc.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_event.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_state.dart';
import 'salient_features_screen.dart';

class AbroadAddPayeeScreen extends StatefulWidget {
  const AbroadAddPayeeScreen({super.key});

  @override
  State<AbroadAddPayeeScreen> createState() => _AbroadAddPayeeScreenState();
}

enum BankDetailType { swift, aba }

class _AbroadAddPayeeScreenState extends State<AbroadAddPayeeScreen> {
  BankDetailType _selectedDetailType = BankDetailType.swift;
  String _selectedCurrencyCode = 'USD';
  String _selectedCurrencyName = 'US Dollar';
  final TextEditingController _swiftController = TextEditingController();
  bool _isProceedEnabled = false;

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'GBP', 'name': 'Great Britian Pounds', 'symbol': '£'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'symbol': 'S\$'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
    {'code': 'NZD', 'name': 'New Zealand Dollar', 'symbol': 'NZ\$'},
    {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'د.إ'},
  ];

  @override
  void initState() {
    super.initState();
    _swiftController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _swiftController.dispose();
    super.dispose();
  }

  void _validateFields() {
    final text = _swiftController.text.trim();
    setState(() {
      if (_selectedDetailType == BankDetailType.swift) {
        _isProceedEnabled = text.length == 8 || text.length == 11;
      } else {
        _isProceedEnabled = text.length == 9 && RegExp(r'^[0-9]+$').hasMatch(text);
      }
    });
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF1E88E5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Please select a currency', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: _currencies.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white12, height: 1),
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.white, child: Text(currency['symbol']!, style: const TextStyle(color: Color(0xFF1E88E5)))),
                    title: Text('${currency['code']} (${currency['name']})', style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        _selectedCurrencyCode = currency['code']!;
                        _selectedCurrencyName = currency['name']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSalientFeatures() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const SalientFeaturesScreen(),
    );
  }

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                IconButton(icon: const Icon(Icons.close, color: AppColors.textGrey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Are you sure you want to switch to ABA Routing Number? You will need to verify payee bank details again after entering the ABA Routing Number.', style: TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5)),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), side: BorderSide(color: Colors.grey.shade300)),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedDetailType = BankDetailType.aba;
                  _swiftController.clear();
                  _validateFields();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: const Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Send Money Abroad', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.backgroundLight,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => Navigator.pop(context)),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.headphones_outlined, color: AppColors.textDark), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select currency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showCurrencyPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade100, child: Text(_currencies.firstWhere((c) => c['code'] == _selectedCurrencyCode)['symbol']!, style: const TextStyle(fontSize: 10, color: Colors.black))),
                    const SizedBox(width: 12),
                    Text('$_selectedCurrencyCode ($_selectedCurrencyName)', style: const TextStyle(fontSize: 14)),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _showSalientFeatures,
                icon: const Icon(Icons.star, size: 16, color: AppColors.primaryPurple),
                label: const Text('Salient features', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Payee bank details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildChoiceChip('SWIFT', _selectedDetailType == BankDetailType.swift, (selected) {
                  if (selected) setState(() {
                    _selectedDetailType = BankDetailType.swift;
                    _swiftController.clear();
                    _validateFields();
                  });
                }),
                const SizedBox(width: 12),
                _buildChoiceChip('ABA routing no.', _selectedDetailType == BankDetailType.aba, (selected) {
                  if (selected) _showConfirmationDialog();
                }),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _swiftController,
              keyboardType: _selectedDetailType == BankDetailType.aba ? TextInputType.number : TextInputType.text,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _selectedDetailType == BankDetailType.swift ? 'Enter SWIFT code' : 'Enter ABA Routing No.',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _selectedDetailType == BankDetailType.swift 
                    ? 'Please enter 8 or 11 character SWIFT code' 
                    : 'Please enter 9-digit ABA Routing Number',
                style: const TextStyle(color: Color(0xFF3F51B5), fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Verify Payee Bank Details', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: ElevatedButton(
          onPressed: _isProceedEnabled ? () {
            // Adding a mock payee using the entered details
            final newPayee = Payee(
              name: 'Jane D',
              bankName: _selectedDetailType == BankDetailType.swift ? 'ABCD Bank' : 'US Federal Bank',
              accountNumber: '19327643547',
              swiftCode: _swiftController.text.trim(),
              currency: _selectedCurrencyCode,
            );
            context.read<SendMoneyAbroadBloc>().add(AddPayeeEvent(newPayee));
            Navigator.pop(context);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            disabledBackgroundColor: AppColors.primaryPurple.withOpacity(0.2),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text('Proceed', style: TextStyle(color: _isProceedEnabled ? Colors.white : Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, ValueChanged<bool> onSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(true),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(label, style: TextStyle(color: isSelected ? AppColors.textDark : AppColors.textGrey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              if (isSelected)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
