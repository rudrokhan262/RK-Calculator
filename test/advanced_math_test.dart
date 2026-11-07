import 'package:flutter_test/flutter_test.dart';
import 'package:rk_calculator/utils/advanced_math.dart';
import 'package:rk_calculator/utils/calculator_evaluator.dart';

void main() {
  group('Advanced Mathematical Features Tests', () {
    test('Complex Number Calculations', () {
      var c1 = ComplexNumber(3, 2);
      var c2 = ComplexNumber(1, 4);
      expect((c1 + c2).real, 4.0);
      expect((c1 + c2).imag, 6.0);
      expect((c1 * c2).real, -5.0);
      expect((c1 * c2).imag, 14.0);
      expect(c1.modulus, closeTo(3.60555, 1e-4));
      expect(c1.conjugate.imag, -2.0);
    });

    test('Matrix Operations', () {
      var m1 = Matrix([
        [1.0, 2.0],
        [3.0, 4.0]
      ]);
      var m2 = Matrix([
        [5.0, 6.0],
        [7.0, 8.0]
      ]);
      var sum = m1 + m2;
      expect(sum.data[0][0], 6.0);
      expect(sum.data[1][1], 12.0);
      expect(m1.determinant, -2.0);
    });

    test('Calculus Functions', () {
      // Integral of x^2 from 0 to 3 should be 9
      double integral = Calculus.integrate((x) => x * x, 0, 3, 100);
      expect(integral, closeTo(9.0, 1e-2));

      // Derivative of x^2 at x=3 should be 6
      double deriv = Calculus.derivative((x) => x * x, 3);
      expect(deriv, closeTo(6.0, 1e-4));
    });

    test('Permutation and Combination', () {
      expect(Combinatorics.permutation(5, 2), 20.0);
      expect(Combinatorics.combination(5, 2), 10.0);
      expect(Combinatorics.factorial(4), 24.0);
    });

    test('Fraction Arithmetic', () {
      var f1 = Fraction(1, 2);
      var f2 = Fraction(1, 3);
      var sum = f1 + f2;
      expect(sum.num, 5);
      expect(sum.den, 6);
      expect(f1.toDecimal(), 0.5);
    });

    test('Trig Extensions & DMS', () {
      expect(TrigExtensions.sinh(0), 0.0);
      expect(TrigExtensions.cosh(0), 1.0);
      String dms = TrigExtensions.toDms(45.5);
      expect(dms, contains('45°'));
    });

    test('Statistical Calculations', () {
      var stats = StatCalculator.calculate([10, 20, 30, 40, 50]);
      expect(stats['n'], 5.0);
      expect(stats['mean'], 30.0);
      expect(stats['min'], 10.0);
      expect(stats['max'], 50.0);
    });

    test('Memory & Advanced Evaluator Operations', () {
      CalculatorEvaluator.memory = 10.0;
      expect(CalculatorEvaluator.evaluate('MR + 5', AngleMode.deg).value, 15.0);
      expect(CalculatorEvaluator.evaluate('logx(2, 8)', AngleMode.deg).value, 3.0);
      expect(CalculatorEvaluator.evaluate('npr(5,2)', AngleMode.deg).value, 20.0);
      expect(CalculatorEvaluator.evaluate('ncr(5,2)', AngleMode.deg).value, 10.0);
    });

    test('Unit Conversions', () {
      double res = UnitConverter.convert('Length', 'Kilometers', 'Meters', 2.0);
      expect(res, 2000.0);
    });
  });
}
