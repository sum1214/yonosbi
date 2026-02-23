import 'dart:math';

class TransactionModel {
  final String name;
  final String initials;
  final String accountNumber;
  final double amount;
  final DateTime date;
  final bool isDebit;
  final String status;

  TransactionModel({
    required this.name,
    required this.initials,
    required this.accountNumber,
    required this.amount,
    required this.date,
    required this.isDebit,
    this.status = 'Paid',
  });
}

final List<String> _names = [
  'MANJOT KAUR', 'SHUBHAM KUMAR', 'AMIT SINGH', 'PRIYA SHARMA', 'RAHUL VERMA',
  'SNEHA GUPTA', 'VIKRAM REDDY', 'ANANYA DAS', 'ROHAN MEHTA', 'ISHANI JAIN',
  'ARJUN MALHOTRA', 'KAVITA PATEL', 'SANJAY NAIR', 'POOJA RAO', 'ADITYA JOSHI',
  'DEEPAK TIWARI', 'MEGHA BANSAL', 'RAJESH KHANNA', 'SUNITA MISHRA', 'KARAN OBEROI'
];

List<TransactionModel> generateDummyTransactions() {
  final random = Random();
  return List.generate(45, (index) {
    final name = _names[random.nextInt(_names.length)];
    final initials = name.split(' ').map((e) => e[0]).take(2).join();
    return TransactionModel(
      name: name,
      initials: initials,
      accountNumber: 'STATE BANK OF INDIA ${4000 + random.nextInt(1000)}',
      amount: (random.nextInt(5000) + 1).toDouble(),
      date: DateTime.now().subtract(Duration(days: random.nextInt(60), hours: random.nextInt(24), minutes: random.nextInt(60))),
      isDebit: random.nextBool(),
    );
  })..sort((a, b) => b.date.compareTo(a.date));
}
