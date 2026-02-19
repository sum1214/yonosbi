import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class RequestStatementScreen extends StatefulWidget {
  const RequestStatementScreen({super.key});

  @override
  State<RequestStatementScreen> createState() => _RequestStatementScreenState();
}

class _RequestStatementScreenState extends State<RequestStatementScreen> {
  int _selectedOption = 0; // 0 for Duration, 1 for Financial Year
  String? _selectedDuration;
  String? _selectedFinancialYear;
  String _selectedFormat = 'PDF';
  bool _includeAccountSummary = false;
  bool _includeNomineeDetails = false;

  DateTime? _fromDate;
  DateTime? _toDate;

  void _showDurationBottomSheet() {
    final durations = [
      'Current Month',
      'Last Month',
      'Last 3 Months',
      'Current Financial Year',
      'Last Financial Year',
      'Custom Date Range',
    ];

    _showPurpleBottomSheet(
      title: 'Duration',
      items: durations,
      selectedValue: _selectedDuration ?? '',
      onSelected: (value) {
        setState(() {
          _selectedDuration = value;
          _selectedOption = 0;
          if (value == 'Custom Date Range') {
            _showCustomDateRange();
          } else {
            _fromDate = null;
            _toDate = null;
          }
        });
      },
    );
  }

  void _showFinancialYearBottomSheet() {
    final years = ['2025 - 2026', '2024 - 2025', '2023 - 2024'];

    _showPurpleBottomSheet(
      title: 'Financial Year',
      items: years,
      selectedValue: _selectedFinancialYear ?? '',
      onSelected: (value) {
        setState(() {
          _selectedFinancialYear = value;
          _selectedOption = 1;
        });
      },
    );
  }

  void _showFormatBottomSheet() {
    final formats = ['PDF', 'Excel'];

    _showPurpleBottomSheet(
      title: 'Format',
      items: formats,
      selectedValue: _selectedFormat,
      onSelected: (value) {
        setState(() {
          _selectedFormat = value;
        });
      },
    );
  }

  void _showCustomDateRange() {
    DateTime? tempFrom = _fromDate;
    DateTime? tempTo = _toDate ?? DateTime(2026, 2, 18);
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
                              Navigator.pop(context);
                              _showDurationBottomSheet();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Back To Filters', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showPurpleBottomSheet({
    required String title,
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
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
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ...items.map((item) => Column(
                children: [
                  ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: selectedValue == item
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Color(0xFF6A1B9A), size: 16),
                          )
                        : null,
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
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

  void _showEmailConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Email ID',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              ),
              const SizedBox(height: 24),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.email_outlined, size: 60, color: AppColors.primaryPurple),
              ),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
                  children: [
                    TextSpan(text: 'The document will be sent to your registered Email id '),
                    TextSpan(
                      text: 'pxxxxxxxxxxxx@gmail.com',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextSpan(text: '. Please tap on Proceed to confirm'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessWithLoader(isEmail: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPasswordProtectionSheet() {
    bool isPasswordVisible = false;
    final TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'This file is protected',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setSheetState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryPurple),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close password sheet
                          Navigator.pop(context); // Close success screen
                          Navigator.pop(context); // Back to transactions
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Open', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessWithLoader({required bool isEmail}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryPurple),
                    ),
                  );
                }

                return Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF1A237E),
                        child: Icon(Icons.check, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Done!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isEmail
                            ? 'Your account statement has been successfully sent to your registered Email ID. The file is password protected.'
                            : 'You can access the downloaded statement on your device using the path below.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
                      ),
                      if (!isEmail) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'For Android: Device Internal Storage --> Downloads --> YONO SBI',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'For iOS: Files --> On My iPhone --> YONO SBI',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.info_outline, size: 18, color: AppColors.primaryPurple),
                          SizedBox(width: 8),
                          Text(
                            'Password logic',
                            style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.headset_mic_outlined, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Having any issues? Call 1800 1234 (Toll free)',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEmail) {
                              Navigator.pop(context); // Close success screen
                              Navigator.pop(context); // Go back to transactions
                            } else {
                              _showPasswordProtectionSheet();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActionEnabled = _selectedDuration != null || _selectedFinancialYear != null;

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
          'Request Statement',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black54)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline, color: Colors.black54)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionGroup(
              index: 0,
              title: 'Select Duration',
              fieldName: 'Duration',
              selectedValue: _selectedDuration,
              onTap: _showDurationBottomSheet,
            ),
            if (_selectedOption == 0 && _selectedDuration == 'Custom Date Range') ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Row(
                  children: [
                    Expanded(child: _buildDateDisplay('From', _fromDate, true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDateDisplay('To', _toDate ?? DateTime(2026, 2, 18), false)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            _buildOptionGroup(
              index: 1,
              title: 'Select Financial Year',
              fieldName: 'Financial Year',
              selectedValue: _selectedFinancialYear,
              onTap: _showFinancialYearBottomSheet,
            ),
            const SizedBox(height: 32),
            _buildSimpleSelector('Format', _selectedFormat, _showFormatBottomSheet),
            const SizedBox(height: 32),
            _buildSwitchTile(
              label: 'Include all account summary',
              value: _includeAccountSummary,
              onChanged: (val) => setState(() => _includeAccountSummary = val),
            ),
            _buildSwitchTile(
              label: 'Include nominee details',
              value: _includeNomineeDetails,
              onChanged: (val) => setState(() => _includeNomineeDetails = val),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Password logic', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Maximum 5 downloads per account in a day. 2000 transactions per download.',
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton('Email', isActionEnabled, _showEmailConfirmation),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton('Download', isActionEnabled, () => _showSuccessWithLoader(isEmail: false)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Upload to DigiLocker', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                  Icon(Icons.cloud_upload_outlined, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionGroup({
    required int index,
    required String title,
    required String fieldName,
    required String? selectedValue,
    required VoidCallback onTap,
  }) {
    bool isSelected = _selectedOption == index;
    bool hasValue = selectedValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedOption = index),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: _selectedOption,
                onChanged: (val) {
                  setState(() => _selectedOption = val!);
                },
                activeColor: AppColors.primaryPurple,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() => _selectedOption = index);
            onTap();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 48),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300, width: isSelected ? 2 : 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasValue && isSelected)
                  Text(fieldName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedValue ?? fieldName,
                      style: TextStyle(
                        color: (hasValue && isSelected) ? Colors.black87 : Colors.grey,
                        fontSize: (hasValue && isSelected) ? 16 : 15,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateDisplay(String label, DateTime? date, bool isFrom) {
    return InkWell(
      onTap: () => _showCustomDateRange(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(date),
                  style: TextStyle(color: date == null ? Colors.grey : Colors.black87, fontSize: 14),
                ),
                const Icon(Icons.calendar_month, color: Color(0xFF303F9F), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleSelector(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, bool isEnabled, VoidCallback onTap) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isEnabled ? AppColors.primaryPurple : Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isEnabled ? AppColors.primaryPurple : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
