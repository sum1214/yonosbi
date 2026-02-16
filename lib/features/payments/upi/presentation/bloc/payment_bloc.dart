import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_contacts/fast_contacts.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<LoadBalance>(_onLoadBalance);
    on<CheckBalance>(_onCheckBalance);
    on<ProcessPayment>(_onProcessPayment);
    on<SelectContact>(_onSelectContact);
    on<ResetBalanceVisibility>(_onResetBalanceVisibility);
    on<SearchRecipient>(_onSearchRecipient);
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
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false, showBalance: false));
    event.onComplete(event.contact);
  }

  void _onResetBalanceVisibility(ResetBalanceVisibility event, Emitter<PaymentState> emit) {
    emit(state.copyWith(showBalance: false));
  }

  Future<void> _onSearchRecipient(SearchRecipient event, Emitter<PaymentState> emit) async {
    final query = event.query;
    if (query.length == 10 && RegExp(r'^[0-9]+$').hasMatch(query)) {
      emit(state.copyWith(isLoading: true));
      
      // Simulated API delay for name lookup
      await Future.delayed(const Duration(seconds: 1));
      
      final contacts = await FastContacts.getAllContacts();
      String name = 'UNKNOWN RECIPIENT';
      String upiId = '$query@mbkns';
      
      for (var contact in contacts) {
        for (var phone in contact.phones) {
          if (phone.number.replaceAll(RegExp(r'[^0-9]'), '').endsWith(query)) {
            name = contact.displayName;
            break;
          }
        }
      }
      
      emit(state.copyWith(
        isLoading: false,
        searchResultName: name,
        searchResultUpi: upiId,
        showRecipient: true,
      ));
    } else if (query.contains('@')) {
      emit(state.copyWith(
        searchResultName: query.split('@').first.toUpperCase(),
        searchResultUpi: query,
        showRecipient: true,
      ));
    } else {
      emit(state.copyWith(showRecipient: false));
    }
  }
}
