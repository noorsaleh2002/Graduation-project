// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import '../utils/App_constant.dart';
import 'Api/summary_service.dart';
import 'PreiewScreen.dart';
import 'summaryText.dart';

class Summaryscreen extends StatefulWidget {
  const Summaryscreen({super.key});
  @override
  State<Summaryscreen> createState() => _SummaryscreenState();
}

class _SummaryscreenState extends State<Summaryscreen> {
  final SummaryService _summaryService = SummaryService();
  PlatformFile? file;
  double summaryLength = 0.5;
  double detailLevel = 2;

  Future<void> _downloadPDF(
      String content, String fileName, BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context ctx) => pw.Text(content)));

    try {
      // Request permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission is required")),
        );
        return;
      }

      // Get the storage directory
      final dir = await getExternalStorageDirectory();
      final filePath = "${dir!.path}/$fileName";
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Downloaded Done!"),
            backgroundColor: AppConstant.appMainColor),
      );
      OpenFile.open(filePath);
    } catch (e) {
      print("Download error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to download PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text(
          "File Summarizer",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: pickFile,
                    child: Text(
                      "Select File",
                      style: TextStyle(color: AppConstant.appMainColor),
                    )),
                const SizedBox(
                  height: 20,
                ),
                if (file != null) ...[
                  selectedFile(context),
                  const SizedBox(
                    height: 40,
                  ),
                  summaryLevelSlider(),
                  const SizedBox(
                    height: 20,
                  ),
                  detailLevelSlider(),
                  const SizedBox(
                    height: 20,
                  ),
                  summarizeButton(context),
                ] else
                  history(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton summarizeButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          try {
            if (file == null) {
              throw Exception("File is null!");
            }
            final summary = await _summaryService.summarizeFile(
                file!, summaryLength, detailLevel.toInt());

            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Summarytext(
                            summary: summary,
                            fileName: file!.name,
                          )));
            }
          } catch (e, stacktrace) {
            print("Error: $e");
            print(stacktrace);
          }
        },
        child: const Text("Summarize",
            style: TextStyle(color: AppConstant.appMainColor)));
  }

  Column summaryLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Summary Length",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
                label: Text(
              summaryLength.toStringAsPrecision(2),
              style: const TextStyle(fontSize: 16),
            )),
          ],
        ),
        Slider(
          min: 0.1,
          max: 1,
          divisions: 9,
          value: summaryLength,
          label: summaryLength.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              summaryLength = value;
            });
          },
        ),
      ],
    );
  }

  Column detailLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Detail Level",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
                label: Text(
              detailLevel.toStringAsPrecision(2),
              style: const TextStyle(fontSize: 16),
            )),
          ],
        ),
        Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: detailLevel,
          label: detailLevel.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              detailLevel = value;
            });
          },
        ),
      ],
    );
  }

  Row selectedFile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text('Selected File: ${file!.name}')),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Preiewscreen(file: file!)));
          },
          child: Text('Preview'),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                file = null;
              });
            },
            icon: Icon(Icons.cancel)),
      ],
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );
    if (result != null) {
      setState(() {
        file = result.files.single;
      });
    }
  }

  StreamBuilder<QuerySnapshot<Object?>> history() {
    return StreamBuilder<QuerySnapshot>(
        stream: _summaryService.fetchSummaries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final summaries = snapshot.data!.docs;
            return summaries.isNotEmpty
                ? summaryHistory(summaries)
                : SizedBox.shrink();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget summaryHistory(List<QueryDocumentSnapshot<Object?>> summaries) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: AppConstant.appMainColor,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "History",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: summaries.length,
            itemBuilder: (context, index) {
              final summary = summaries[index].data() as Map<String, dynamic>;
              final fileName =
                  summary['fileName'].toString().replaceAll('.pdf', '');
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    fileName,
                    style: const TextStyle(
                        fontSize: 16, color: AppConstant.appTextColor2),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Summarytext(
                                fileName: summary['fileName'],
                                summary: summary['summary'],
                                isHistory: true,
                              )));
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download,
                          color: AppConstant.appMainColor),
                      onPressed: () async {
                        await _downloadPDF(
                            summary['summary'], summary['fileName'], context);
                      },
                    ),
                    IconButton(
                        onPressed: () =>
                            _summaryService.deleteSummary(summaries[index].id),
                        icon: const Icon(
                          Icons.delete,
                          color: AppConstant.appMainColor,
                        )),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
