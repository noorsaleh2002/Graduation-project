// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../controllers/pdf-controller.dart';
import '../../utils/App_constant.dart';

class FilePage extends StatefulWidget {
  final String fileUrl;
  const FilePage({super.key, required this.fileUrl});

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    PdfController pdfController = Get.put(PdfController());

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: AppConstant.appTextColor),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: AppConstant.appTextColor),
                onSubmitted: (query) {
                  // Perform search in PDF
                  _pdfViewerController.searchText(query);
                },
              )
            : Text(
                'File Title',
                style: TextStyle(
                  color: AppConstant.appTextColor,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppConstant.appTextColor,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _pdfViewerController.clearSelection();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pdfController.pdfViewerKey.currentState?.openBookmarkView();
        },
        child: Icon(Icons.bookmark),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_upward, color: AppConstant.appMainColor),
                onPressed: () {
                  _pdfViewerController.previousPage();
                },
              ),
              IconButton(
                icon:
                    Icon(Icons.arrow_downward, color: AppConstant.appMainColor),
                onPressed: () {
                  _pdfViewerController.nextPage();
                },
              ),
            ],
          ),
          Expanded(
            child: SfPdfViewer.network(
              widget.fileUrl,
              controller: _pdfViewerController,
              key: pdfController.pdfViewerKey,
            ),
          ),
        ],
      ),
    );
  }
}
