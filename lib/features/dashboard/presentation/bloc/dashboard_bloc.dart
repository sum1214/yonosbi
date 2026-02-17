import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Timer? _timer;

  DashboardBloc() : super(const DashboardState()) {
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
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
