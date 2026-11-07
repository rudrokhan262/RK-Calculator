import 'dart:math' as math;

// 1. Complex Numbers
class ComplexNumber {
  final double real;
  final double imag;

  const ComplexNumber(this.real, this.imag);

  ComplexNumber operator +(ComplexNumber o) => ComplexNumber(real + o.real, imag + o.imag);
  ComplexNumber operator -(ComplexNumber o) => ComplexNumber(real - o.real, imag - o.imag);
  ComplexNumber operator *(ComplexNumber o) => ComplexNumber(real * o.real - imag * o.imag, real * o.imag + imag * o.real);
  ComplexNumber operator /(ComplexNumber o) {
    double denom = o.real * o.real + o.imag * o.imag;
    if (denom == 0) throw Exception('Division by zero in complex numbers');
    return ComplexNumber((real * o.real + imag * o.imag) / denom, (imag * o.real - real * o.imag) / denom);
  }

  ComplexNumber get conjugate => ComplexNumber(real, -imag);
  double get modulus => math.sqrt(real * real + imag * imag);
  double get argument => math.atan2(imag, real);

  @override
  String toString() {
    if (imag == 0) return '$real';
    if (real == 0) return '${imag}i';
    String sign = imag < 0 ? '-' : '+';
    return '$real $sign ${imag.abs()}i';
  }
}

// 2. Matrix Calculator (2x2 and 3x3)
class Matrix {
  final List<List<double>> data;
  int get rows => data.length;
  int get cols => data[0].length;

  Matrix(this.data);

  static Matrix identity(int n) {
    return Matrix(List.generate(n, (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0)));
  }

  Matrix operator +(Matrix o) {
    if (rows != o.rows || cols != o.cols) throw Exception('Matrix dimension mismatch');
    return Matrix(List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] + o.data[i][j])));
  }

  Matrix operator -(Matrix o) {
    if (rows != o.rows || cols != o.cols) throw Exception('Matrix dimension mismatch');
    return Matrix(List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] - o.data[i][j])));
  }

  Matrix operator *(Matrix o) {
    if (cols != o.rows) throw Exception('Invalid matrix dimensions for multiplication');
    int r = rows;
    int c = o.cols;
    int common = cols;
    return Matrix(List.generate(r, (i) => List.generate(c, (j) {
      double sum = 0;
      for (int k = 0; k < common; k++) {
        sum += data[i][k] * o.data[k][j];
      }
      return sum;
    })));
  }

  Matrix get transpose => Matrix(List.generate(cols, (j) => List.generate(rows, (i) => data[i][j])));

  double get determinant {
    if (rows != cols) throw Exception('Determinant only defined for square matrices');
    if (rows == 2) {
      return data[0][0] * data[1][1] - data[0][1] * data[1][0];
    } else if (rows == 3) {
      return data[0][0] * (data[1][1] * data[2][2] - data[1][2] * data[2][1]) -
             data[0][1] * (data[1][0] * data[2][2] - data[1][2] * data[2][0]) +
             data[0][2] * (data[1][0] * data[2][1] - data[1][1] * data[2][0]);
    }
    throw Exception('Determinant supported for 2x2 and 3x3 only');
  }

  Matrix get inverse {
    double det = determinant;
    if (det == 0) throw Exception('Matrix is singular (determinant is 0)');
    if (rows == 2) {
      return Matrix([
        [data[1][1] / det, -data[0][1] / det],
        [-data[1][0] / det, data[0][0] / det]
      ]);
    } else if (rows == 3) {
      double d00 = (data[1][1] * data[2][2] - data[1][2] * data[2][1]);
      double d01 = -(data[1][0] * data[2][2] - data[1][2] * data[2][0]);
      double d02 = (data[1][0] * data[2][1] - data[1][1] * data[2][0]);
      double d10 = -(data[0][1] * data[2][2] - data[0][2] * data[2][1]);
      double d11 = (data[0][0] * data[2][2] - data[0][2] * data[2][0]);
      double d12 = -(data[0][0] * data[2][1] - data[0][1] * data[2][0]);
      double d20 = (data[0][1] * data[1][2] - data[0][2] * data[1][1]);
      double d21 = -(data[0][0] * data[1][2] - data[0][2] * data[1][0]);
      double d22 = (data[0][0] * data[1][1] - data[0][1] * data[1][0]);

      Matrix adj = Matrix([
        [d00, d10, d20],
        [d01, d11, d21],
        [d02, d12, d22]
      ]);

      return Matrix(List.generate(3, (i) => List.generate(3, (j) => adj.data[i][j] / det)));
    }
    throw Exception('Inverse supported for 2x2 and 3x3 only');
  }
}

// 3. Calculus Functions (Numerical Methods)
class Calculus {
  static double integrate(double Function(double) f, double a, double b, [int n = 100]) {
    if (n % 2 != 0) n++;
    double h = (b - a) / n;
    double sum = f(a) + f(b);

    for (int i = 1; i < n; i++) {
      double x = a + i * h;
      sum += f(x) * (i % 2 == 0 ? 2 : 4);
    }
    return sum * h / 3;
  }

  static double derivative(double Function(double) f, double x, [double h = 1e-5]) {
    return (f(x + h) - f(x - h)) / (2 * h);
  }

  static double summation(double Function(double) f, int start, int end) {
    double sum = 0;
    for (int i = start; i <= end; i++) {
      sum += f(i.toDouble());
    }
    return sum;
  }

  static double limit(double Function(double) f, double target, [double h = 1e-6]) {
    double v1 = f(target + h);
    double v2 = f(target - h);
    return (v1 + v2) / 2;
  }
}

// 4. Permutation and Combination
class Combinatorics {
  static double factorial(int n) {
    if (n < 0 || n > 170) throw Exception('Invalid factorial range');
    double f = 1;
    for (int i = 2; i <= n; i++) {
      f *= i;
    }
    return f;
  }

  static double permutation(int n, int r) {
    if (n < 0 || r < 0 || r > n) throw Exception('Invalid nPr parameters');
    return factorial(n) / factorial(n - r);
  }

  static double combination(int n, int r) {
    if (n < 0 || r < 0 || r > n) throw Exception('Invalid nCr parameters');
    return factorial(n) / (factorial(r) * factorial(n - r));
  }
}

// 5. Fraction Functions
class Fraction {
  final int numerator;
  final int denominator;

  Fraction(this.numerator, int denom) : denominator = denom == 0 ? throw Exception('Denominator cannot be zero') : denom {
    int gcdVal = _gcd(numerator.abs(), denominator.abs());
    int sign = denominator < 0 ? -1 : 1;
    _num = (numerator * sign) ~/ gcdVal;
    _den = (denominator * sign) ~/ gcdVal;
  }

  late final int _num;
  late final int _den;

  int get num => _num;
  int get den => _den;

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  Fraction operator +(Fraction o) => Fraction(num * o.den + o.num * den, den * o.den);
  Fraction operator -(Fraction o) => Fraction(num * o.den - o.num * den, den * o.den);
  Fraction operator *(Fraction o) => Fraction(num * o.num, den * o.den);
  Fraction operator /(Fraction o) => Fraction(num * o.den, den * o.den);

  double toDecimal() => num / den;

  static Fraction fromDecimal(double val, [int maxDenom = 10000]) {
    int bestNum = 1, bestDen = 1;
    double minErr = (val - 1).abs();
    for (int d = 1; d <= maxDenom; d++) {
      int n = (val * d).round();
      double err = (val - n / d).abs();
      if (err < minErr) {
        minErr = err;
        bestNum = n;
        bestDen = d;
      }
    }
    return Fraction(bestNum, bestDen);
  }

  @override
  String toString() => den == 1 ? '$num' : '$num/$den';
}

// 6. Angle and Trigonometric Extensions (Hyperbolic & DMS)
class TrigExtensions {
  static double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2;
  static double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2;
  static double tanh(double x) => sinh(x) / cosh(x);
  static double asinh(double x) => math.log(x + math.sqrt(x * x + 1));
  static double acosh(double x) {
    if (x < 1) throw Exception('Domain error for acosh');
    return math.log(x + math.sqrt(x * x - 1));
  }
  static double atanh(double x) {
    if (x <= -1 || x >= 1) throw Exception('Domain error for atanh');
    return 0.5 * math.log((1 + x) / (1 - x));
  }

  static String toDms(double decimalDegrees) {
    int deg = decimalDegrees.truncate();
    double minFloat = (decimalDegrees.abs() - deg.abs()) * 60;
    int min = minFloat.truncate();
    double sec = (minFloat - min) * 60;
    return '$deg° $min\' ${sec.toStringAsFixed(2)}"';
  }

  static double fromDms(int deg, int min, double sec) {
    double sign = deg < 0 ? -1.0 : 1.0;
    return sign * (deg.abs() + min / 60.0 + sec / 3600.0);
  }
}

// 7. Statistical Functions
class StatCalculator {
  static Map<String, double> calculate(List<double> data) {
    if (data.isEmpty) throw Exception('Dataset is empty');
    int n = data.length;
    double sumX = data.fold(0.0, (a, b) => a + b);
    double sumX2 = data.fold(0.0, (a, b) => a + b * b);
    double mean = sumX / n;

    List<double> sorted = List.from(data)..sort();
    double median = n % 2 == 1 
        ? sorted[n ~/ 2] 
        : (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;

    Map<double, int> counts = {};
    for (var val in data) {
      counts[val] = (counts[val] ?? 0) + 1;
    }
    double mode = data[0];
    int maxCount = 0;
    counts.forEach((k, v) {
      if (v > maxCount) {
        maxCount = v;
        mode = k;
      }
    });

    double popVar = data.fold(0.0, (a, b) => a + math.pow(b - mean, 2)) / n;
    double sampleVar = n > 1 ? data.fold(0.0, (a, b) => a + math.pow(b - mean, 2)) / (n - 1) : 0.0;

    return {
      'n': n.toDouble(),
      'sumX': sumX,
      'sumX2': sumX2,
      'mean': mean,
      'median': median,
      'mode': mode,
      'popVar': popVar,
      'sampleVar': sampleVar,
      'popStdDev': math.sqrt(popVar),
      'sampleStdDev': math.sqrt(sampleVar),
      'min': sorted.first,
      'max': sorted.last,
    };
  }
}

// 10. Scientific Conversion Functions (CONV)
class UnitConverter {
  static const Map<String, Map<String, double>> categories = {
    'Length': {'Meters': 1.0, 'Kilometers': 1000.0, 'Centimeters': 0.01, 'Miles': 1609.34, 'Feet': 0.3048},
    'Mass': {'Grams': 1.0, 'Kilograms': 1000.0, 'Pounds': 453.592, 'Ounces': 28.3495},
    'Volume': {'Liters': 1.0, 'Milliliters': 0.001, 'Gallons': 3.78541},
    'Speed': {'m/s': 1.0, 'km/h': 0.277778, 'mph': 0.44704},
  };

  static double convert(String category, String fromUnit, String toUnit, double value) {
    var cat = categories[category];
    if (cat == null) throw Exception('Unknown conversion category');
    double? fromFactor = cat[fromUnit];
    double? toFactor = cat[toUnit];
    if (fromFactor == null || toFactor == null) throw Exception('Unknown unit');
    double baseValue = value * fromFactor;
    return baseValue / toFactor;
  }
}
