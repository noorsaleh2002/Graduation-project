import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_2/GeminiModelSummarizer/Api/api_client.dart';

class SummaryService {
  final ApiClient _apiClient = ApiClient();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> summarizeFile(
    PlatformFile file,
    double summaryLength,
    int detailLevel,
  ) async {
    final summary = await _apiClient.summarizerDocument(
        file.path!, summaryLength, detailLevel);
    return summary;
  }

  Future<void> storSummary(String summary, String fileName) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('summaries')
        .add({
      'fileName': fileName,
      'summary': summary,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSummaries() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('summaries')
        .snapshots();
  }

  void deleteSummary(String docId) {
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('summaries')
        .doc(docId)
        .delete();
  }
}
