import 'dart:convert';

class Payee {
  final String name;
  final String accountNumber;
  final String bankName;
  final String nickname;
  final double limit;

  Payee({
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.nickname,
    required this.limit,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'nickname': nickname,
      'limit': limit,
    };
  }

  factory Payee.fromMap(Map<String, dynamic> map) {
    return Payee(
      name: map['name'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      nickname: map['nickname'] ?? '',
      limit: (map['limit'] ?? 0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Payee.fromJson(String source) => Payee.fromMap(json.decode(source));
}
