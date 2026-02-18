import 'package:flutter/material.dart';

class DataCardWidget extends StatelessWidget {
  final String title;
  final String value;

  DataCardWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}