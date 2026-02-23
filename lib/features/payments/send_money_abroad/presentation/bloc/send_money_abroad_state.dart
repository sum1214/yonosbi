import 'package:equatable/equatable.dart';
import 'dart:convert';

class Payee extends Equatable {
  final String name;
  final String bankName;
  final String accountNumber;
  final String swiftCode;
  final String currency;

  const Payee({
    required this.name,
    required this.bankName,
    required this.accountNumber,
    required this.swiftCode,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'swiftCode': swiftCode,
      'currency': currency,
    };
  }

  factory Payee.fromMap(Map<String, dynamic> map) {
    return Payee(
      name: map['name'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      swiftCode: map['swiftCode'] ?? '',
      currency: map['currency'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Payee.fromJson(String source) => Payee.fromMap(json.decode(source));

  @override
  List<Object?> get props => [name, bankName, accountNumber, swiftCode, currency];
}

abstract class SendMoneyAbroadState extends Equatable {
  const SendMoneyAbroadState();
  
  @override
  List<Object?> get props => [];
}

class SendMoneyAbroadInitial extends SendMoneyAbroadState {}

class SendMoneyAbroadLoading extends SendMoneyAbroadState {}

class SendMoneyAbroadLoaded extends SendMoneyAbroadState {
  final List<String> countries;
  final String? selectedCountry;
  final double exchangeRate;
  final List<Payee> payees;
  final List<Payee> recentPayees;

  const SendMoneyAbroadLoaded({
    required this.countries,
    this.selectedCountry,
    this.exchangeRate = 0.0,
    this.payees = const [],
    this.recentPayees = const [],
  });

  @override
  List<Object?> get props => [countries, selectedCountry, exchangeRate, payees, recentPayees];

  SendMoneyAbroadLoaded copyWith({
    List<String>? countries,
    String? selectedCountry,
    double? exchangeRate,
    List<Payee>? payees,
    List<Payee>? recentPayees,
  }) {
    return SendMoneyAbroadLoaded(
      countries: countries ?? this.countries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      payees: payees ?? this.payees,
      recentPayees: recentPayees ?? this.recentPayees,
    );
  }
}

class SendMoneyAbroadSuccess extends SendMoneyAbroadState {
  final String transactionId;
  const SendMoneyAbroadSuccess(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class SendMoneyAbroadFailure extends SendMoneyAbroadState {
  final String error;
  const SendMoneyAbroadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
