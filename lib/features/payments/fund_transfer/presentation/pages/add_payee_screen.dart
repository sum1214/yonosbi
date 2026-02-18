import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';

class AddPayeeScreen extends StatefulWidget {
  const AddPayeeScreen({super.key});

  @override
  State<AddPayeeScreen> createState() => _AddPayeeScreenState();
}

class _AddPayeeScreenState extends State<AddPayeeScreen> {
  final TextEditingController _accNoController = TextEditingController();
  final TextEditingController _reAccNoController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
          'Add New Payee',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Number', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _accNoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Account Number',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Re-enter Account Number', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _reAccNoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Re-enter Account Number',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('IFSC', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _ifscController,
              decoration: InputDecoration(
                hintText: 'Enter IFSC Code',
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: const Text('SEARCH', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                ),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Payee Name', style: TextStyle(color: Colors.grey, fontSize: 14)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Payee Name',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to add payee
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
