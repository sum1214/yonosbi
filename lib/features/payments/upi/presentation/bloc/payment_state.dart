part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final bool isLoading;
  final bool showBalance;
  final String searchResultName;
  final String searchResultUpi;
  final bool showRecipient;

  const PaymentState({
    this.isLoading = false,
    this.showBalance = false,
    this.searchResultName = '',
    this.searchResultUpi = '',
    this.showRecipient = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    bool? showBalance,
    String? searchResultName,
    String? searchResultUpi,
    bool? showRecipient,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      showBalance: showBalance ?? this.showBalance,
      searchResultName: searchResultName ?? this.searchResultName,
      searchResultUpi: searchResultUpi ?? this.searchResultUpi,
      showRecipient: showRecipient ?? this.showRecipient,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        showBalance,
        searchResultName,
        searchResultUpi,
        showRecipient,
      ];
}
