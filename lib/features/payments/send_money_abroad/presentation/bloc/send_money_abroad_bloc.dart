import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'send_money_abroad_event.dart';
import 'send_money_abroad_state.dart';

class SendMoneyAbroadBloc extends Bloc<SendMoneyAbroadEvent, SendMoneyAbroadState> {
  static const String _payeesKey = 'send_money_abroad_payees';
  static const String _recentPayeesKey = 'send_money_abroad_recent_payees';

  SendMoneyAbroadBloc() : super(SendMoneyAbroadInitial()) {
    on<LoadSendMoneyAbroadData>((event, emit) async {
      emit(SendMoneyAbroadLoading());
      
      final prefs = await SharedPreferences.getInstance();
      
      // Load added payees
      final String? payeesJson = prefs.getString(_payeesKey);
      List<Payee> payees = [];
      if (payeesJson != null) {
        final List<dynamic> decoded = json.decode(payeesJson);
        payees = decoded.map((item) => Payee.fromMap(item)).toList();
      }

      // Load recent payees
      final String? recentPayeesJson = prefs.getString(_recentPayeesKey);
      List<Payee> recentPayees = [];
      if (recentPayeesJson != null) {
        final List<dynamic> decoded = json.decode(recentPayeesJson);
        recentPayees = decoded.map((item) => Payee.fromMap(item)).toList();
      }

      emit(SendMoneyAbroadLoaded(
        countries: const ['USA', 'UK', 'Canada', 'Australia', 'Germany', 'UAE'],
        selectedCountry: 'USA',
        exchangeRate: 83.45,
        payees: payees,
        recentPayees: recentPayees,
      ));
    });

    on<AddPayeeEvent>((event, emit) async {
      if (state is SendMoneyAbroadLoaded) {
        final currentState = state as SendMoneyAbroadLoaded;
        final updatedPayees = List<Payee>.from(currentState.payees)..add(event.payee);
        
        final prefs = await SharedPreferences.getInstance();
        final String payeesJson = json.encode(updatedPayees.map((p) => p.toMap()).toList());
        await prefs.setString(_payeesKey, payeesJson);
        
        emit(currentState.copyWith(payees: updatedPayees));
      }
    });

    on<SubmitInternationalTransfer>((event, emit) async {
      if (state is SendMoneyAbroadLoaded) {
        final currentState = state as SendMoneyAbroadLoaded;
        emit(SendMoneyAbroadLoading());
        
        // Simulating API call
        await Future.delayed(const Duration(seconds: 2));
        
        // Find the payee being paid (assuming for now we use the selected country or find by some logic)
        // In a real scenario, the event would include the Payee object
        // Let's assume for this mock we just add the first matching payee or a mock one to recent list
        
        final prefs = await SharedPreferences.getInstance();
        List<Payee> currentRecent = List<Payee>.from(currentState.recentPayees);
        
        // Add to recent if not already there (mock logic)
        // In actual implementation, you'd pass the specific payee in the event
        
        emit(const SendMoneyAbroadSuccess('TXN_ABROAD_123456'));
        
        // After success, we would normally trigger a reload or update state with new recent payee
      }
    });
  }
}
