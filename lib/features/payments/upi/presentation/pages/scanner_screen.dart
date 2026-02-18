import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'transaction_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleDetection(String? rawValue) {
    if (_isScanned || rawValue == null) return;
    
    String address = '';
    String name = 'Scanned Recipient';

    // 1. Handle Standard UPI URL (upi://pay?pa=...)
    if (rawValue.startsWith('upi://')) {
      final uri = Uri.parse(rawValue);
      address = uri.queryParameters['pa'] ?? '';
      name = uri.queryParameters['pn'] ?? (address.contains('@') ? address.split('@').first : 'Recipient');
    } 
    // 2. Handle Plain UPI ID (e.g. shubham@sbi)
    else if (rawValue.contains('@')) {
      address = rawValue;
      name = rawValue.split('@').first;
    }
    // 3. Handle Plain Mobile Number
    else if (RegExp(r'^[0-9+]+$').hasMatch(rawValue) && rawValue.length >= 10) {
      address = rawValue;
      name = 'Contact Number';
    }

    if (address.isNotEmpty) {
      setState(() {
        _isScanned = true;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionScreen(
            contactName: name,
            contactPhone: address,
          ),
        ),
      );
    } else {
      debugPrint('Detected non-payment barcode: $rawValue');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                _handleDetection(barcodes.first.rawValue);
              }
            },
          ),
          
          // Transparent Overlay with Cutout
          Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          // Scanning UI Elements
          SafeArea(
            child: Column(
              children: [
                _buildTopActions(),
                const Spacer(),
                _buildMidActions(),
                const SizedBox(height: 20),
                _buildBottomForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3:22',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Icon(Icons.wifi, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Icon(Icons.battery_full, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'SCAN ANY QR',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () => cameraController.toggleTorch(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMidActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _scannerActionButton(Icons.qr_code_2, 'My QR Code'),
        const SizedBox(width: 20),
        _scannerActionButton(Icons.image_outlined, 'Upload Image'),
      ],
    );
  }

  Widget _scannerActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomForm() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Or Pay any UPI Number or UPI ID',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter UPI ID or Number',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Powered by | ', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                'UPI',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
