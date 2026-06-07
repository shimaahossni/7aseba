import 'dart:math' as math;

class CalculatorEngine {
  /// Evaluates arithmetic operation between two numbers.
  /// Supported operators: '+', '-', '×', '÷'
  static String calculate(String lhs, String op, String rhs) {
    if (op.isEmpty) return rhs.isNotEmpty ? rhs : lhs;

    final n1 = double.tryParse(lhs) ?? 0.0;
    final n2 = double.tryParse(rhs) ?? 0.0;

    double result = 0.0;

    switch (op) {
      case '+':
        result = n1 + n2;
        break;
      case '-':
        result = n1 - n2;
        break;
      case '*':
      case '×':
        result = n1 * n2;
        break;
      case '/':
      case '÷':
        if (n2 == 0) {
          return 'Error: Div by 0';
        }
        result = n1 / n2;
        break;
      default:
        return rhs;
    }

    return formatNumber(result);
  }

  /// Formats the double value to a readable string:
  /// - Removes trailing decimal '.0' if it is an integer.
  /// - Restricts long floating points to 10 decimal digits.
  /// - Handles scientific notation for extremely large or small numbers.
  static String formatNumber(double value) {
    if (value.isNaN) return 'Error';
    if (value.isInfinite) return 'Error';

    // If it's an integer, return without decimals
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    // Convert to string and limit to maximum 10 decimal digits
    String str = value.toString();
    
    // Check if it is scientific notation
    if (str.contains('e') || str.contains('E')) {
      if (str.length > 15) {
        return value.toStringAsExponential(8);
      }
      return str;
    }

    // Limit to 10 decimal places to prevent display overflow
    final parts = str.split('.');
    if (parts.length == 2 && parts[1].length > 10) {
      str = value.toStringAsFixed(10);
      // Clean up any trailing zeros from fixed formatting
      while (str.endsWith('0')) {
        str = str.substring(0, str.length - 1);
      }
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
    }

    return str;
  }

  /// Calculates square power of a number.
  static String square(String input) {
    final val = double.tryParse(input);
    if (val == null) return 'Error';
    return formatNumber(math.pow(val, 2).toDouble());
  }

  /// Calculates square root of a number.
  static String sqrt(String input) {
    final val = double.tryParse(input);
    if (val == null) return 'Error';
    if (val < 0) return 'Error: Invalid Input';
    return formatNumber(math.sqrt(val));
  }

  /// Negates the sign of a number (positive/negative toggle).
  static String toggleSign(String input) {
    if (input.isEmpty || input == '0' || input == 'Error') return input;
    if (input.startsWith('-')) {
      return input.substring(1);
    } else {
      return '-$input';
    }
  }

  /// Calculates percentage (value / 100).
  static String percentage(String input) {
    final val = double.tryParse(input);
    if (val == null) return 'Error';
    return formatNumber(val / 100.0);
  }
}
