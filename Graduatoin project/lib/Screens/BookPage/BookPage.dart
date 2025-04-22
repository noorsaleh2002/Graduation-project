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
  // late PdfTextSearchResult _searchResult;
// Add this variable to your state class
  DateTime _lastPageSaveTime = DateTime.now();
  bool _isInitialLoad = true;
  bool _showFabMenu = false;
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  bool _showNotFoundMessage = false;
// Add this variable to track search state
  bool _isSearchingInProgress = false;
  bool _showToolbar = false;
  PdfAnnotationMode _currentMode = PdfAnnotationMode.none;
  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _isLoadingBookmarks = true; // Start in loading state
    _pdfViewerController =
        PdfViewerController(); // Controller initialization happens here
    // Call the listener setup right after initializing the controller
    _setupPageChangeListener();

    // Load both bookmarks and last page
    _initializeReader();
    // _loadBookmarks(); at last page ..
    _searchController.addListener(() {
      if (_searchController.text.isEmpty && _showNotFoundMessage) {
        setState(() {
          _showNotFoundMessage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Save current page when the widget is disposed
    _saveCurrentPageBeforeExit();
    _pdfViewerController.dispose();
    _searchController.dispose();
    _bookmarkController.dispose();
    super.dispose();
  }

  Future<void> _saveCurrentPageBeforeExit() async {
    final currentPage = _pdfViewerController.pageNumber;
    if (currentPage != null) {
      await _saveLastReadPage(currentPage);
    }
  }

  Future<void> _initializeReader() async {
    await _loadBookmarks();

    final lastPage = await _loadLastReadPage();

    if (lastPage != null && mounted && lastPage > 1) {
      // Only jump if not page 1
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pdfViewerController.jumpToPage(lastPage);
        // Set flag to false after jump is complete
        Future.delayed(const Duration(seconds: 2), () {
          _isInitialLoad = false;
        });
      });
    } else {
      _isInitialLoad = false;
    }
    setState(() => _isLoadingBookmarks = false);
  }

  void _searchText(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _showNotFoundMessage = false;
        _isSearchingInProgress = false;
      });
      return;
    }

    setState(() {
      _isSearchingInProgress = true;
      _showNotFoundMessage = false;
    });

    final result = _pdfViewerController.searchText(query);

    result.addListener(() {
      if (mounted) {
        setState(() {
          _searchResult = result;
          _isSearchingInProgress = false;
          // Only show not found if search is complete and has no results
          _showNotFoundMessage = !result.hasResult && !_isSearchingInProgress;
        });
      }
    });
  }

// Add this method
  void _setupPageChangeListener() {
    _pdfViewerController.addListener(() async {
      if (!_isInitialLoad) {
        // Only save if not initial load
        final now = DateTime.now();
        if (now.difference(_lastPageSaveTime).inSeconds > 5) {
          final currentPage = _pdfViewerController.pageNumber;
          if (currentPage != null && currentPage > 1) {
            // Also don't save page 1
            await _saveLastReadPage(currentPage);
            _lastPageSaveTime = now;
          }
        }
      }
    });
  }

  void _zoomIn() {
    final currentPage = _pdfViewerController.pageNumber;
    _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
    if (currentPage != null) {
      _saveLastReadPage(currentPage);
    }
  }

  void _zoomOut() {
    final currentPage = _pdfViewerController.pageNumber;
    if (_pdfViewerController.zoomLevel > 1.0) {
      _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
    }
    if (currentPage != null) {
      _saveLastReadPage(currentPage);
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

// Add these methods to your _FilePageState class for contune read page ..

  Future<void> _saveLastReadPage(int pageNumber) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('ReadingProgress')
          .doc(widget.fileid)
          .set({
        'lastPage': pageNumber,
        'lastUpdated': FieldValue.serverTimestamp(),
        'fileId': widget.fileid,
        'fileTitle': widget.title,
        'fileUrl': widget.fileUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving last page: $e');
    }
  }

  Future<int?> _loadLastReadPage() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('userFile')
          .doc(user.uid)
          .collection('ReadingProgress')
          .doc(widget.fileid)
          .get();

      return doc.data()?['lastPage'] as int?;
    } catch (e) {
      debugPrint('Error loading last page: $e');
      return null;
    }
  }

  void _setAnnotationMode(PdfAnnotationMode mode) {
    setState(() {
      // Toggle: tap same icon again to disable
      if (_currentMode == mode) {
        _pdfViewerController.annotationMode = PdfAnnotationMode.none;
        _currentMode = PdfAnnotationMode.none;
      } else {
        _pdfViewerController.annotationMode = mode;
        _currentMode = mode;
      }

      _showToolbar = false;
    });
  }

  void _onTextSelectionChanged(PdfTextSelectionChangedDetails details) {
    // Auto-clear annotation mode after selection
    if (details.selectedText != null && details.selectedText!.isNotEmpty) {
      if (_currentMode != PdfAnnotationMode.none) {
        // Let annotation apply, then reset mode after delay
        Future.delayed(const Duration(milliseconds: 300), () {
          _pdfViewerController.annotationMode = PdfAnnotationMode.none;
          setState(() {
            _currentMode = PdfAnnotationMode.none;
          });
        });
      }
    }
  }

  void _clearAnnotationAndSelection() {
    // Make a copy of the list to avoid concurrent modification
    final annotations =
        List<Annotation>.from(_pdfViewerController.getAnnotations());

    for (final annotation in annotations) {
      _pdfViewerController.removeAnnotation(annotation);
    }

    // Clear selection and reset state
    _pdfViewerController.clearSelection();
    setState(() {
      _currentMode = PdfAnnotationMode.none;
      _selectedText = null;
      _showToolbar = false;
    });
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
                      onSubmitted: (query) => _searchText(query),
                    ),
                  ),
                  if (_isSearchingInProgress)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppConstant.appTextColor,
                        ),
                      ),
                    ),
                  if (_showNotFoundMessage && !_isSearchingInProgress)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Not found',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  if (_searchResult.hasResult && !_isSearchingInProgress) ...[
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
                  _showNotFoundMessage = false;
                  _isSearchingInProgress = false;
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppConstant.appTextColor,
            ),
            onPressed: () {
              setState(() {
                _showToolbar = !_showToolbar;
              });
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Main FAB that toggles the menu
          FloatingActionButton(
            backgroundColor: AppConstant.appMainColor,
            heroTag: 'main_fab',
            onPressed: () => setState(() => _showFabMenu = !_showFabMenu),
            child: Icon(_showFabMenu ? Icons.close : Icons.menu),
            mini: true,
          ),

          if (_showFabMenu) ...[
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: AppConstant.appMainColor.withOpacity(0.7),
              heroTag: 'add_bookmark',
              onPressed: () {
                _showAddBookmarkDialog();
                setState(() => _showFabMenu = false);
              },
              child: Icon(Icons.bookmark_add),
              mini: true,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: AppConstant.appMainColor.withOpacity(0.7),
              heroTag: 'view_bookmarks',
              onPressed: () {
                _showBookmarksDialog();
                setState(() => _showFabMenu = false);
              },
              child: Icon(Icons.bookmark),
              mini: true,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: AppConstant.appMainColor.withOpacity(0.7),
              heroTag: 'save_position',
              onPressed: () async {
                final currentPage = _pdfViewerController.pageNumber;
                if (currentPage != null) {
                  await _saveLastReadPage(currentPage);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Saved position: page $currentPage'),
                      backgroundColor: AppConstant.appMainColor,
                    ),
                  );
                }
                setState(() => _showFabMenu = false);
              },
              child: Icon(Icons.save),
              mini: true,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_upward, color: AppConstant.appMainColor),
                onPressed: () async {
                  _pdfViewerController.previousPage();
                  final currentPage = _pdfViewerController.pageNumber;
                  if (currentPage != null) {
                    await _saveLastReadPage(currentPage);
                  }
                },
              ),
              IconButton(
                icon:
                    Icon(Icons.arrow_downward, color: AppConstant.appMainColor),
                onPressed: () async {
                  _pdfViewerController.nextPage();
                  final currentPage = _pdfViewerController.pageNumber;
                  if (currentPage != null) {
                    await _saveLastReadPage(currentPage);
                  }
                },
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
              enableTextSelection: true,
              interactionMode: PdfInteractionMode.selection,
              onTextSelectionChanged: _onTextSelectionChanged,
            ),
          ),
          if (_showToolbar)
            Positioned(
              top: 80,
              left: 10,
              right: 10,
              child: _buildAnnotationToolbar(),
            ),
        ],
      ),
    );
  }

  Widget _buildAnnotationToolbar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 10,
          children: [
            IconButton(
              icon: Icon(Icons.highlight,
                  color: _currentMode == PdfAnnotationMode.highlight
                      ? Colors.orange
                      : null),
              tooltip: 'Highlight',
              onPressed: () => _setAnnotationMode(PdfAnnotationMode.highlight),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: Icon(Icons.format_underline,
                  color: _currentMode == PdfAnnotationMode.underline
                      ? Colors.orange
                      : null),
              tooltip: 'Underline',
              onPressed: () => _setAnnotationMode(PdfAnnotationMode.underline),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: Icon(Icons.strikethrough_s,
                  color: _currentMode == PdfAnnotationMode.strikethrough
                      ? Colors.orange
                      : null),
              tooltip: 'Strikethrough',
              onPressed: () =>
                  _setAnnotationMode(PdfAnnotationMode.strikethrough),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: Icon(Icons.format_overline,
                  color: _currentMode == PdfAnnotationMode.squiggly
                      ? Colors.orange
                      : null),
              tooltip: 'Squiggly',
              onPressed: () => _setAnnotationMode(PdfAnnotationMode.squiggly),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: Icon(Icons.sticky_note_2_outlined,
                  color: _currentMode == PdfAnnotationMode.stickyNote
                      ? Colors.orange
                      : null),
              tooltip: 'Sticky Note',
              onPressed: () => _setAnnotationMode(PdfAnnotationMode.stickyNote),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              tooltip: 'Remove Annotation (Clear Selection)',
              onPressed: _clearAnnotationAndSelection,
            ),
          ],
        ),
      ),
    );
  }
}
