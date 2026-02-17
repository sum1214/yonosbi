import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:yonosbi/features/dashboard/presentation/bloc/payment_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';

void main() {
  runApp(const YonoSbiApp());
}

class YonoSbiApp extends StatelessWidget {
  const YonoSbiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(create: (context) => PaymentBloc()..add(LoadBalance())),
      ],
      child: MaterialApp(
        title: 'YONO SBI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const DashboardScreen(),
      ),
    );
  }
}
