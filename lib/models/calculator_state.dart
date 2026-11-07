import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../utils/calculator_evaluator.dart';

class CalculatorState extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  bool _isDarkMode = true;
  AngleMode _angleMode = AngleMode.deg;
  bool _hapticEnabled = true;
  bool _evaluated = false;

  String get expression => _expression;
  String get result => _result;
  bool get isDarkMode => _isDarkMode;
  AngleMode get angleMode => _angleMode;
  bool get hapticEnabled => _hapticEnabled;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleAngleMode() {
    _angleMode = _angleMode == AngleMode.deg ? AngleMode.rad : AngleMode.deg;
    _triggerHaptic();
    _recalculatePreview();
    notifyListeners();
  }

  void toggleHaptic() {
    _hapticEnabled = !_hapticEnabled;
    notifyListeners();
  }

  void _triggerHaptic() {
    if (_hapticEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void memoryClear() {
    _triggerHaptic();
    CalculatorEvaluator.memory = 0.0;
  }

  void memoryRecall() {
    _triggerHaptic();
    _expression += 'MR';
    _recalculatePreview();
    notifyListeners();
  }

  void memoryAdd() {
    _triggerHaptic();
    double val = double.tryParse(_result) ?? 0.0;
    CalculatorEvaluator.memory += val;
  }

  void memorySubtract() {
    _triggerHaptic();
    double val = double.tryParse(_result) ?? 0.0;
    CalculatorEvaluator.memory -= val;
  }

  void onButtonPressed(String value) {
    _triggerHaptic();

    if (_evaluated) {
      if (_isOperator(value) || value == '%' || value == '!') {
        _expression = _result == 'Error' ? '' : _result;
      } else {
        _expression = '';
      }
      _evaluated = false;
    }

    switch (value) {
      case 'AC':
        _expression = '';
        _result = '0';
        _evaluated = false;
        break;
      case 'DEL':
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        break;
      case '=':
        if (_expression.isNotEmpty) {
          _evaluateFinal();
        }
        break;
      case '+/−':
        _toggleSign();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'sinh':
      case 'cosh':
      case 'tanh':
      case 'sin⁻¹':
      case 'cos⁻¹':
      case 'tan⁻¹':
      case 'log':
      case 'ln':
      case 'log₂':
      case '√':
      case '∛':
      case 'abs':
        _expression += '$value(';
        break;
      case 'logₓy':
        _expression += 'logx(';
        break;
      case 'nPr':
        _expression += 'npr(';
        break;
      case 'nCr':
        _expression += 'ncr(';
        break;
      case 'x²':
        _expression += '^2';
        break;
      case 'x³':
        _expression += '^3';
        break;
      case 'x^y':
        _expression += '^';
        break;
      case '10^x':
        _expression += '10^';
        break;
      case '2^x':
        _expression += '2^';
        break;
      case 'e^x':
        _expression += 'e^';
        break;
      case '1/x':
        _expression += '1/(';
        break;
      case 'EXP':
        _expression += 'e+';
        break;
      case 'Rand':
      case 'Ran#':
        _expression += 'rand()';
        break;
      case 'Ans':
        _expression += 'Ans';
        break;
      case 'MC':
        memoryClear();
        break;
      case 'MR':
        memoryRecall();
        break;
      case 'M+':
        memoryAdd();
        break;
      case 'M-':
        memorySubtract();
        break;
      default:
        _expression += value;
        break;
    }

    _recalculatePreview();
    notifyListeners();
  }

  bool _isOperator(String val) {
    return val == '+' || val == '−' || val == '×' || val == '÷' || val == '^' || val == 'mod';
  }

  void _toggleSign() {
    if (_expression.isEmpty) {
      _expression = '-';
    } else if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);
    } else {
      _expression = '-($_expression)';
    }
  }

  void _recalculatePreview() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }

    EvaluationResult eval = CalculatorEvaluator.evaluate(_expression, _angleMode);
    if (eval.hasError) {
      String err = eval.error!;
      if (err.contains('Unexpected end') || err.contains('Expected') || err.contains('Missing')) {
        return;
      }
      _result = err;
    } else {
      _result = _formatResult(eval.value!);
    }
  }

  void _evaluateFinal() {
    EvaluationResult eval = CalculatorEvaluator.evaluate(_expression, _angleMode);
    if (eval.hasError) {
      _result = eval.error!;
    } else {
      _result = _formatResult(eval.value!);
      _expression = _result;
      _evaluated = true;
    }
  }

  String _formatResult(double val) {
    if (val.isInfinite || val.isNaN) {
      return 'Error';
    }
    if (val == val.roundToDouble() && val.abs() < 1e15) {
      return val.toInt().toString();
    }
    String s = val.toStringAsFixed(8);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      if (s.endsWith('.')) {
        s = s.substring(0, s.length - 1);
      }
    }
    return s;
  }
}
