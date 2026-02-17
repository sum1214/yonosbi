import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class UpiPinScreen extends StatefulWidget {
  final String amount;
  final String contactName;

  const UpiPinScreen({
    super.key,
    required this.amount,
    required this.contactName,
  });

  @override
  State<UpiPinScreen> createState() => _UpiPinScreenState();
}

class _UpiPinScreenState extends State<UpiPinScreen> {
  String _pin = '';

  void _onKeyTap(String key) {
    if (_pin.length < 6) {
      setState(() {
        _pin += key;
      });
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'ENTER 6-DIGIT UPI PIN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPinDisplay(),
                  const SizedBox(height: 40),
                  _buildTransferInfo(),
                ],
              ),
            ),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ),
              const Row(
                children: [
                  Text(
                    'UPI',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(Icons.play_arrow, color: Colors.orange, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'STATE BANK OF INDIA',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Text(
            'XXXX8881',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('To:', style: TextStyle(fontSize: 14)),
              Text(
                widget.contactName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sending:', style: TextStyle(fontSize: 14)),
              Text(
                '₹${widget.amount}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        bool isFilled = index < _pin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            color: isFilled ? Colors.black87 : Colors.transparent,
          ),
        );
      }),
    );
  }

  Widget _buildTransferInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4D7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are SENDING ₹ ${widget.amount} from your account to\n${widget.contactName}',
              style: const TextStyle(fontSize: 12, color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          _buildKeypadRow(['4', '5', '6']),
          _buildKeypadRow(['7', '8', '9']),
          _buildKeypadRow([null, '0', 'SUBMIT']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String?> keys) {
    return Row(
      children: keys.map((key) {
        if (key == null) {
          return Expanded(
            child: InkWell(
              onTap: _onBackspace,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 0.5)),
                child: const Icon(Icons.backspace_outlined, size: 20),
              ),
            ),
          );
        }
        return Expanded(
          child: InkWell(
            onTap: () {
              if (key == 'SUBMIT') {
                if (_pin.length == 6) {
                  // Handle payment success
                  _showSuccessDialog();
                }
              } else {
                _onKeyTap(key);
              }
            },
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 0.5)),
              child: Text(
                key,
                style: TextStyle(
                  fontSize: key == 'SUBMIT' ? 14 : 20,
                  fontWeight: key == 'SUBMIT' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('₹${widget.amount} sent to ${widget.contactName}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog
                Navigator.of(context).pop(); // UPI Screen
                Navigator.of(context).pop(); // Transaction Screen
                Navigator.of(context).pop(); // Payment Detail Screen
                Navigator.of(context).pop(); // Contacts Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Go to Home', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
