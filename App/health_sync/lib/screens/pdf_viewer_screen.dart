import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PDFViewerScreen({super.key, required this.pdfPath});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int totalPages = 0;
  int currentPage = 0;
  late PDFViewController pdfController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Prescription")),
      body: PDFView(
        filePath: widget.pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        onRender: (pages) => setState(() => totalPages = pages ?? 0),
        onViewCreated: (PDFViewController controller) {
          pdfController = controller;
        },
        onPageChanged: (page, _) => setState(() => currentPage = page ?? 0),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: "prev",
            onPressed: () async {
              if (currentPage > 0) {
                await pdfController.setPage(currentPage - 1);
              }
            },
            child: Icon(Icons.arrow_back),
          ),
          FloatingActionButton(
            heroTag: "next",
            onPressed: () async {
              if (currentPage < totalPages - 1) {
                await pdfController.setPage(currentPage + 1);
              }
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
