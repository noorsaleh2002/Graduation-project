// ignore_for_file: file_names, library_private_types_in_public_api, unused_field, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/pdf-controller.dart';
import '../../utils/App_constant.dart';

class FilePage extends StatefulWidget {
  final String fileUrl;
  final String title;
  final String fileid;

  const FilePage({
    super.key,
    required this.fileUrl,
    required this.title,
    required this.fileid,
  });

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final PdfController pdfController = Get.put(PdfController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bookmarkController = TextEditingController();
  bool _isSearching = false;
  late PdfViewerController _pdfViewerController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _bookmarks = [];
  bool _isLoadingBookmarks = true;
  int _currentSearchIndex = 0;
  late PdfTextSearchResult _searchResult;

  @override
  void initState() {
    super.initState();
    _isLoadingBookmarks = true; // Start in loading state
    _pdfViewerController = PdfViewerController();
    _loadBookmarks();
    _searchResult =
        _pdfViewerController.searchText(""); // Initialize with empty search
  }

  void _zoomIn() {
    _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
  }

  void _zoomOut() {
    if (_pdfViewerController.zoomLevel > 1.0) {
      _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
    }
  }

  void _nextSearchResult() {
    if (_searchResult.hasResult) {
      _searchResult.nextInstance();
    }
  }

  void _previousSearchResult() {
    if (_searchResult.hasResult) {
      _searchResult.previousInstance();
    }
  }

  // Load bookmarks from the new path
  Future<void> _loadBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isLoadingBookmarks = true);

    try {
      final doc = await _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('Bookmarks')
          .doc(widget.fileid)
          .get();

      setState(() {
        _bookmarks = List<String>.from(doc.data()?['bookmarks'] ?? []);
        _isLoadingBookmarks = false;
      });
    } catch (e) {
      setState(() => _isLoadingBookmarks = false);
      Get.snackbar('Error', 'Failed to load bookmarks');
    }
  }

// Add bookmark to the new structure
  Future<void> _addBookmark() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final bookmarkName = _bookmarkController.text.trim();
    if (bookmarkName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please Enter your Bookmark!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppConstant.appMainColor,
        ),
      );
      return;
    }

    final fullBookmark =
        '$bookmarkName (Page ${_pdfViewerController.pageNumber})';

    try {
      await _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('Bookmarks')
          .doc(widget.fileid)
          .set({
        'bookmarks': FieldValue.arrayUnion([fullBookmark]),
        'lastUpdated': FieldValue.serverTimestamp(),
        'linkedFileId': widget.fileid, // Reference to the original file
        'fileUrl': widget.fileUrl,
      }, SetOptions(merge: true));

      setState(() => _bookmarks.add(fullBookmark));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Success add Bookmark',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppConstant.appMainColor,
        ),
      );
      _bookmarkController.clear();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add bookmark');
    }
  }

  Future<void> _deleteBookmark(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Reference to the user's bookmark document (new structure)
      await _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('Bookmarks')
          .doc(widget.fileid)
          .update({
        'bookmarks': FieldValue.arrayRemove([_bookmarks[index]]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Update local state
      setState(() => _bookmarks.removeAt(index));
      Get.snackbar('Success', 'Bookmark removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove bookmark: ${e.toString()}');
    }
  }

  // UI Components
  void _showAddBookmarkDialog() {
    Get.dialog(AlertDialog(
      title: Text(
        'Add Bookmark',
        style: TextStyle(color: AppConstant.appMainColor),
      ),
      content: TextField(
        controller: _bookmarkController,
        decoration: InputDecoration(
          hintText: 'Enter bookmark name',
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppConstant.appMainColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstant.appMainColor,
          ),
          onPressed: _addBookmark,
          child: Text(
            'Save',
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
      ],
    ));
  }

  void _navigateToBookmark(String bookmark) {
    // Extract page number from bookmark string (format: "name (Page X)")
    final pageMatch = RegExp(r'\(Page (\d+)\)').firstMatch(bookmark);
    if (pageMatch != null) {
      final pageString = pageMatch.group(1) ?? '1';
      final pageNumber = int.tryParse(pageString) ?? 1;
      _pdfViewerController.jumpToPage(pageNumber);
    }
  }

  Future<void> _initializeDocumentWithBookmark(String bookmark) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Reference to the new Bookmarks collection
      final bookmarkRef = _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('Bookmarks')
          .doc(widget.fileid);

      // Initialize bookmark document (separate from Files)
      await bookmarkRef.set({
        'bookmarks': [bookmark],
        'lastUpdated': FieldValue.serverTimestamp(),
        'linkedFileId': widget.fileid, // Reference to original file
        'fileTitle': widget.title, // Cache title for quick access
        'fileUrl': widget.fileUrl, // Cache URL for quick access
      });

      setState(() {
        _bookmarks.add(bookmark);
        _bookmarkController.clear();
      });

      Get.back();
      Get.snackbar('Success', 'Bookmark initialized in new collection');
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize bookmark: ${e.toString()}');
      debugPrint("Initialization Error: $e");
    }
  }

  // New helper method to build bookmark lists
  Widget _buildBookmarksList() {
    return _bookmarks.isEmpty
        ? Center(child: Text('No bookmarks found'))
        : ListView.builder(
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(_bookmarks[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: AppConstant.appMainColor),
                onPressed: () => _deleteBookmark(index),
              ),
              onTap: () {
                _navigateToBookmark(_bookmarks[index]);
                Get.back();
              },
            ),
          );
  }

  void _showBookmarksDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Bookmarks',
            style: TextStyle(color: AppConstant.appMainColor)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button to open Syncfusion's native bookmark panel
              ElevatedButton(
                onPressed: () {
                  pdfController.pdfViewerKey.currentState?.openBookmarkView();
                  Get.back();
                },
                child: Text('Show PDF Document Bookmarks'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  foregroundColor: AppConstant.appTextColor,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              // Your custom bookmarks
              Text("Your Saved Bookmarks",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appMainColor)),
              Expanded(
                child: _bookmarks.isEmpty
                    ? Center(
                        child: Text(
                        "No bookmarks added yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ))
                    : _buildBookmarksList(),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.appMainColor,
            ),
            onPressed: _showAddBookmarkDialog,
            child: Text('Add Bookmark',
                style: TextStyle(color: AppConstant.appTextColor)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close',
                style: TextStyle(color: AppConstant.appMainColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: _isSearching
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: AppConstant.appTextColor),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: AppConstant.appTextColor),
                        onSubmitted: (query) {
                          setState(() {
                            _searchResult =
                                _pdfViewerController.searchText(query);
                          });
                        }),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_upward,
                        color: AppConstant.appTextColor),
                    onPressed: _previousSearchResult,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward,
                        color: AppConstant.appTextColor),
                    onPressed: _nextSearchResult,
                  ),
                ],
              )
            : Text(widget.title,
                style: TextStyle(color: AppConstant.appTextColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: AppConstant.appTextColor),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppConstant.appMainColor.withOpacity(0.7),
            heroTag: 'add_bookmark',
            onPressed: _showAddBookmarkDialog,
            child: Icon(
              Icons.bookmark_add,
            ),
            mini: true,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: AppConstant.appMainColor.withOpacity(0.7),
            heroTag: 'view_bookmarks',
            onPressed: _showBookmarksDialog,
            child: Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_upward, color: AppConstant.appMainColor),
                onPressed: _pdfViewerController.previousPage,
              ),
              IconButton(
                icon:
                    Icon(Icons.arrow_downward, color: AppConstant.appMainColor),
                onPressed: _pdfViewerController.nextPage,
              ),
              IconButton(
                icon: Icon(Icons.zoom_in, color: AppConstant.appMainColor),
                onPressed: _zoomIn,
              ),
              IconButton(
                icon: Icon(Icons.zoom_out, color: AppConstant.appMainColor),
                onPressed: _zoomOut,
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
