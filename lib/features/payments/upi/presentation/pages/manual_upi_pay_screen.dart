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
    // Always add the event so the BLoC can handle showing or hiding the recipient based on input length
    context.read<PaymentBloc>().add(SearchRecipient(text));
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
                      suffixIcon: state.showRecipient && !state.isLoading ? const Icon(Icons.check_circle, color: Colors.green) : null,
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
                  ),
                ),
                if (state.showRecipient && !state.isLoading)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.shade50,
                      child: Text(
                        state.searchResultName.isNotEmpty ? state.searchResultName[0] : '?',
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
