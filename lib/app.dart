import 'package:flutter/cupertino.dart';
import 'package:legacy_keeper/providers/annual_income_provider.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'providers/user_provider.dart';
import 'providers/ancestor_provider.dart';
import 'providers/family_member_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/financial_report_provider.dart';
import 'providers/event_provider.dart';

class LegacyKeeperApp extends StatelessWidget {
  const LegacyKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AncestorProvider()..fetchAncestors()),
        ChangeNotifierProvider(create: (_) => FamilyMemberProvider()..fetchFamilyMembers()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => AnnualIncomeProvider()),
        ChangeNotifierProvider(create: (_) => FinancialReportProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()..fetchEvents()),
      ],
      child: CupertinoApp(
        title: 'Legacy Keeper',
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.systemBlue,
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        // Entry point of the app
        home: const SplashScreen(), // SplashScreen kiểm tra trạng thái đăng nhập
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
