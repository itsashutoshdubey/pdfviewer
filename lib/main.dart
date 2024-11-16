import 'package:flutter/material.dart';
import 'pdf_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PDFViewer(),
    );
  }
}

