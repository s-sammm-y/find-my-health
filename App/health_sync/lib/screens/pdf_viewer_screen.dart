import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatefulWidget {
  final List<String> pdfPaths;
  final int initialIndex;

  const PDFViewerScreen({super.key, required this.pdfPaths, required this.initialIndex});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int totalPages = 0;
  int currentPage = 0;
  int currentPdfIndex = 0;
  late PDFViewController pdfController;

  @override
  void initState() {
    super.initState();
    currentPdfIndex = widget.initialIndex; 
  }

  void showNextPdf() {
    if (currentPdfIndex < widget.pdfPaths.length - 1) {
      setState(() {
        currentPdfIndex++;
      });
    }
  }

  void showPreviousPdf() {
    if (currentPdfIndex > 0) {
      setState(() {
        currentPdfIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prescription ${currentPdfIndex + 1} / ${widget.pdfPaths.length}")),
      body: Builder(
        key: ValueKey(currentPdfIndex), 
        builder: (context) {
          return PDFView(
            filePath: widget.pdfPaths[currentPdfIndex],
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            onRender: (pages) => setState(() => totalPages = pages ?? 0),
            onViewCreated: (controller) {
              setState(() {
                pdfController = controller;
              });
            },
            onPageChanged: (page, _) => setState(() => currentPage = page ?? 0),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: "prev_pdf",
            onPressed: currentPdfIndex > 0 ? showPreviousPdf : null,
            backgroundColor: currentPdfIndex > 0 ? Colors.blue : Colors.grey,
            child: Icon(Icons.chevron_left),
          ),
          FloatingActionButton(
            heroTag: "next_pdf",
            onPressed: currentPdfIndex < widget.pdfPaths.length - 1 ? showNextPdf : null,
            backgroundColor: currentPdfIndex < widget.pdfPaths.length - 1 ? Colors.blue : Colors.grey,
            child: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}