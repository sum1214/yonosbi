import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/core/widgets/loading_overlay.dart';
import 'add_payee_details_screen.dart';

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

  final List<Map<String, String>> popularBanks = const [
    {'name': 'SBI Bank', 'logo': 'assets/images/sbi_logo.png'},
    {'name': 'HDFC', 'logo': 'assets/images/hdfc_logo.png'},
    {'name': 'ICICI', 'logo': 'assets/images/icici_logo.png'},
    {'name': 'Axis Bank', 'logo': 'assets/images/axis_logo.png'},
    {'name': 'Kotak Bank', 'logo': 'assets/images/kotak_logo.png'},
    {'name': 'BOB', 'logo': 'assets/images/bob_logo.png'},
    {'name': 'PNB', 'logo': 'assets/images/pnb_logo.png'},
    {'name': 'Yes Bank', 'logo': 'assets/images/yes_logo.png'},
    {'name': 'BOI', 'logo': 'assets/images/boi_logo.png'},
    {'name': 'IDBI', 'logo': 'assets/images/idbi_logo.png'},
    {'name': 'Union Bank', 'logo': 'assets/images/union_logo.png'},
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
    {'name': 'SBI BANK', 'logo': ''},
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
            icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'New Payee',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Bank Name',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Popular Banks',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.account_balance_outlined, size: 18, color: AppColors.primaryPurple),
                              label: const Text(
                                'Use MMID',
                                style: TextStyle(color: AppColors.primaryPurple, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: popularBanks.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPayeeDetailsScreen(
                                      bankName: popularBanks[index]['name']!.toUpperCase() + ' BANK',
                                    ),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Center(
                                      child: _buildBankIcon(popularBanks[index]['name']!),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    popularBanks[index]['name']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'All Banks',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        ...allBanksList.map((bank) => _buildAllBankItem(bank['name']!)).toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_searchQuery.isNotEmpty)
              Positioned(
                top: 60, // Exactly below the search bar
                left: 20,
                right: 20,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredBanks.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 15, endIndent: 15),
                    itemBuilder: (context, index) {
                      final bank = _filteredBanks[index];
                      return ListTile(
                        title: Text(bank['name']!, style: const TextStyle(fontSize: 14)),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPayeeDetailsScreen(
                                bankName: bank['name']!,
                              ),
                            ),
                          );
                          if (result == true && context.mounted) {
                            Navigator.pop(context, true);
                          }
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

  Widget _buildBankIcon(String name) {
    Color color = Colors.blue;
    IconData icon = Icons.account_balance;
    if (name == 'SBI Bank') color = Colors.blue;
    if (name == 'HDFC') color = Colors.blue.shade900;
    if (name == 'ICICI') color = Colors.red.shade900;
    if (name == 'Axis Bank') color = Colors.purple.shade900;
    if (name == 'Kotak Bank') color = Colors.red;
    if (name == 'PNB') color = Colors.yellow.shade800;
    return Icon(icon, color: color, size: 30);
  }

  Widget _buildAllBankItem(String name) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPayeeDetailsScreen(bankName: name),
          ),
        );
        if (result == true && context.mounted) {
          Navigator.pop(context, true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.account_balance, color: Colors.red, size: 24),
            const SizedBox(width: 15),
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
