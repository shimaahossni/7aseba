class CalculatorHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  const CalculatorHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });
}
