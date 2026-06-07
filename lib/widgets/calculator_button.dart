import 'package:flutter/material.dart';

enum CalculatorButtonType {
  digit,
  operator,
  utility,
  equals,
}

class CalculatorButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;
  final CalculatorButtonType type;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
    this.type = CalculatorButtonType.digit,
    this.icon,
    this.flex = 1,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.92;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;

    switch (widget.type) {
      case CalculatorButtonType.operator:
        backgroundColor = isDark ? Colors.orange.shade800 : Colors.orange.shade700;
        textColor = Colors.white;
        break;
      case CalculatorButtonType.equals:
        backgroundColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.onPrimary;
        break;
      case CalculatorButtonType.utility:
        backgroundColor = isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade50;
        textColor = isDark ? Colors.cyan.shade300 : Colors.teal.shade800;
        break;
      case CalculatorButtonType.digit:
      default:
        backgroundColor = isDark ? Colors.grey.shade900 : Colors.white;
        textColor = isDark ? Colors.grey.shade100 : Colors.grey.shade800;
        break;
    }

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOutCubic,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.25) : Colors.grey.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: widget.icon ??
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
