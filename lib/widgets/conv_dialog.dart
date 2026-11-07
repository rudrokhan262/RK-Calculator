import 'package:flutter/material.dart';
import '../utils/advanced_math.dart';

class ConvDialog extends StatefulWidget {
  const ConvDialog({super.key});

  @override
  State<ConvDialog> createState() => _ConvDialogState();
}

class _ConvDialogState extends State<ConvDialog> {
  String category = 'Length';
  String fromUnit = 'Meters';
  String toUnit = 'Kilometers';
  final TextEditingController _valueController = TextEditingController(text: '1000');
  double output = 1.0;

  @override
  void initState() {
    super.initState();
    _convert();
  }

  void _convert() {
    try {
      double val = double.tryParse(_valueController.text) ?? 0.0;
      setState(() {
        output = UnitConverter.convert(category, fromUnit, toUnit, val);
      });
    } catch (_) {
      setState(() {
        output = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = UnitConverter.categories.keys.toList();
    List<String> units = UnitConverter.categories[category]!.keys.toList();

    return AlertDialog(
      title: const Text('Scientific Unit Converter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: category,
                isDense: true,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) {
                  setState(() {
                    category = val!;
                    fromUnit = UnitConverter.categories[category]!.keys.first;
                    toUnit = UnitConverter.categories[category]!.keys.last;
                    _convert();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder()),
            onChanged: (_) => _convert(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: fromUnit,
                      isDense: true,
                      items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) {
                        setState(() {
                          fromUnit = val!;
                          _convert();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: toUnit,
                      isDense: true,
                      items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) {
                        setState(() {
                          toUnit = val!;
                          _convert();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Result: ${output.toStringAsFixed(6)} $toUnit',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }
}
