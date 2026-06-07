// widgets/display_panel.dart
import 'package:flutter/material.dart';

class DisplayPanel extends StatefulWidget {
  final String equation;
  final String input;

  const DisplayPanel({
    super.key,
    required this.equation,
    required this.input,
  });

  @override
  State<DisplayPanel> createState() => _DisplayPanelState();
}

class _DisplayPanelState extends State<DisplayPanel> {
  final ScrollController _inputScrollController = ScrollController();
  final ScrollController _equationScrollController = ScrollController();

  @override
  void didUpdateWidget(covariant DisplayPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto scroll to the end when text updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inputScrollController.hasClients) {
        _inputScrollController.animateTo(
          _inputScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
      if (_equationScrollController.hasClients) {
        _equationScrollController.animateTo(
          _equationScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputScrollController.dispose();
    _equationScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Equation/History Display
          SingleChildScrollView(
            controller: _equationScrollController,
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.equation.isEmpty ? ' ' : widget.equation,
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                letterSpacing: 1.2,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8.0),
          // Active Input Display
          SingleChildScrollView(
            controller: _inputScrollController,
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.input.isEmpty ? '0' : widget.input,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
