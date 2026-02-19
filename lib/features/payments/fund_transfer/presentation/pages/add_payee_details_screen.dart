import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import '../../domain/models/payee_model.dart';
import '../../data/repositories/payee_repository.dart';

class AddPayeeDetailsScreen extends StatefulWidget {
  final String bankName;

  const AddPayeeDetailsScreen({
    super.key,
    required this.bankName,
  });

  @override
  State<AddPayeeDetailsScreen> createState() => _AddPayeeDetailsScreenState();
}

class _AddPayeeDetailsScreenState extends State<AddPayeeDetailsScreen> {
  final TextEditingController _accNoController = TextEditingController();
  final TextEditingController _confirmAccNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  double _limit = 500000;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _accNoController.addListener(_validateForm);
    _confirmAccNoController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
    _nicknameController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _accNoController.text.isNotEmpty &&
          _confirmAccNoController.text.isNotEmpty &&
          _accNoController.text == _confirmAccNoController.text &&
          _nameController.text.isNotEmpty &&
          _nicknameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _accNoController.dispose();
    _confirmAccNoController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveAndProceed() async {
    if (!_isFormValid) return;

    final payee = Payee(
      name: _nameController.text,
      accountNumber: _accNoController.text,
      bankName: widget.bankName,
      nickname: _nicknameController.text,
      limit: _limit,
    );

    await PayeeRepository().savePayee(payee);
    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate a new payee was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Payee Details',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildBankLogo(widget.bankName),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.bankName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Funds will be transferred on the basis of account number only. IFSC code is not required.',
                style: TextStyle(color: Color(0xFF5A7EA8), fontSize: 12, height: 1.4),
              ),
            ),
            const SizedBox(height: 35),
            _buildInputField('Account Number', _accNoController, keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            _buildInputField('Confirm Account Number', _confirmAccNoController, keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            _buildInputField(
              'Account Name',
              _nameController,
              suffix: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildInputField('Set Nickname (Recommended)', _nicknameController),
            const SizedBox(height: 35),
            const Text(
              'Per Transaction Limit',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '₹ ${_formatCurrency(_limit.toInt())}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primaryPurple,
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: AppColors.primaryPurple,
                trackHeight: 3,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: _limit,
                min: 0,
                max: 2500000,
                onChanged: (val) => setState(() => _limit = val),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0', style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text('25 Lakhs', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is the maximum amount that can be transferred to a payee per transaction. Setting zero will block all transactions to the payee.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid ? _saveAndProceed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? AppColors.primaryPurple : Colors.grey.shade200,
                  foregroundColor: _isFormValid ? Colors.white : Colors.grey.shade500,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Proceed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {Widget? suffix, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple, width: 2)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buildBankLogo(String name) {
    return const Center(
      child: Icon(Icons.account_balance, color: Colors.blue, size: 25),
    );
  }

  String _formatCurrency(int amount) {
    String str = amount.toString();
    if (str.length <= 3) return str;
    String lastThree = str.substring(str.length - 3);
    String other = str.substring(0, str.length - 3);
    if (other != '') {
      lastThree = ',' + lastThree;
    }
    return other.replaceAllMapped(RegExp(r'(\d{1,2})(?=(\d{2})+(?!\d))'), (Match m) => '${m[1]},') + lastThree;
  }
}
