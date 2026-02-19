import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'quick_transfer_details_screen.dart';

class QuickTransferSelectBankScreen extends StatefulWidget {
  const QuickTransferSelectBankScreen({super.key});

  @override
  State<QuickTransferSelectBankScreen> createState() => _QuickTransferSelectBankScreenState();
}

class _QuickTransferSelectBankScreenState extends State<QuickTransferSelectBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, String>> _filteredBanks = [];
  bool _isLoading = true;

  final List<Map<String, String>> popularBanks = [
    {'name': 'SBI Bank', 'logo': 'assets/images/sbi_logo.png'},
    {'name': 'HDFC', 'logo': 'assets/images/hdfc_logo.png'},
    {'name': 'ICICI', 'logo': 'assets/images/icici_logo.png'},
    {'name': 'Axis Bank', 'logo': 'assets/images/axis_logo.png'},
    {'name': 'Kotak Bank', 'logo': 'assets/images/kotak_logo.png'},
    {'name': 'BOB', 'logo': 'assets/images/bob_logo.png'},
    {'name': 'PNB', 'logo': 'assets/images/pnb_logo.png'},
    {'name': 'Yes Bank', 'logo': 'assets/images/yes_bank_logo.png'},
    {'name': 'BOI', 'logo': 'assets/images/boi_logo.png'},
    {'name': 'IDBI', 'logo': 'assets/images/idbi_logo.png'},
    {'name': 'Union Bank', 'logo': 'assets/images/union_bank_logo.png'},
    {'name': 'IndusInd', 'logo': 'assets/images/indusind_logo.png'},
  ];

  final List<Map<String, String>> allBanksList = [
    {'name': 'HARYANA STATE COOPERATIVE BANK', 'logo': ''},
    {'name': 'HDFC BANK', 'logo': ''},
    {'name': 'HIMACHAL PRADESH STATE COOPERATIVE BANK LTD', 'logo': ''},
    {'name': 'HSBC BANK', 'logo': ''},
    {'name': 'Hutatma Sahakari Bank Ltd', 'logo': ''},
    {'name': 'STATE BANK OF INDIA', 'logo': ''},
    {'name': 'ICICI BANK', 'logo': ''},
    {'name': 'AXIS BANK', 'logo': ''},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      if (_searchQuery.isEmpty) {
        _filteredBanks = [];
      } else {
        _filteredBanks = allBanksList
            .where((bank) =>
                bank['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
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
            'Quick Transfer',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Bank',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.qr_code_scanner, size: 18, color: AppColors.primaryPurple),
                        label: const Text('Scan Cheque', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Bank Name',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Popular Banks',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.account_balance, size: 16, color: AppColors.primaryPurple),
                            label: const Text('Use MMID', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: popularBanks.length,
                        itemBuilder: (context, index) {
                          return _buildBankGridItem(popularBanks[index]);
                        },
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'All Banks',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ...allBanksList.map((bank) => _buildBankListItem(bank)).toList(),
                    ],
                  ),
                ),
              ],
            ),
            if (_searchQuery.isNotEmpty)
              Positioned(
                top: 105, // Positioned exactly below the search bar
                left: 16,
                right: 16,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredBanks.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          _filteredBanks[index]['name']!,
                          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                        ),
                        onTap: () {
                          _searchController.text = _filteredBanks[index]['name']!;
                          _navigateToDetails(_filteredBanks[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankGridItem(Map<String, String> bank) {
    return InkWell(
      onTap: () => _navigateToDetails(bank),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.account_balance, color: AppColors.primaryPurple, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            bank['name']!,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBankListItem(Map<String, String> bank) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        bank['name']!,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      onTap: () => _navigateToDetails(bank),
    );
  }

  void _navigateToDetails(Map<String, String> bank) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuickTransferDetailsScreen(bankName: bank['name']!),
      ),
    );
  }
}
