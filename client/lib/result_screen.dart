import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int result;

  ResultScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Response'),
      ),
      body: Center(
        child: Text('Returned Number: $result', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
