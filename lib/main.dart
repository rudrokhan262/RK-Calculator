import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/calculator_state.dart';
import 'screens/calculator_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RKCalculatorApp());
}

class RKCalculatorApp extends StatelessWidget {
  const RKCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorState(),
      child: Consumer<CalculatorState>(
        builder: (context, calcState, child) {
          return MaterialApp(
            title: 'RK Calculator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: calcState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}
