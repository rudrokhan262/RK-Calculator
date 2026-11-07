import 'dart:math' as math;
import 'advanced_math.dart';

enum AngleMode { deg, rad }

class EvaluationResult {
  final double? value;
  final String? error;

  EvaluationResult({this.value, this.error});

  bool get hasError => error != null;
}

class CalculatorEvaluator {
  static double lastAns = 0.0;
  static double memory = 0.0;

  static EvaluationResult evaluate(String expression, AngleMode angleMode) {
    if (expression.trim().isEmpty) {
      return EvaluationResult(value: 0.0);
    }

    try {
      String processed = _preprocessExpression(expression);
      List<Token> tokens = _tokenize(processed);
      Parser parser = Parser(tokens, angleMode);
      double result = parser.parse();

      if (result.isNaN) {
        return EvaluationResult(error: 'Result is NaN');
      }
      if (result.isInfinite) {
        return EvaluationResult(error: 'Division by zero');
      }

      lastAns = result;
      return EvaluationResult(value: result);
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      return EvaluationResult(error: msg);
    }
  }

  static String _preprocessExpression(String expr) {
    String s = expr
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('π', '(${math.pi})')
        .replaceAll('e', '(${math.e})')
        .replaceAll('Ans', '$lastAns')
        .replaceAll('MR', '$memory')
        .replaceAll('√(', 'sqrt(')
        .replaceAll('∛(', 'cbrt(')
        .replaceAll('sin⁻¹(', 'asin(')
        .replaceAll('cos⁻¹(', 'acos(')
        .replaceAll('tan⁻¹(', 'atan(')
        .replaceAll('log(', 'log10(')
        .replaceAll('ln(', 'ln(')
        .replaceAll('log₂(', 'log2(')
        .replaceAll('abs(', 'abs(');

    return s;
  }

  static List<Token> _tokenize(String expr) {
    List<Token> tokens = [];
    int i = 0;
    while (i < expr.length) {
      String c = expr[i];

      if (c.trim().isEmpty) {
        i++;
        continue;
      }

      if (_isDigit(c) || c == '.') {
        String numStr = '';
        bool hasDecimal = false;
        while (i < expr.length && (_isDigit(expr[i]) || expr[i] == '.')) {
          if (expr[i] == '.') {
            if (hasDecimal) {
              throw Exception('Invalid decimal format');
            }
            hasDecimal = true;
          }
          numStr += expr[i];
          i++;
        }
        if (i < expr.length && (expr[i] == 'e' || expr[i] == 'E') && i + 1 < expr.length && (_isDigit(expr[i+1]) || expr[i+1] == '+' || expr[i+1] == '-')) {
          numStr += expr[i];
          i++;
          if (expr[i] == '+' || expr[i] == '-') {
            numStr += expr[i];
            i++;
          }
          while (i < expr.length && _isDigit(expr[i])) {
            numStr += expr[i];
            i++;
          }
        }
        tokens.add(Token(TokenType.number, numStr));
        continue;
      }

      if (_isAlpha(c)) {
        String idStr = '';
        while (i < expr.length && (_isAlpha(expr[i]) || _isDigit(expr[i]))) {
          idStr += expr[i];
          i++;
        }
        tokens.add(Token(TokenType.identifier, idStr.toLowerCase()));
        continue;
      }

      if ('+-*/^%!|(),'.contains(c)) {
        tokens.add(Token(TokenType.operator, c));
        i++;
        continue;
      }

      throw Exception('Unexpected character: $c');
    }

    return tokens;
  }

  static bool _isDigit(String c) {
    return c.compareTo('0') >= 0 && c.compareTo('9') <= 0;
  }

  static bool _isAlpha(String c) {
    return (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
        (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0);
  }
}

enum TokenType { number, identifier, operator }

class Token {
  final TokenType type;
  final String value;
  Token(this.type, this.value);
}

class Parser {
  final List<Token> tokens;
  final AngleMode angleMode;
  int pos = 0;

  Parser(this.tokens, this.angleMode);

  Token? get current => pos < tokens.length ? tokens[pos] : null;

  Token? consume() {
    Token? t = current;
    pos++;
    return t;
  }

  double parse() {
    if (tokens.isEmpty) {
      return 0.0;
    }
    double result = parseExpression();
    if (pos < tokens.length) {
      throw Exception('Unexpected token: ${current?.value}');
    }
    return result;
  }

  double parseExpression() {
    double node = parseTerm();
    while (current != null && (current!.value == '+' || current!.value == '-')) {
      String op = consume()!.value;
      double right = parseTerm();
      if (op == '+') {
        node += right;
      } else {
        node -= right;
      }
    }
    return node;
  }

  double parseTerm() {
    double node = parsePower();
    while (current != null && (current!.value == '*' || current!.value == '/' || current!.value == 'mod')) {
      String op = consume()!.value;
      double right = parsePower();
      if (op == '*') {
        node *= right;
      } else if (op == '/') {
        if (right == 0) {
          throw Exception('Division by zero');
        }
        node /= right;
      } else if (op == 'mod') {
        if (right == 0) {
          throw Exception('Modulo by zero');
        }
        node = node % right;
      }
    }
    return node;
  }

  double parsePower() {
    double node = parseUnary();
    if (current != null && current!.value == '^') {
      consume();
      double right = parsePower();
      node = math.pow(node, right).toDouble();
    }
    return node;
  }

  double parseUnary() {
    if (current != null) {
      if (current!.value == '+') {
        consume();
        return parseUnary();
      }
      if (current!.value == '-') {
        consume();
        return -parseUnary();
      }
      if (current!.type == TokenType.identifier) {
        String func = current!.value;
        consume();
        
        if (current == null || current!.value != '(') {
          throw Exception('Expected "(" after $func');
        }
        consume(); // '('
        double arg1 = parseExpression();
        double? arg2;
        if (current != null && current!.value == ',') {
          consume();
          arg2 = parseExpression();
        }
        if (current == null || current!.value != ')') {
          throw Exception('Expected ")"');
        }
        consume(); // ')'

        return _evaluateFunction(func, arg1, arg2);
      }
    }

    return parsePostfix();
  }

  double _evaluateFunction(String func, double x, double? y) {
    switch (func) {
      case 'sqrt':
        if (x < 0) throw Exception('Square root of negative number');
        return math.sqrt(x);
      case 'cbrt':
        return x < 0 ? -math.pow(-x, 1/3).toDouble() : math.pow(x, 1/3).toDouble();
      case 'sin':
        double rad = angleMode == AngleMode.deg ? x * math.pi / 180 : x;
        return math.sin(rad);
      case 'cos':
        double rad = angleMode == AngleMode.deg ? x * math.pi / 180 : x;
        return math.cos(rad);
      case 'tan':
        double rad = angleMode == AngleMode.deg ? x * math.pi / 180 : x;
        return math.tan(rad);
      case 'sinh':
        return TrigExtensions.sinh(x);
      case 'cosh':
        return TrigExtensions.cosh(x);
      case 'tanh':
        return TrigExtensions.tanh(x);
      case 'asinh':
        return TrigExtensions.asinh(x);
      case 'acosh':
        return TrigExtensions.acosh(x);
      case 'atanh':
        return TrigExtensions.atanh(x);
      case 'asin':
        if (x < -1 || x > 1) throw Exception('Domain error for asin');
        double res = math.asin(x);
        return angleMode == AngleMode.deg ? res * 180 / math.pi : res;
      case 'acos':
        if (x < -1 || x > 1) throw Exception('Domain error for acos');
        double res = math.acos(x);
        return angleMode == AngleMode.deg ? res * 180 / math.pi : res;
      case 'atan':
        double res = math.atan(x);
        return angleMode == AngleMode.deg ? res * 180 / math.pi : res;
      case 'log10':
        if (x <= 0) throw Exception('Logarithm of non-positive number');
        return math.log(x) / math.ln10;
      case 'ln':
        if (x <= 0) throw Exception('Natural log of non-positive number');
        return math.log(x);
      case 'log2':
        if (x <= 0) throw Exception('Log2 of non-positive number');
        return math.log(x) / math.log(2);
      case 'logx':
        if (y == null || y <= 0 || x <= 0 || x == 1) throw Exception('Invalid arguments for logx');
        return math.log(y) / math.log(x);
      case 'npr':
        if (y == null) throw Exception('nPr requires two arguments');
        return Combinatorics.permutation(x.toInt(), y.toInt());
      case 'ncr':
        if (y == null) throw Exception('nCr requires two arguments');
        return Combinatorics.combination(x.toInt(), y.toInt());
      case 'abs':
        return x.abs();
      case 'rand':
      case 'ran#':
        return math.Random().nextDouble();
      default:
        throw Exception('Unknown function: $func');
    }
  }

  double parsePostfix() {
    double node = parsePrimary();
    while (current != null && (current!.value == '!' || current!.value == '%')) {
      String op = consume()!.value;
      if (op == '!') {
        if (node < 0 || node != node.roundToDouble() || node > 170) {
          throw Exception('Invalid factorial input');
        }
        int n = node.toInt();
        double fact = 1;
        for (int i = 2; i <= n; i++) {
          fact *= i;
        }
        node = fact;
      } else if (op == '%') {
        node /= 100.0;
      }
    }
    return node;
  }

  double parsePrimary() {
    if (current == null) {
      throw Exception('Unexpected end of expression');
    }

    Token t = current!;

    if (t.type == TokenType.number) {
      consume();
      return double.parse(t.value);
    }

    if (t.value == '(') {
      consume();
      double node = parseExpression();
      if (current == null || current!.value != ')') {
        throw Exception('Missing closing parenthesis');
      }
      consume();
      return node;
    }

    throw Exception('Unexpected token: ${t.value}');
  }
}
