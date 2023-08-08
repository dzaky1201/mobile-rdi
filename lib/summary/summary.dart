import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}

