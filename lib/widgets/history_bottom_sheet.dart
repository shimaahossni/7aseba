// widgets/history_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../models/calculator_history.dart';

class HistoryBottomSheet extends StatelessWidget {
  final List<CalculatorHistory> history;
  final VoidCallback onClearHistory;
  final Function(String) onSelectHistoryItem;

  const HistoryBottomSheet({
    super.key,
    required this.history,
    required this.onClearHistory,
    required this.onSelectHistoryItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Calculation History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (history.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      onClearHistory();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                    label: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          // History items list
          Flexible(
            child: history.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: 48,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No calculations yet',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    padding: const EdgeInsets.only(bottom: 24.0),
                    itemBuilder: (context, index) {
                      final item = history[history.length - 1 - index]; // Newest first
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                        title: Text(
                          item.expression,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '= ${item.result}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.cyan.shade300 : Colors.teal.shade800,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        onTap: () {
                          onSelectHistoryItem(item.result);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
