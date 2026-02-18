import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/payee_model.dart';

class PayeeRepository {
  static const String _key = 'saved_payees';

  Future<void> savePayee(Payee payee) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_key) ?? [];
    saved.add(payee.toJson());
    await prefs.setStringList(_key, saved);
  }

  Future<List<Payee>> getPayees() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(_key);
    if (saved == null) return [];
    return saved.map((e) => Payee.fromJson(e)).toList();
  }
}
