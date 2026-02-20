import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_bloc.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_event.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_state.dart';
import 'add_payee_screen.dart';
import 'salient_features_screen.dart';
import 'amount_entry_screen.dart';

class SendMoneyAbroadScreen extends StatefulWidget {
  const SendMoneyAbroadScreen({super.key});

  @override
  State<SendMoneyAbroadScreen> createState() => _SendMoneyAbroadScreenState();
}

class _SendMoneyAbroadScreenState extends State<SendMoneyAbroadScreen> {
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<SendMoneyAbroadBloc>().add(LoadSendMoneyAbroadData());
    _startInitialTimer();
  }

  Future<void> _startInitialTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
      _showSalientFeatures();
    }
  }

  void _showSalientFeatures() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SalientFeaturesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendMoneyAbroadBloc, SendMoneyAbroadState>(
      builder: (context, state) {
        final bool isLoading = _isInitialLoading || state is SendMoneyAbroadLoading;
        List<Payee> payees = [];
        if (state is SendMoneyAbroadLoaded) {
          payees = state.payees;
        }

        return LoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              title: const Text('Send Money Abroad', 
                style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w600)),
              backgroundColor: AppColors.backgroundLight,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.headphones_outlined, color: AppColors.textDark),
                )
              ],
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Payees Section
                  if (payees.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text('Recent payees', style: TextStyle(fontSize: 14, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: payees.length,
                        itemBuilder: (context, index) {
                          final payee = payees[index];
                          final firstName = payee.name.split(' ')[0];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: _getAvatarColor(index),
                                  child: Text(
                                    payee.name.isNotEmpty ? payee.name[0].toUpperCase() : '?',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(firstName, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Transaction History', 
                              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text('Added payees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 16),
                        
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (payees.isEmpty && !isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Text('No payees added yet.', style: TextStyle(color: AppColors.textGrey)),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: payees.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildPayeeCard(context, payees[index]);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AbroadAddPayeeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Add Payee', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: const Text('My Scheduled Payments', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF90CAF9), // Blue
      const Color(0xFFA5D6A7), // Green
      const Color(0xFFF48FB1), // Pink
      const Color(0xFFCE93D8), // Purple
      const Color(0xFFFFCC80), // Orange
    ];
    return colors[index % colors.length];
  }

  Widget _buildPayeeCard(BuildContext context, Payee payee) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  payee.name.isNotEmpty ? payee.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(payee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(payee.bankName, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('XXXXXXXX${payee.accountNumber.length > 4 ? payee.accountNumber.substring(payee.accountNumber.length - 4) : payee.accountNumber}', 
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.visibility_outlined, size: 16, color: AppColors.primaryPurple),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AmountEntryScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('Active', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
