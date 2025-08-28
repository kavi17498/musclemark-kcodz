import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Bmiview extends StatefulWidget {
  const Bmiview({super.key});

  @override
  State<Bmiview> createState() => _BmiviewState();
}

class _BmiviewState extends State<Bmiview> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmi;

  num calculateBmi() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    if (height > 0) {
      setState(() {
        _bmi = (weight / (height * height)) as double?;
      });
      return _bmi ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: "Enter Height",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: "Enter Weight",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateBmi,
              child: Text("Calculate BMI"),
            ),

            Text(
              _bmi == null
                  ? "Your BMI is: "
                  : "Your BMI is: ${_bmi!.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
