import 'package:flutter/material.dart';

class Bmiview extends StatefulWidget {
  const Bmiview({super.key});

  @override
  State<Bmiview> createState() => _BmiviewState();
}

class _BmiviewState extends State<Bmiview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")),
      body: Center(child: Text("BMI Calculator")),
    );
  }
}
