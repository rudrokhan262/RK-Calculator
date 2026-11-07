import 'package:flutter_test/flutter_test.dart';
import 'package:rk_calculator/utils/calculator_evaluator.dart';

void main() {
  group('CalculatorEvaluator Tests', () {
    test('Basic arithmetic operations', () {
      expect(CalculatorEvaluator.evaluate('2+3*4', AngleMode.deg).value, 14.0);
      expect(CalculatorEvaluator.evaluate('(2+3)*4', AngleMode.deg).value, 20.0);
      expect(CalculatorEvaluator.evaluate('10-5/2', AngleMode.deg).value, 7.5);
      expect(CalculatorEvaluator.evaluate('5%', AngleMode.deg).value, 0.05);
    });

    test('Scientific operations', () {
      expect(CalculatorEvaluator.evaluate('sin(90)', AngleMode.deg).value, closeTo(1.0, 1e-5));
      expect(CalculatorEvaluator.evaluate('cos(0)', AngleMode.deg).value, closeTo(1.0, 1e-5));
      expect(CalculatorEvaluator.evaluate('sqrt(16)', AngleMode.deg).value, 4.0);
      expect(CalculatorEvaluator.evaluate('cbrt(27)', AngleMode.deg).value, closeTo(3.0, 1e-5));
      expect(CalculatorEvaluator.evaluate('log10(100)', AngleMode.deg).value, 2.0);
      expect(CalculatorEvaluator.evaluate('ln(2.718281828459045)', AngleMode.deg).value, closeTo(1.0, 1e-4));
      expect(CalculatorEvaluator.evaluate('2^3', AngleMode.deg).value, 8.0);
      expect(CalculatorEvaluator.evaluate('5!', AngleMode.deg).value, 120.0);
    });

    test('Error handling', () {
      expect(CalculatorEvaluator.evaluate('5/0', AngleMode.deg).hasError, true);
      expect(CalculatorEvaluator.evaluate('sqrt(-4)', AngleMode.deg).hasError, true);
      expect(CalculatorEvaluator.evaluate('log10(0)', AngleMode.deg).hasError, true);
    });
  });
}
