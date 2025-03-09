// ignore_for_file: file_names, unnecessary_overrides

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

class PdfController extends GetxController {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
}
