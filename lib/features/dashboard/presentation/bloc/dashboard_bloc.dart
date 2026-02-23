import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Timer? _timer;

  DashboardBloc() : super(const DashboardState()) {
    on<DashboardLoadBalance>(_onDashboardLoadBalance);
    
    on<TabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<PaymentTabChanged>((event, emit) {
      emit(state.copyWith(paymentTabIndex: event.index));
    });

    on<ToggleBalanceVisibility>((event, emit) {
      emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
    });

    on<StartRefreshTimer>((event, emit) {
      if (state.isRefreshing) return;

      _timer?.cancel();
      emit(state.copyWith(isRefreshing: true, refreshTimer: 30));

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(RefreshTimerTick(30 - timer.tick));
      });
    });

    on<RefreshTimerTick>((event, emit) {
      if (event.secondsRemaining <= 0) {
        _timer?.cancel();
        emit(state.copyWith(isRefreshing: false, refreshTimer: 0));
      } else {
        emit(state.copyWith(refreshTimer: event.secondsRemaining));
      }
    });

    on<UpdateBalance>(_onUpdateBalance);
  }

  Future<void> _onDashboardLoadBalance(DashboardLoadBalance event, Emitter<DashboardState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    double balance = prefs.getDouble('account_balance') ?? 100000;
    if (!prefs.containsKey('account_balance')) {
      await prefs.setDouble('account_balance', 100000);
    }
    emit(state.copyWith(balance: balance));
  }

  Future<void> _onUpdateBalance(UpdateBalance event, Emitter<DashboardState> emit) async {
    final newBalance = state.balance - event.amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('account_balance', newBalance);
    emit(state.copyWith(balance: newBalance));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
