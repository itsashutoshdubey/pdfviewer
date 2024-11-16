import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PDFViewer extends StatefulWidget {
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PdfController? _pdfController;
  Uint8List? _pdfBytes;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      if (_pdfController != null) {
        _pdfController!.dispose();
      }

      setState(() {
        if (kIsWeb) {
          _pdfBytes = result.files.first.bytes;
          _pdfController = PdfController(
            document: PdfDocument.openData(_pdfBytes!),
          );
          print('PDF loaded from bytes.');
        } else {
          String filePath = result.files.first.path!;
          _pdfController = PdfController(
            document: PdfDocument.openFile(filePath),
          );
          print('PDF loaded from file path.');
        }
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: _pickFile,
          ),
        ],
      ),
      body: _pdfController == null
          ? Center(child: Text('Select a PDF file to view'))
          : PdfView(
        controller: _pdfController!,
        onDocumentLoaded: (document) {
          print('Document loaded with ${document.pagesCount} pages.');
        },
        onDocumentError: (error) {
          print('Error loading document: $error');
        },
      ),
    );
  }
}







