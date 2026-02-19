import 'package:flutter/material.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'enter_account_number_screen.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({super.key});

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, String>> _filteredBanks = [];
  bool _isLoading = true;

  final List<Map<String, String>> popularBanks = [
    {'name': 'SBI', 'logo': 'assets/images/sbi_logo.png'},
    {'name': 'HDFC Bank', 'logo': 'assets/images/hdfc_logo.png'},
    {'name': 'ICICI Bank', 'logo': 'assets/images/icici_logo.png'},
    {'name': 'Yes Bank', 'logo': 'assets/images/yes_bank_logo.png'},
    {'name': 'Kotak Bank', 'logo': 'assets/images/kotak_logo.png'},
    {'name': 'Axis Bank', 'logo': 'assets/images/axis_logo.png'},
    {'name': 'Union Bank', 'logo': 'assets/images/union_bank_logo.png'},
    {'name': 'IndusInd', 'logo': 'assets/images/indusind_logo.png'},
    {'name': 'RBL Bank', 'logo': 'assets/images/rbl_logo.png'},
    {'name': 'BOB', 'logo': 'assets/images/bob_logo.png'},
    {'name': 'PNB', 'logo': 'assets/images/pnb_logo.png'},
    {'name': 'HSBC', 'logo': 'assets/images/hsbc_logo.png'},
  ];

  final List<Map<String, String>> allBanksList = [
    {'name': 'HDFC Bank', 'logo': 'assets/images/hdfc_logo.png'},
    {'name': 'HSBC', 'logo': 'assets/images/hsbc_logo.png'},
    {'name': '510 ARMY BASE WORKSHOP CREDIT CO OPERATIVE PRIMARY BANK LTD', 'logo': ''},
    {'name': 'Abhinandan Urban Co-Op Bank Ltd', 'logo': ''},
    {'name': 'Abhyudaya Co-op Bank', 'logo': ''},
    {'name': 'Adarsh Co-op Bank', 'logo': ''},
    {'name': 'Adarsh Co-operative Bank Limited', 'logo': ''},
    {'name': 'ADARSH CO OPERATIVE BANK LTD', 'logo': ''},
    {'name': 'Ahmedabad Dis. Co-op', 'logo': ''},
    {'name': 'Ahmednagar Merchant\'s Co Operative Bank Ltd', 'logo': ''},
    {'name': 'Ahmednagar Shahar Sahakari Bank Ltd', 'logo': ''},
    {'name': 'Akhand Anand Co Operative Bank ltd.', 'logo': ''},
    {'name': 'Allahabad Bank', 'logo': ''},
    {'name': 'STATE BANK OF INDIA', 'logo': 'assets/images/sbi_logo.png'},
    {'name': 'ICICI Bank', 'logo': 'assets/images/icici_logo.png'},
    {'name': 'YES BANK', 'logo': 'assets/images/yes_bank_logo.png'},
    {'name': 'Union Bank of India', 'logo': 'assets/images/union_bank_logo.png'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredBanks = allBanksList;
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
        _filteredBanks = allBanksList;
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
            'Select Bank',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_searchQuery.isEmpty) ...[
                    const Text(
                      'Popular Banks',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
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
                  ],
                  // Combined list items (results or all banks)
                  ..._filteredBanks.map((bank) => _buildBankListItem(bank)).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankGridItem(Map<String, String> bank) {
    return InkWell(
      onTap: () => _navigateToEnterAccountNumber(bank),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade100,
            child: Icon(Icons.account_balance, color: Colors.grey.shade700, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            bank['name']!,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBankListItem(Map<String, String> bank) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey.shade100,
        child: Icon(Icons.account_balance, color: Colors.grey.shade700, size: 18),
      ),
      title: Text(
        bank['name']!,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: () => _navigateToEnterAccountNumber(bank),
    );
  }

  void _navigateToEnterAccountNumber(Map<String, String> bank) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterAccountNumberScreen(
          bankName: bank['name']!,
          bankLogo: bank['logo']!,
        ),
      ),
    );
  }
}
