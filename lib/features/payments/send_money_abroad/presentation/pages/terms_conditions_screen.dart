import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'otp_confirmation_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Send Money Abroad', 
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.close, color: AppColors.textDark), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Terms & Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Please scroll down to read "terms & conditions" and accept to proceed further', style: TextStyle(fontSize: 12, color: Colors.blue.shade900))),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  '1. I/We hereby give my/our unconditional consent and authorize State Bank of India to use, share, transmit, disclose, exchange, or utilize my/our Mobile Number and Email Id in any manner in connection with the tracking facility opted by us/provided to us for the said remittances. I/We also hereby acknowledge and agree that my/our Mobile Number and Email Id may be transmitted/shared by State Bank of India with its constituents/Correspondents/Service Providers or third-party agencies whether located in India or overseas with whom the State Bank of India has entered/propose to enter into contracts/arrangements for provision of any \'services\' and/or services in connection with the said tracking facility and that such constituents/Correspondents/Service Providers or third parties may use, process and/or store my/our said information/data in a manner deemed fit by them. I/We further agree and declare that I/We shall not hold State Bank of India or its constituents/Correspondents/Service Providers or third-party agencies, liable in any manner in this regard.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text('Remittance Instruction:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const Text(
                  'It shall be the responsibility on the part of the applicant for full compliance with the extant FEMA / RBI regulatory requirements. The submitted remittance application request on-line through retail internet banking shall be deemed to be complete in all respects once accepted and submitted and that the application is being made after having full knowledge on the extant Rules and Regulations relating to Foreign Exchange Outward Remittances regulatory requirements as applicable for residents in India within the ambit of RBI\'s Liberalised Remittance Scheme for resident individuals and as amended from time to time.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _isAccepted,
                    activeColor: AppColors.primaryPurple,
                    onChanged: (v) => setState(() => _isAccepted = v ?? false),
                  ),
                  const Expanded(
                    child: Text('I have read, understood and accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  ElevatedButton(
                    onPressed: _isAccepted ? () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpConfirmationScreen()));
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
