part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends DashboardEvent {
  final int index;
  const TabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class PaymentTabChanged extends DashboardEvent {
  final int index;
  const PaymentTabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleBalanceVisibility extends DashboardEvent {}

class StartRefreshTimer extends DashboardEvent {}

class RefreshTimerTick extends DashboardEvent {
  final int secondsRemaining;
  const RefreshTimerTick(this.secondsRemaining);

  @override
  List<Object> get props => [secondsRemaining];
}

class UpdateBalance extends DashboardEvent {
  final double amount;
  const UpdateBalance(this.amount);

  @override
  List<Object> get props => [amount];
}

class DashboardLoadBalance extends DashboardEvent {}
