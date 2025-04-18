// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../utils/App_constant.dart';
import 'Api/summary_service.dart';

class Summarytext extends StatelessWidget {
  const Summarytext({
    super.key,
    required this.summary,
    required this.fileName,
    this.isHistory = false,
  });

  final String summary;
  final String fileName;
  final bool isHistory;

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _generateAndSavePDF(BuildContext context) async {
    bool granted = await requestStoragePermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required")),
      );
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Text(summary),
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      final path = "${directory!.path}/$fileName.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("PDF Downloaded!"),
            backgroundColor: AppConstant.appMainColor),
      );
      OpenFile.open(path);
    } catch (e) {
      print("PDF generation error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String Name = fileName.split('.').first;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "$Name",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText(
                summary,
                style: TextStyle(fontSize: 16),
              ),
              if (!isHistory) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final summaryService = SummaryService();
                    await summaryService.storSummary(summary, fileName);
                  },
                  child: Text('Save Summary',
                      style: TextStyle(color: AppConstant.appMainColor)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _generateAndSavePDF(context),
                  child: Text("Download as PDF",
                      style: TextStyle(color: AppConstant.appMainColor)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
