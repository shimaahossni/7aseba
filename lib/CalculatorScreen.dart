// CalculatorScreen.dart
import 'package:flutter/material.dart';
import 'main.dart'; // To access MyApp.themeNotifier
import 'models/calculator_history.dart';
import 'utils/calculator_engine.dart';
import 'widgets/calculator_button.dart';
import 'widgets/display_panel.dart';
import 'widgets/history_bottom_sheet.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _activeInput = '';
  String _savedNumber = '';
  String _savedOperator = '';
  String _expression = '';
  bool _shouldResetInputOnNextDigit = false;
  final List<CalculatorHistory> _history = [];

  void _onDigitClick(String digit) {
    setState(() {
      if (_shouldResetInputOnNextDigit || _activeInput == 'Error' || _activeInput.contains('Error')) {
        _activeInput = digit == '.' ? '0.' : digit;
        _shouldResetInputOnNextDigit = false;
      } else {
        if (digit == '.') {
          if (_activeInput.contains('.')) return;
          if (_activeInput.isEmpty) {
            _activeInput = '0.';
          } else {
            _activeInput += '.';
          }
        } else {
          if (_activeInput == '0') {
            _activeInput = digit;
          } else {
            _activeInput += digit;
          }
        }
      }
    });
  }

  void _onOperatorClick(String op) {
    setState(() {
      if (_activeInput.contains('Error')) return;

      if (_activeInput.isEmpty) {
        if (_savedNumber.isNotEmpty) {
          _savedOperator = op;
          _expression = '$_savedNumber $_savedOperator';
        }
        return;
      }

      if (_savedNumber.isEmpty) {
        _savedNumber = _activeInput;
        _savedOperator = op;
        _expression = '$_savedNumber $_savedOperator';
        _activeInput = '';
      } else {
        final result = CalculatorEngine.calculate(_savedNumber, _savedOperator, _activeInput);
        if (result.startsWith('Error')) {
          _activeInput = result;
          _savedNumber = '';
          _savedOperator = '';
          _expression = '';
          _shouldResetInputOnNextDigit = true;
        } else {
          _savedNumber = result;
          _savedOperator = op;
          _expression = '$_savedNumber $_savedOperator';
          _activeInput = '';
        }
      }
    });
  }

  void _onEqualClick() {
    setState(() {
      if (_savedNumber.isEmpty || _savedOperator.isEmpty) return;

      final rhs = _activeInput.isEmpty ? _savedNumber : _activeInput;
      final result = CalculatorEngine.calculate(_savedNumber, _savedOperator, rhs);

      if (!result.startsWith('Error')) {
        _history.add(CalculatorHistory(
          expression: '$_savedNumber $_savedOperator $rhs',
          result: result,
          timestamp: DateTime.now(),
        ));
      }

      _expression = '$_savedNumber $_savedOperator $rhs =';
      _activeInput = result;
      _savedNumber = '';
      _savedOperator = '';
      _shouldResetInputOnNextDigit = true;
    });
  }

  void _onAcClick() {
    setState(() {
      _activeInput = '';
      _savedNumber = '';
      _savedOperator = '';
      _expression = '';
      _shouldResetInputOnNextDigit = false;
    });
  }

  void _onBackspaceClick() {
    setState(() {
      if (_activeInput.contains('Error')) {
        _activeInput = '';
        return;
      }
      if (_activeInput.isNotEmpty) {
        _activeInput = _activeInput.substring(0, _activeInput.length - 1);
        if (_activeInput == '-') {
          _activeInput = '';
        }
      }
    });
  }

  void _onUnaryClick(String operation) {
    setState(() {
      final target = _activeInput.isNotEmpty 
          ? _activeInput 
          : (_savedNumber.isNotEmpty ? _savedNumber : '0');
      
      if (target.contains('Error')) return;

      if (operation == '+/-') {
        final result = CalculatorEngine.toggleSign(target);
        if (_activeInput.isNotEmpty) {
          _activeInput = result;
        } else if (_savedNumber.isNotEmpty) {
          _savedNumber = result;
          _expression = '$_savedNumber $_savedOperator';
        }
      } else if (operation == '%') {
        final result = CalculatorEngine.percentage(target);
        if (_activeInput.isNotEmpty) {
          _activeInput = result;
        } else {
          _activeInput = result;
          _shouldResetInputOnNextDigit = true;
        }
      } else if (operation == '^2') {
        final result = CalculatorEngine.square(target);
        _expression = '($target)² =';
        _activeInput = result;
        _savedNumber = '';
        _savedOperator = '';
        _shouldResetInputOnNextDigit = true;
      } else if (operation == 'sqrt') {
        final result = CalculatorEngine.sqrt(target);
        _expression = '√($target) =';
        _activeInput = result;
        _savedNumber = '';
        _savedOperator = '';
        _shouldResetInputOnNextDigit = true;
      }
    });
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) => HistoryBottomSheet(
        history: _history,
        onClearHistory: () {
          setState(() {
            _history.clear();
          });
        },
        onSelectHistoryItem: (result) {
          setState(() {
            _activeInput = result;
            _shouldResetInputOnNextDigit = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          'Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              MyApp.themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: Icon(
              Icons.history_outlined,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
            tooltip: 'History',
            onPressed: _showHistory,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display Panel (Formula and current input)
            Expanded(
              flex: 2,
              child: DisplayPanel(
                equation: _expression,
                input: _activeInput,
              ),
            ),
            
            // Buttons Grid Panel
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
                ),
                child: Column(
                  children: [
                    // Row 1: x², √, +/-, %
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(
                            text: 'x²',
                            onTap: () => _onUnaryClick('^2'),
                            type: CalculatorButtonType.utility,
                          ),
                          CalculatorButton(
                            text: '√',
                            onTap: () => _onUnaryClick('sqrt'),
                            type: CalculatorButtonType.utility,
                          ),
                          CalculatorButton(
                            text: '+/-',
                            onTap: () => _onUnaryClick('+/-'),
                            type: CalculatorButtonType.utility,
                          ),
                          CalculatorButton(
                            text: '%',
                            onTap: () => _onUnaryClick('%'),
                            type: CalculatorButtonType.utility,
                          ),
                        ],
                      ),
                    ),
                    // Row 2: AC, ⌫, ÷
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(
                            text: 'AC',
                            onTap: _onAcClick,
                            type: CalculatorButtonType.utility,
                            flex: 2,
                          ),
                          CalculatorButton(
                            text: '⌫',
                            icon: Icon(
                              Icons.backspace_outlined,
                              color: isDark ? Colors.cyan.shade300 : Colors.teal.shade800,
                            ),
                            onTap: _onBackspaceClick,
                            type: CalculatorButtonType.utility,
                          ),
                          CalculatorButton(
                            text: '÷',
                            onTap: () => _onOperatorClick('÷'),
                            type: CalculatorButtonType.operator,
                          ),
                        ],
                      ),
                    ),
                    // Row 3: 7, 8, 9, ×
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(text: '7', onTap: () => _onDigitClick('7')),
                          CalculatorButton(text: '8', onTap: () => _onDigitClick('8')),
                          CalculatorButton(text: '9', onTap: () => _onDigitClick('9')),
                          CalculatorButton(
                            text: '×',
                            onTap: () => _onOperatorClick('×'),
                            type: CalculatorButtonType.operator,
                          ),
                        ],
                      ),
                    ),
                    // Row 4: 4, 5, 6, -
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(text: '4', onTap: () => _onDigitClick('4')),
                          CalculatorButton(text: '5', onTap: () => _onDigitClick('5')),
                          CalculatorButton(text: '6', onTap: () => _onDigitClick('6')),
                          CalculatorButton(
                            text: '-',
                            onTap: () => _onOperatorClick('-'),
                            type: CalculatorButtonType.operator,
                          ),
                        ],
                      ),
                    ),
                    // Row 5: 1, 2, 3, +
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(text: '1', onTap: () => _onDigitClick('1')),
                          CalculatorButton(text: '2', onTap: () => _onDigitClick('2')),
                          CalculatorButton(text: '3', onTap: () => _onDigitClick('3')),
                          CalculatorButton(
                            text: '+',
                            onTap: () => _onOperatorClick('+'),
                            type: CalculatorButtonType.operator,
                          ),
                        ],
                      ),
                    ),
                    // Row 6: 0, ., =
                    Expanded(
                      child: Row(
                        children: [
                          CalculatorButton(
                            text: '0',
                            onTap: () => _onDigitClick('0'),
                            flex: 2,
                          ),
                          CalculatorButton(text: '.', onTap: () => _onDigitClick('.')),
                          CalculatorButton(
                            text: '=',
                            onTap: _onEqualClick,
                            type: CalculatorButtonType.equals,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
