part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final int paymentTabIndex;
  final bool isBalanceVisible;
  final bool isRefreshing;
  final int refreshTimer;
  final double balance;

  const DashboardState({
    this.selectedIndex = 0,
    this.paymentTabIndex = 0,
    this.isBalanceVisible = false,
    this.isRefreshing = false,
    this.refreshTimer = 0,
    this.balance = 684.80,
  });

  DashboardState copyWith({
    int? selectedIndex,
    int? paymentTabIndex,
    bool? isBalanceVisible,
    bool? isRefreshing,
    int? refreshTimer,
    double? balance,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      paymentTabIndex: paymentTabIndex ?? this.paymentTabIndex,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      refreshTimer: refreshTimer ?? this.refreshTimer,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        paymentTabIndex,
        isBalanceVisible,
        isRefreshing,
        refreshTimer,
        balance,
      ];
}
