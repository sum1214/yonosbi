class TransactionModel {
  final String bankIcon;
  final String type; // e.g., IMPS
  final String title; // e.g., Transfer to Payee
  final String accountNumber;
  final String dateTime;
  final double amount;
  final bool isSuccessful;
  final String category; // e.g., Transfer to Family or friends

  TransactionModel({
    required this.bankIcon,
    required this.type,
    required this.title,
    required this.accountNumber,
    required this.dateTime,
    required this.amount,
    required this.isSuccessful,
    required this.category,
  });
}
