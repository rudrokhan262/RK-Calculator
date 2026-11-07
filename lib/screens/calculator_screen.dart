import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_state.dart';
import '../widgets/keypad_grid.dart';
import '../widgets/matrix_dialog.dart';
import '../widgets/stat_dialog.dart';
import '../widgets/conv_dialog.dart';
import '../utils/calculator_evaluator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool _showScientific = false;

  void _openMatrixDialog() => showDialog(context: context, builder: (_) => const MatrixDialog());
  void _openStatDialog() => showDialog(context: context, builder: (_) => const StatDialog());
  void _openConvDialog() => showDialog(context: context, builder: (_) => const ConvDialog());

  @override
  Widget build(BuildContext context) {
    final calcState = Provider.of<CalculatorState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RK Calculator'),
        actions: [
          TextButton(
            onPressed: calcState.toggleAngleMode,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              calcState.angleMode == AngleMode.deg ? 'DEG' : 'RAD',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          IconButton(
            icon: Icon(
              _showScientific ? Icons.science : Icons.science_outlined,
              color: _showScientific ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Toggle Scientific Panel',
            onPressed: () => setState(() => _showScientific = !_showScientific),
          ),
          IconButton(
            icon: Icon(calcState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: calcState.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double totalHeight = constraints.maxHeight;

            // Strict proportioning with toolsHeight accounted for when !showScientific
            final double displayHeight = totalHeight * 0.18;
            final double toolsHeight = !_showScientific ? 38.0 : 0.0;
            final double sciHeight = _showScientific ? totalHeight * 0.36 : 0.0;
            final double basicHeight = totalHeight - displayHeight - toolsHeight - sciHeight - 6.0;

            return Column(
              children: [
                // Display Area
                SizedBox(
                  height: displayHeight,
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            calcState.expression.isEmpty ? '' : calcState.expression,
                            style: TextStyle(
                              fontSize: 19,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            calcState.result,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: calcState.result == 'Error'
                                  ? Colors.redAccent
                                  : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Keypad with exact computed heights (Fit-to-screen, zero overflow)
                Expanded(
                  child: KeypadGrid(
                    onButtonPressed: (val) => calcState.onButtonPressed(val),
                    showScientific: _showScientific,
                    onOpenMatrix: _openMatrixDialog,
                    onOpenStat: _openStatDialog,
                    onOpenConv: _openConvDialog,
                    sciHeight: sciHeight,
                    basicHeight: basicHeight,
                    toolsHeight: toolsHeight,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
