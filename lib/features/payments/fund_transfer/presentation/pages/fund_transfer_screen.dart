import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../../domain/models/payee_model.dart';
import '../../data/repositories/payee_repository.dart';
import 'select_bank_screen.dart';
import 'transfer_amount_screen.dart';
import 'transaction_history_screen.dart';
import 'pay_payee_screen.dart';

class FundTransferScreen extends StatefulWidget {
  const FundTransferScreen({super.key});

  @override
  State<FundTransferScreen> createState() => _FundTransferScreenState();
}

class _FundTransferScreenState extends State<FundTransferScreen> {
  final PayeeRepository _repository = PayeeRepository();
  List<Payee> _payees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPayees();
  }

  Future<void> _loadPayees() async {
    setState(() => _isLoading = true);
    final payees = await _repository.getPayees();
    setState(() {
      _payees = payees;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Domestic Fund Transfer',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('Recent', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryPurple),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Transaction History',
                          style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Transfer to Self Accounts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 15),
                  _buildSelfAccountItem(context),
                  const SizedBox(height: 30),
                  const Text(
                    'Transfer to Other Payees',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 15),
                  _buildSearchBar(),
                  const SizedBox(height: 15),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_payees.isEmpty)
                    _buildPayeeItem(context, Payee(name: 'Shubham', accountNumber: '50100803999811', bankName: 'HDFC BANK', nickname: 'Shubh', limit: 100000))
                  else
                    ..._payees.map((payee) => _buildPayeeItem(context, payee)),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectBankScreen()),
                    );
                    if (result == true) {
                      _loadPayees();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Add Payee', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfAccountItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransferAmountScreen(
              name: 'Savings Account',
              accNo: '20451208881',
            ),
          ),
        );
      },
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 18,
            child: Icon(Icons.account_balance, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Savings Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('20451208881', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: const Icon(Icons.search, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
      ),
    );
  }

  Widget _buildPayeeItem(BuildContext context, Payee payee) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.account_balance, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Acc No ${payee.accountNumber}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PayPayeeScreen(payee: payee),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryPurple),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: const Text('Pay', style: TextStyle(color: AppColors.primaryPurple, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
