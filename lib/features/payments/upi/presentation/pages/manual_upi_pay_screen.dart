import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'package:yonosbi/features/payments/upi/presentation/pages/transaction_screen.dart';
import 'package:yonosbi/features/payments/upi/presentation/bloc/payment_bloc.dart';

class ManualUpiPayScreen extends StatefulWidget {
  const ManualUpiPayScreen({super.key});

  @override
  State<ManualUpiPayScreen> createState() => _ManualUpiPayScreenState();
}

class _ManualUpiPayScreenState extends State<ManualUpiPayScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showVerifyButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleInputChange() {
    final text = _controller.text.trim();
    
    setState(() {
      // Show verify button if it's a potential UPI ID (contains @ with chars on both sides) 
      // or a 10-digit number
      final isUpi = text.contains('@') && text.indexOf('@') > 0 && text.indexOf('@') < text.length - 1;
      final isPhone = RegExp(r'^[0-9]{10}$').hasMatch(text);
      _showVerifyButton = isUpi || isPhone;
    });

    // Reset recipient if input is empty or invalid format to avoid showing old results
    if (text.isEmpty || (!text.contains('@') && !RegExp(r'^[0-9]+$').hasMatch(text))) {
       context.read<PaymentBloc>().add(const SearchRecipient(""));
    }
  }

  void _onVerify() {
    final text = _controller.text.trim();
    context.read<PaymentBloc>().add(SearchRecipient(text));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
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
                'Pay UPI ID or Number',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter UPI ID or Number',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _showVerifyButton 
                        ? TextButton(
                            onPressed: _onVerify,
                            child: const Text('Verify', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                          )
                        : (state.showRecipient && !state.isLoading ? const Icon(Icons.check_circle, color: Colors.green) : null),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primaryPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onSubmitted: (_) => _showVerifyButton ? _onVerify() : null,
                  ),
                ),
                if (state.showRecipient && !state.isLoading && _controller.text.isNotEmpty)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.shade50,
                      child: Text(
                        state.searchResultName.isNotEmpty ? state.searchResultName[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      state.searchResultName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      state.searchResultUpi,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionScreen(
                            contactName: state.searchResultName,
                            contactPhone: state.searchResultUpi,
                            shouldShowLoader: true,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
