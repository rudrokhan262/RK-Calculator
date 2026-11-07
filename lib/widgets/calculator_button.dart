import 'package:flutter/material.dart';

enum ButtonType { number, operator, function, action, equals }

class CalculatorButton extends StatelessWidget {
  final String label;
  final ButtonType type;
  final VoidCallback onTap;
  final double fontSize;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color getBackgroundColor() {
      switch (type) {
        case ButtonType.number:
          return isDark ? const Color(0xFF1E293B) : Colors.white;
        case ButtonType.operator:
          return isDark ? const Color(0xFF334155).withValues(alpha: 0.6) : const Color(0xFFE2E8F0);
        case ButtonType.function:
          return isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.7) : const Color(0xFFEDE9FE);
        case ButtonType.action:
          return isDark ? const Color(0xFF451A03).withValues(alpha: 0.6) : const Color(0xFFFEE2E2);
        case ButtonType.equals:
          return const Color(0xFF6366F1); // Vibrant indigo for equals
      }
    }

    Color getTextColor() {
      switch (type) {
        case ButtonType.number:
          return isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        case ButtonType.operator:
          return isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
        case ButtonType.function:
          return isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
        case ButtonType.action:
          return isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
        case ButtonType.equals:
          return Colors.white;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: getTextColor().withValues(alpha: 0.2),
        highlightColor: getTextColor().withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            color: getBackgroundColor(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: type == ButtonType.equals
                ? [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: getTextColor(),
            ),
          ),
        ),
      ),
    );
  }
}
