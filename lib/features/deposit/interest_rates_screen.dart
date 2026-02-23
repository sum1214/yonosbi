import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class InterestRatesScreen extends StatefulWidget {
  final String variant;
  const InterestRatesScreen({super.key, this.variant = 'Regular FD'});

  @override
  State<InterestRatesScreen> createState() => _InterestRatesScreenState();
}

class _InterestRatesScreenState extends State<InterestRatesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text(
          'Deposits',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interest Rates',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildRateSection(
                    title: 'Domestic Term Deposit - General',
                    rates: widget.variant == 'Tax Saver FD'
                        ? [
                      ['5 Years and upto 8 Years', '6.05%'],
                      ['8 Years and upto 10 Years', '6.05%'],
                    ]
                        : widget.variant == 'Multi Option Deposit'
                        ? [
                      ['1 year to less than 2 years', '6.25%'],
                      ['2 years to less than 3 years', '6.40%'],
                      ['3 years to less than 5 years', '6.30%'],
                      ['5 years', '6.05%'],
                    ]
                        : [
                      ['7 Days to 45 Days', '3.05%'],
                      ['46 Days to 180 Days', '4.90%'],
                      ['181 Days to 210 Days', '5.65%'],
                      ['211 Days to less than 1 Year', '5.90%'],
                      ['1 Year to less than 2 Years', '6.25%'],
                      ['Amrit Vrishiti 444', '6.45%'],
                      ['2 Years to less than 3 Years', '6.40%'],
                      ['3 Years to less than 5 Years', '6.30%'],
                      ['5 Years and upto 10 Years', '6.05%'],
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildRateSection(
                    title: 'Green Rupee TD - General',
                    rates: [
                      ['1111 Days', '6.20%'],
                      ['1777 Days', '6.20%'],
                      ['2222 Days', '5.95%'],
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildRateSection(
                    title: 'Non-callable Deposit - General',
                    rates: [
                      ['1 Year', '6.55%'],
                      ['2 Years', '6.80%'],
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildRateSection({required String title, required List<List<String>> rates}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Duration',
                style: TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                'Interest Rate',
                style: TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: rates.asMap().entries.map((entry) {
              int idx = entry.key;
              List<String> rate = entry.value;
              // Alternate background starting with grey (index 0) to match image
              bool isGrey = idx % 2 == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isGrey ? const Color(0xFFEFEFF4).withOpacity(0.9) : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rate[0],
                        style: const TextStyle(
                          color: Color(0xFF3F51B5),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      rate[1],
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
