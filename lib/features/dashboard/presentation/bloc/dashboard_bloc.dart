import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<PaymentTabChanged>((event, emit) {
      emit(state.copyWith(paymentTabIndex: event.index));
    });
  }
}
