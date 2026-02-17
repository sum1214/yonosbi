part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final double balance;
  final bool isLoading;
  final bool showBalance;

  const PaymentState({
    this.balance = 10000.0,
    this.isLoading = false,
    this.showBalance = false,
  });

  PaymentState copyWith({
    double? balance,
    bool? isLoading,
    bool? showBalance,
  }) {
    return PaymentState(
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      showBalance: showBalance ?? this.showBalance,
    );
  }

  @override
  List<Object> get props => [balance, isLoading, showBalance];
}
