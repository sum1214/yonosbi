import 'package:equatable/equatable.dart';
import 'send_money_abroad_state.dart';

abstract class SendMoneyAbroadEvent extends Equatable {
  const SendMoneyAbroadEvent();

  @override
  List<Object?> get props => [];
}

class LoadSendMoneyAbroadData extends SendMoneyAbroadEvent {}

class AddPayeeEvent extends SendMoneyAbroadEvent {
  final Payee payee;
  const AddPayeeEvent(this.payee);

  @override
  List<Object?> get props => [payee];
}

class CountrySelected extends SendMoneyAbroadEvent {
  final String country;
  const CountrySelected(this.country);

  @override
  List<Object?> get props => [country];
}

class SubmitInternationalTransfer extends SendMoneyAbroadEvent {
  final String senderAccount;
  final String country;
  final double amount;
  final String purpose;

  const SubmitInternationalTransfer({
    required this.senderAccount,
    required this.country,
    required this.amount,
    required this.purpose,
  });

  @override
  List<Object?> get props => [senderAccount, country, amount, purpose];
}
