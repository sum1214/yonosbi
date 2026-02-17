part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class LoadBalance extends PaymentEvent {}

class CheckBalance extends PaymentEvent {}

class ResetBalanceVisibility extends PaymentEvent {}

class SearchRecipient extends PaymentEvent {
  final String query;
  const SearchRecipient(this.query);

  @override
  List<Object> get props => [query];
}

class SelectContact extends PaymentEvent {
  final dynamic contact;
  final Function(dynamic) onComplete;
  const SelectContact(this.contact, this.onComplete);

  @override
  List<Object> get props => [contact];
}

class ProcessPayment extends PaymentEvent {
  final double amount;
  const ProcessPayment(this.amount);

  @override
  List<Object> get props => [amount];
}

class AmountChanged extends PaymentEvent {
  final String amount;
  const AmountChanged(this.amount);

  @override
  List<Object> get props => [amount];
}
