import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'transaction_data.dart';
import 'transaction_details_screen.dart';
import 'request_statement_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isLoading = true;
  bool _isAccountVisible = false;
  int _activeTabIndex = 0;
  String _selectedDuration = 'Recent Transfers (Last 20 transactions)';
  String _lastSelectedNonCustomDuration = 'Recent Transfers (Last 20 transactions)';
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _expandedTransactionId;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTransactions() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }

  List<Transaction> _getFilteredTransactions() {
    List<Transaction> baseList = mockTransactions;
    
    // Apply Duration Filter
    if (_selectedDuration == 'Recent Transfers (Last 20 transactions)') {
      baseList = mockTransactions.take(20).toList();
    } else if (_selectedDuration == 'Current Month') {
      baseList = mockTransactions.where((tx) => tx.date.contains('/02/2026')).toList();
    } else if (_selectedDuration == 'Last Month') {
      baseList = mockTransactions.where((tx) => tx.date.contains('/01/2026')).toList();
    } else if (_selectedDuration == 'Last 3 Months') {
      baseList = mockTransactions.where((tx) => 
        tx.date.contains('/01/2026') || 
        tx.date.contains('/12/2025') || 
        tx.date.contains('/11/2025')
      ).toList();
    } else if (_selectedDuration == 'Custom Date Range' && _fromDate != null && _toDate != null) {
      baseList = mockTransactions.where((tx) {
        final date = _parseDate(tx.date);
        if (date == null) return false;
        final d = DateTime(date.year, date.month, date.day);
        final start = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
        final end = DateTime(_toDate!.year, _toDate!.month, _toDate!.day);
        return (d.isAtSameMomentAs(start) || d.isAfter(start)) &&
               (d.isAtSameMomentAs(end) || d.isBefore(end));
      }).toList();
    }

    // Apply Search Filter
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      baseList = baseList.where((tx) {
        return tx.description.toLowerCase().contains(query) ||
               tx.fullDescription.toLowerCase().contains(query) ||
               tx.amount.toLowerCase().contains(query) ||
               tx.category.toLowerCase().contains(query);
      }).toList();
    }

    return baseList;
  }

  Map<String, List<Transaction>> _groupTransactionsByMonth(List<Transaction> txs) {
    Map<String, List<Transaction>> grouped = {};
    for (var tx in txs) {
      final date = _parseDate(tx.date);
      if (date == null) continue;
      String month = DateFormat('MMMM yyyy').format(date);
      
      if (!grouped.containsKey(month)) grouped[month] = [];
      grouped[month]!.add(tx);
    }
    return grouped;
  }

  void _showAccountSelection() {
    bool localIsVisible = _isAccountVisible;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.keyboard_arrow_up, color: Colors.grey.shade400, size: 28),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066B3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      localIsVisible ? '36991601234' : 'XXXXXXXX1234',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setSheetState(() {
                                          localIsVisible = !localIsVisible;
                                        });
                                      },
                                      child: Icon(
                                        localIsVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        size: 20,
                                        color: AppColors.primaryPurple,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text('Savings Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const Text('Available Balance: ₹434.44', style: TextStyle(color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAccountVisible = localIsVisible;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Select', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showDurationSelection() {
    final durations = [
      'Recent Transfers (Last 20 transactions)',
      'Current Month',
      'Last Month',
      'Last 3 Months',
      'Custom Date Range',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF6A1B9A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ...durations.map((duration) => Column(
                children: [
                  ListTile(
                    title: Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: _selectedDuration == duration
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Color(0xFF6A1B9A), size: 16),
                          )
                        : null,
                    onTap: () {
                      if (duration == 'Custom Date Range') {
                        Navigator.pop(context);
                        _showCustomDateRange();
                      } else {
                        setState(() {
                          _selectedDuration = duration;
                          _lastSelectedNonCustomDuration = duration;
                          _fromDate = null;
                          _toDate = null;
                        });
                        Navigator.pop(context);
                        _loadTransactions();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.white.withOpacity(0.2), height: 1),
                  ),
                ],
              )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showCustomDateRange() {
    DateTime? tempFrom = _fromDate;
    DateTime? tempTo = _toDate ?? DateTime(2026, 2, 17); // Default To: 17 Feb 2026
    bool pickingFrom = tempFrom == null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isApplyEnabled = tempFrom != null && tempTo != null;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF6A1B9A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Custom Date Range',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => pickingFrom = true),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From *', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: pickingFrom ? Colors.white : Colors.white24, width: 2)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tempFrom == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(tempFrom!),
                                        style: TextStyle(color: tempFrom == null ? Colors.white38 : Colors.white, fontSize: 16),
                                      ),
                                      const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => pickingFrom = false),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('To *', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: !pickingFrom ? Colors.white : Colors.white24, width: 2)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tempTo == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(tempTo!),
                                        style: TextStyle(color: tempTo == null ? Colors.white38 : Colors.white, fontSize: 16),
                                      ),
                                      const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Colors.white,
                          onPrimary: Color(0xFF6A1B9A),
                          surface: Colors.transparent,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: Colors.transparent,
                      ),
                      child: CalendarDatePicker(
                        initialDate: pickingFrom ? (tempFrom ?? DateTime.now()) : (tempTo ?? DateTime.now()),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        onDateChanged: (date) {
                          setSheetState(() {
                            if (pickingFrom) {
                              tempFrom = date;
                              pickingFrom = false;
                            } else {
                              tempTo = date;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedDuration = _lastSelectedNonCustomDuration;
                                _fromDate = null;
                                _toDate = null;
                              });
                              Navigator.pop(context);
                              _loadTransactions();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Clear Filter', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isApplyEnabled ? () {
                              setState(() {
                                _fromDate = tempFrom;
                                _toDate = tempTo;
                                _selectedDuration = 'Custom Date Range';
                              });
                              Navigator.pop(context);
                              _loadTransactions();
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6A1B9A),
                              disabledBackgroundColor: Colors.white24,
                              disabledForegroundColor: Colors.white38,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Apply Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTxs = _getFilteredTransactions();
    final groupedTxs = _groupTransactionsByMonth(filteredTxs);
    final monthKeys = groupedTxs.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black54)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline, color: Colors.black54)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(),
          if (_activeTabIndex == 0) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showAccountSelection,
                    borderRadius: BorderRadius.circular(12),
                    child: _buildAccountCard(),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  _buildSearchInfo(filteredTxs.length),
                  const SizedBox(height: 16),
                  _buildActionRow(),
                ],
              ),
            ),
            if (_isLoading)
              const LinearProgressIndicator(
                backgroundColor: Color(0xFFF3E5F5),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                minHeight: 2,
              ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPurple,
                      ),
                    )
                  : ListView.builder(
                      itemCount: monthKeys.length + filteredTxs.length,
                      itemBuilder: (context, index) {
                        int currentCount = 0;
                        for (var month in monthKeys) {
                          if (index == currentCount) {
                            return _buildMonthHeader(month);
                          }
                          currentCount++;
                          final monthTxs = groupedTxs[month]!;
                          if (index < currentCount + monthTxs.length) {
                            final tx = monthTxs[index - currentCount];
                            final txId = '${tx.date}-${tx.amount}-${tx.description}';
                            final isExpanded = _expandedTransactionId == txId;
                            
                            return _buildTransactionItem(tx, isExpanded, () {
                              setState(() {
                                if (isExpanded) {
                                  _expandedTransactionId = null;
                                } else {
                                  _expandedTransactionId = txId;
                                }
                              });
                            });
                          }
                          currentCount += monthTxs.length;
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ] else
            _buildSpendAnalysisContent(),
        ],
      ),
    );
  }

  Widget _buildSearchInfo(int count) {
    if (_isAccountVisible || _searchController.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          _searchController.text.isEmpty 
              ? 'Search by name, amount, cheque no., remarks' 
              : '$count Results found',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMonthHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTabIndex = 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Transaction Details',
                        style: TextStyle(
                          color: _activeTabIndex == 0 ? AppColors.primaryPurple : Colors.grey,
                          fontWeight: _activeTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      color: _activeTabIndex == 0 ? AppColors.primaryPurple : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTabIndex = 1),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Spend Analysis',
                        style: TextStyle(
                          color: _activeTabIndex == 1 ? AppColors.primaryPurple : Colors.grey,
                          fontWeight: _activeTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      color: _activeTabIndex == 1 ? AppColors.primaryPurple : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildSpendAnalysisContent() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCloud(40),
                          const SizedBox(width: 60),
                          _buildCloud(50),
                        ],
                      ),
                    ),
                    Icon(Icons.hourglass_bottom, size: 120, color: const Color(0xFFEDE7F6).withOpacity(0.8)),
                    Container(
                      width: 80,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryPurple, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index < 3 ? AppColors.secondaryPink : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 40,
                      child: Transform.rotate(angle: 0.5, child: Icon(Icons.subdirectory_arrow_right, color: AppColors.primaryPurple.withOpacity(0.3), size: 30)),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Transform.rotate(angle: -2.5, child: Icon(Icons.subdirectory_arrow_right, color: AppColors.primaryPurple.withOpacity(0.3), size: 30)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Coming Soon',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                'We are preparing to help you access this\nService shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloud(double size) {
    return Container(
      width: size,
      height: size / 2,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF0066B3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _isAccountVisible ? '36991601234' : 'XXXXXXXX1234',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAccountVisible = !_isAccountVisible;
                        });
                      },
                      child: Icon(
                        _isAccountVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 16,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
                const Text('Savings Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    onTap: () => setState(() => _isSearchFocused = true),
                    decoration: const InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                      _isSearchFocused = false;
                    }),
                    child: const Icon(Icons.close, color: Colors.grey, size: 18),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.filter_list, color: AppColors.primaryPurple.withOpacity(0.7)),
        const SizedBox(width: 12),
        Icon(Icons.swap_vert, color: AppColors.primaryPurple.withOpacity(0.7)),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _showDurationSelection,
          child: Row(
            children: [
              Text(_selectedDuration.split(' (').first, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple)),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryPurple),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RequestStatementScreen()),
              );
            },
            child: const Text('Request Statement', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction tx, bool isExpanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tx.category, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isExpanded ? tx.fullDescription : tx.description,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        maxLines: isExpanded ? 10 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(tx.date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          tx.amount,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 14,
                            color: Color(0xFF303F9F),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          tx.isDebit ? Icons.call_made : Icons.call_received,
                          size: 14,
                          color: tx.isDebit ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(tx.balance, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(transaction: tx),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF303F9F),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 16, color: Color(0xFF303F9F)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
