import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<LoadBalance>(_onLoadBalance);
    on<CheckBalance>(_onCheckBalance);
    on<ProcessPayment>(_onProcessPayment);
    on<SelectContact>(_onSelectContact);
    on<ResetBalanceVisibility>(_onResetBalanceVisibility);
  }

  Future<void> _onLoadBalance(LoadBalance event, Emitter<PaymentState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    double balance = prefs.getDouble('account_balance') ?? 10000.0;
    if (!prefs.containsKey('account_balance')) {
      await prefs.setDouble('account_balance', 10000.0);
    }
    emit(state.copyWith(balance: balance));
  }

  Future<void> _onCheckBalance(CheckBalance event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true, showBalance: false));
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    double balance = prefs.getDouble('account_balance') ?? 10000.0;
    emit(state.copyWith(isLoading: false, balance: balance, showBalance: true));
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    double currentBalance = prefs.getDouble('account_balance') ?? 10000.0;
    double newBalance = currentBalance - event.amount;
    
    await prefs.setDouble('account_balance', newBalance);
    emit(state.copyWith(isLoading: false, balance: newBalance, showBalance: false));
  }

  Future<void> _onSelectContact(SelectContact event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true));
    // Simulate fetching contact details or some processing
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false, showBalance: false));
    event.onComplete(event.contact);
  }

  void _onResetBalanceVisibility(ResetBalanceVisibility event, Emitter<PaymentState> emit) {
    emit(state.copyWith(showBalance: false));
  }
}
