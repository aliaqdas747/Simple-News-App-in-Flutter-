import 'package:filetype/Api_integration/newsApp.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

void main() {
  runApp(const MyApp());
}

// The main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Title of the application
      theme: ThemeData(), // Theme data for the application
      home: Newsapp(), // Home page of the app
    );
  }
}

// Stateful widget for the home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Title passed to the home page

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  static const int initialPage = 1; // Initial page to display
  late PdfControllerPinch pdfController; // Controller for PDF viewing

  @override
  void initState() {
    super.initState();
    // Initialize the PDF controller with the document and initial page
    pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset('assets/pdfs/pizzadeliveryapp.pdf'),
        initialPage: initialPage);
  }

  @override
  void dispose() {
    pdfController.dispose(); // Dispose of the PDF controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey, // Background color of the scaffold
        appBar: AppBar(
          title: Text(widget.title), // Title of the app bar
          actions: [
            // Button to navigate to the previous page
            IconButton(
              onPressed: () {
                pdfController.previousPage(
                    duration: Duration(milliseconds: 100), curve: Curves.ease);
              },
              icon: Icon(Icons.navigate_before),
            ),
            // Display the current page number and total pages
            PdfPageNumber(
                controller: pdfController,
                builder: (_, loadingState, pageNumber, totalPages) => Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    '$pageNumber/${totalPages ?? 0}', // Format: current page/total pages
                    style: TextStyle(fontSize: 22),
                  ),
                )),
            // Button to navigate to the next page
            IconButton(
              onPressed: () {
                pdfController.nextPage(
                    duration: Duration(milliseconds: 100), curve: Curves.ease);
              },
              icon: Icon(Icons.navigate_next),
            ),
            // Button to refresh/load the document again
            IconButton(
              onPressed: () => pdfController.loadDocument(
                PdfDocument.openAsset('assets/pdfs/pizzadeliveryapp.pdf'),
              ),
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        // PDF view widget
        body: PdfViewPinch(
          controller: pdfController, // Controller for the PDF view
          scrollDirection: Axis.vertical, // Scroll direction for the PDF view
          builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(), // Default options for builders
            documentLoaderBuilder: (_) => const Center(
              child: CircularProgressIndicator(), // Loader while the document is loading
            ),
            pageLoaderBuilder: (_) => const Center(
              child: CircularProgressIndicator(), // Loader while a page is loading
            ),
            errorBuilder: (_, error) => Center(
              child: Text(
                error.toString(), // Display error message if loading fails
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ));
  }
}