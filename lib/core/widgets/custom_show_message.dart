import 'package:flutter/material.dart';

void customSnackBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.blue,
      content: Text(text, style: TextStyle(color: Colors.white)),
    ),
  );
}
