import 'dart:convert';

class ScheduledPayment {
  final String payeeName;
  final String bankName;
  final String accountNumber;
  final String amount;
  final String date;
  final String frequency;
  final String remark;
  final String scheduledTime;

  ScheduledPayment({
    required this.payeeName,
    required this.bankName,
    required this.accountNumber,
    required this.amount,
    required this.date,
    required this.frequency,
    required this.remark,
    required this.scheduledTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'payeeName': payeeName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'amount': amount,
      'date': date,
      'frequency': frequency,
      'remark': remark,
      'scheduledTime': scheduledTime,
    };
  }

  factory ScheduledPayment.fromMap(Map<String, dynamic> map) {
    return ScheduledPayment(
      payeeName: map['payeeName'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      amount: map['amount'] ?? '',
      date: map['date'] ?? '',
      frequency: map['frequency'] ?? '',
      remark: map['remark'] ?? '',
      scheduledTime: map['scheduledTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduledPayment.fromJson(String source) => ScheduledPayment.fromMap(json.decode(source));
}
