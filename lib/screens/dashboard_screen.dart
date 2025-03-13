import 'package:flutter/cupertino.dart';
import 'package:legacy_keeper/screens/family_tree_graph.dart';
import 'package:legacy_keeper/screens/financial_management_screen.dart';
import 'package:legacy_keeper/screens/event_screen.dart'; // Import Event Management screen
import 'package:legacy_keeper/screens/settings_screen.dart'; // Import Settings screen
import '../screens/ancestor_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showWelcome = true; // Determines whether to show Welcome screen
  int _selectedIndex = 0; // Keeps track of the selected BottomNavigationBar index

  // List of screens for the Bottom Navigation Bar
  final List<Widget> _screens = [
    const AncestorScreen(), // Ancestor management
    const FamilyTreeGraph(), // Family Tree functionality
    const FinancialManagementScreen(), // Financial Management functionality
    const EventScreen(), // Event Management functionality
    const SettingsScreen(), // Settings functionality
  ];

  // Welcome screen
  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to Legacy Keeper!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your family history starts here.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          CupertinoButton.filled(
            child: const Text("Continue"),
            onPressed: () {
              setState(() {
                showWelcome = false; // Show Bottom Navigation Bar after Welcome
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: showWelcome
            ? _buildWelcomeScreen() // Show Welcome screen
            : Column(
                children: [
                  // Current screen based on selected tab
                  Expanded(
                    child: _screens[_selectedIndex],
                  ),
                  // Bottom Navigation Bar
                  CupertinoTabBar(
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index; // Change tab
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person_crop_circle),
                        label: "Ancestor",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.tree),
                        label: "Family Tree",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.money_dollar_circle),
                        label: "Finance",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.calendar),
                        label: "Events",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.settings),
                        label: "Settings", // Settings Management
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
