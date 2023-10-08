import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFApp extends StatelessWidget {
  const PDFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Generator"),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format, "Printing Demo", context),
        actions: [
          PdfPreviewAction(
              icon: const Icon(Icons.print),
              onPressed: (context, fn, format) {
                _printPdf("Printing Demo", context);
              }),
        ],
        allowPrinting: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        allowSharing: false,
        canDebug: false,
      ),
    );
  }

  Future<void> _printPdf(String title, context) async {
    final pdf = await _generatePdf(PdfPageFormat.a4, title, context);
    Printing.layoutPdf(onLayout: (format) async => pdf);
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: false);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    // Define a variable to store the text entered into the TextField
    String textFieldText = "";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Text'),
          content: TextField(
            onChanged: (text) {
              // Update the textFieldText variable as the user types
              textFieldText = text;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
    // Text Entered in TextField
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(textFieldText),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
