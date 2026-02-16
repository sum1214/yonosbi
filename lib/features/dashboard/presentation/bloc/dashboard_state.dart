part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final int paymentTabIndex;

  const DashboardState({
    this.selectedIndex = 0,
    this.paymentTabIndex = 0,
  });

  DashboardState copyWith({
    int? selectedIndex,
    int? paymentTabIndex,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      paymentTabIndex: paymentTabIndex ?? this.paymentTabIndex,
    );
  }

  @override
  List<Object> get props => [selectedIndex, paymentTabIndex];
}
