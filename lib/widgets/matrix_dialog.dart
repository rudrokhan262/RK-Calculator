import 'package:flutter/material.dart';
import '../utils/advanced_math.dart';

class MatrixDialog extends StatefulWidget {
  const MatrixDialog({super.key});

  @override
  State<MatrixDialog> createState() => _MatrixDialogState();
}

class _MatrixDialogState extends State<MatrixDialog> {
  int size = 2;
  final TextEditingController _m1Controller = TextEditingController(text: '1,2,3,4');
  final TextEditingController _m2Controller = TextEditingController(text: '5,6,7,8');
  String _output = '';

  Matrix _parseMatrix(String text, int dim) {
    List<double> nums = text.split(',').map((e) => double.tryParse(e.trim()) ?? 0.0).toList();
    if (nums.length < dim * dim) {
      nums.addAll(List.filled(dim * dim - nums.length, 0.0));
    }
    List<List<double>> rows = [];
    for (int i = 0; i < dim; i++) {
      rows.add(nums.sublist(i * dim, (i + 1) * dim));
    }
    return Matrix(rows);
  }

  void _calculate(String op) {
    try {
      Matrix a = _parseMatrix(_m1Controller.text, size);
      Matrix? b = size == 2 || size == 3 ? _parseMatrix(_m2Controller.text, size) : null;

      Matrix res;
      String resultText = '';

      switch (op) {
        case '+':
          res = a + b!;
          resultText = _formatMatrix(res);
          break;
        case '-':
          res = a - b!;
          resultText = _formatMatrix(res);
          break;
        case '×':
          res = a * b!;
          resultText = _formatMatrix(res);
          break;
        case 'Det(A)':
          double det = a.determinant;
          resultText = 'Det(A) = $det';
          break;
        case 'Inv(A)':
          res = a.inverse;
          resultText = _formatMatrix(res);
          break;
        case 'Transpose(A)':
          res = a.transpose;
          resultText = _formatMatrix(res);
          break;
      }
      setState(() {
        _output = resultText;
      });
    } catch (e) {
      setState(() {
        _output = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  String _formatMatrix(Matrix m) {
    return m.data.map((row) => row.map((v) => v.toStringAsFixed(2)).join('\t')).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Matrix Calculator'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Dimension: '),
                ChoiceChip(
                  label: const Text('2×2'),
                  selected: size == 2,
                  onSelected: (val) {
                    setState(() {
                      size = 2;
                      _m1Controller.text = '1,2,3,4';
                      _m2Controller.text = '5,6,7,8';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('3×3'),
                  selected: size == 3,
                  onSelected: (val) {
                    setState(() {
                      size = 3;
                      _m1Controller.text = '1,2,3,4,5,6,7,8,9';
                      _m2Controller.text = '9,8,7,6,5,4,3,2,1';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _m1Controller,
              decoration: const InputDecoration(labelText: 'Matrix A (comma separated)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _m2Controller,
              decoration: const InputDecoration(labelText: 'Matrix B (comma separated)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: () => _calculate('+'), child: const Text('A + B')),
                ElevatedButton(onPressed: () => _calculate('-'), child: const Text('A - B')),
                ElevatedButton(onPressed: () => _calculate('×'), child: const Text('A × B')),
                ElevatedButton(onPressed: () => _calculate('Det(A)'), child: const Text('Det(A)')),
                ElevatedButton(onPressed: () => _calculate('Inv(A)'), child: const Text('Inv(A)')),
                ElevatedButton(onPressed: () => _calculate('Transpose(A)'), child: const Text('Transpose')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8)),
              child: Text(_output, style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }
}
