import 'package:flutter/material.dart';
import 'calculator_button.dart';

class KeypadGrid extends StatelessWidget {
  final Function(String) onButtonPressed;
  final bool showScientific;
  final VoidCallback onOpenMatrix;
  final VoidCallback onOpenStat;
  final VoidCallback onOpenConv;
  final double sciHeight;
  final double basicHeight;
  final double toolsHeight;

  const KeypadGrid({
    super.key,
    required this.onButtonPressed,
    required this.showScientific,
    required this.onOpenMatrix,
    required this.onOpenStat,
    required this.onOpenConv,
    required this.sciHeight,
    required this.basicHeight,
    required this.toolsHeight,
  });

  @override
  Widget build(BuildContext context) {
    final scientificButtons = [
      ['sin', 'cos', 'tan', 'sin⁻¹'],
      ['cos⁻¹', 'tan⁻¹', 'sinh', 'cosh'],
      ['tanh', 'log', 'ln', 'log₂'],
      ['logₓy', 'x²', 'x³', 'x^y'],
      ['√', '∛', 'nPr', 'nCr'],
      ['x!', '1/x', '|x|', 'e^x'],
      ['10^x', '2^x', 'mod', 'π'],
      ['e', 'Rand', 'Ans', 'EXP'],
    ];

    // Perfect 20-button layout including AC, DEL, parentheses, digits 0-9, and all operators (+, -, *, /, ., =)
    final basicButtons = [
      ['AC', 'DEL', '(', ')'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '−'],
      ['0', '.', '+', '='],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double effectiveWidth = width > 500 ? 500 : width;

        return Center(
          child: SizedBox(
            width: effectiveWidth,
            child: Column(
              children: [
                if (!showScientific) ...[
                  SizedBox(
                    height: 36,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildToolChip(context, 'Matrix', Icons.grid_view, onOpenMatrix),
                          _buildToolChip(context, 'STAT', Icons.bar_chart, onOpenStat),
                          _buildToolChip(context, 'CONV', Icons.swap_horiz, onOpenConv),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
                ],
                if (showScientific && sciHeight > 0) ...[
                  SizedBox(
                    height: sciHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: (effectiveWidth / 4) / ((sciHeight - 4) / 8),
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        itemCount: scientificButtons.length * 4,
                        itemBuilder: (context, index) {
                          int row = index ~/ 4;
                          int col = index % 4;
                          String label = scientificButtons[row][col];
                          
                          ButtonType type = ButtonType.function;

                          return CalculatorButton(
                            label: label,
                            type: type,
                            fontSize: 11,
                            onTap: () => onButtonPressed(label),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, indent: 8, endIndent: 8),
                ],
                SizedBox(
                  height: basicHeight > 0 ? basicHeight : 100,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: (effectiveWidth / 4) / ((basicHeight - 12) > 0 ? (basicHeight - 12) / 5 : 60),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        int row = index ~/ 4;
                        int col = index % 4;
                        String label = basicButtons[row][col];

                        ButtonType type = ButtonType.number;
                        if (label == 'AC' || label == 'DEL') {
                          type = ButtonType.action;
                        } else if (label == '÷' || label == '×' || label == '−' || label == '+' || label == '(' || label == ')') {
                          type = label == '(' || label == ')' ? ButtonType.function : ButtonType.operator;
                        } else if (label == '=') {
                          type = ButtonType.equals;
                        }

                        // Perfect, elegant, compact size for simple calculator buttons (fontSize: 16)
                        return CalculatorButton(
                          label: label,
                          type: type,
                          fontSize: 16,
                          onTap: () => onButtonPressed(label),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolChip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: Icon(icon, size: 14, color: theme.colorScheme.primary),
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
