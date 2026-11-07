import 'package:flutter/material.dart';
import '../utils/advanced_math.dart';

class StatDialog extends StatefulWidget {
  const StatDialog({super.key});

  @override
  State<StatDialog> createState() => _StatDialogState();
}

class _StatDialogState extends State<StatDialog> {
  final TextEditingController _controller = TextEditingController(text: '10, 20, 30, 40, 50');
  Map<String, double> _stats = {};
  String _error = '';

  void _compute() {
    try {
      List<double> data = _controller.text
          .split(',')
          .map((e) => double.parse(e.trim()))
          .toList();
      setState(() {
        _stats = StatCalculator.calculate(data);
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = 'Invalid dataset input';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _compute();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Statistical Calculator (STAT)'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Data (comma separated)', border: OutlineInputBorder()),
              onChanged: (_) => _compute(),
            ),
            const SizedBox(height: 12),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red))
            else ...[
              _row('n (Count)', _stats['n']),
              _row('Σx (Sum)', _stats['sumX']),
              _row('Σx²', _stats['sumX2']),
              _row('Mean (x̄)', _stats['mean']),
              _row('Median', _stats['median']),
              _row('Mode', _stats['mode']),
              _row('Sample Variance (s²)', _stats['sampleVar']),
              _row('Sample Std Dev (s)', _stats['sampleStdDev']),
              _row('Population Std Dev (σ)', _stats['popStdDev']),
              _row('Min', _stats['min']),
              _row('Max', _stats['max']),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }

  Widget _row(String label, double? val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(val?.toStringAsFixed(4) ?? '-', style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
