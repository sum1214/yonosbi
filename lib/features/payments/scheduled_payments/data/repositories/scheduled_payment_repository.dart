import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/scheduled_payment_model.dart';

class ScheduledPaymentRepository {
  static const String _key = 'scheduled_payments';

  Future<void> saveScheduledPayment(ScheduledPayment payment) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> paymentsJson = prefs.getStringList(_key) ?? [];
    paymentsJson.add(payment.toJson());
    await prefs.setStringList(_key, paymentsJson);
  }

  Future<List<ScheduledPayment>> getScheduledPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> paymentsJson = prefs.getStringList(_key) ?? [];
    return paymentsJson.map((json) => ScheduledPayment.fromJson(json)).toList();
  }
}
