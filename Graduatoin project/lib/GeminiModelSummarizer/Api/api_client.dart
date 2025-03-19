import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String _baseUrl = 'http://192.168.8.62:5000/api';

  Future<String> summarizerDocument(
    String filePath,
    double summaryLength,
    int detailLevel,
  ) async {
    final url = Uri.parse('$_baseUrl/summarize');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('document', filePath));
    request.fields['summaryLength'] = summaryLength.toString();
    request.fields['detailLevel'] = detailLevel.toString();

    final responce = await request.send();

    if (responce.statusCode == 200) {
      final responseData = await responce.stream.bytesToString();
      return jsonDecode(responseData)['summary'];
    } else {
      throw Exception('Failed to summarize file');
    }
  }
}
