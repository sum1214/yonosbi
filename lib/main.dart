import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/features/auth/presentation/pages/login_screen.dart';
import 'package:yonosbi/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:yonosbi/features/payments/upi/presentation/bloc/payment_bloc.dart';
import 'package:yonosbi/features/payments/send_money_abroad/presentation/bloc/send_money_abroad_bloc.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const YonoSbiApp());
}

class YonoSbiApp extends StatelessWidget {
  const YonoSbiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashboardBloc()..add(DashboardLoadBalance())),
        BlocProvider(create: (context) => PaymentBloc()..add(LoadBalance())),
        BlocProvider(create: (context) => SendMoneyAbroadBloc()),
      ],
      child: MaterialApp(
        title: 'YONO SBI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
