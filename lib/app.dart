import 'package:flutter/cupertino.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'providers/ancestor_provider.dart';
import 'providers/family_member_provider.dart';
import 'providers/contribution_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/financial_overview_provider.dart';
import 'providers/event_provider.dart'; // Import Event Provider

class LegacyKeeperApp extends StatelessWidget {
  const LegacyKeeperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AncestorProvider()..fetchAncestors()),
        ChangeNotifierProvider(create: (_) => FamilyMemberProvider()..fetchFamilyMembers()),
        ChangeNotifierProvider(create: (_) => ContributionProvider()..fetchContributions()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..fetchExpenses()),
        ChangeNotifierProvider(create: (_) => EventProvider()..fetchEvents()), // Event Provider
        ChangeNotifierProvider(
          create: (context) => FinancialOverviewProvider(
            expenseProvider: Provider.of<ExpenseProvider>(context, listen: false),
            contributionProvider: Provider.of<ContributionProvider>(context, listen: false),
          ),
        ),
      ],
      child: CupertinoApp(
        title: 'Legacy Keeper',
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.systemBlue,
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        // Entry point of the app
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(), // Main dashboard
        },
      ),
    );
  }
}
