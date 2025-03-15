import 'package:flutter/material.dart';
import 'package:gp_2/utils/App_constant.dart';
import 'package:translator/translator.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final translator = GoogleTranslator();
  String translatedText = 'Translation';
  String inputText = '';
  String fromLanguage = 'en';
  String toLanguage = 'ar';

  final Map<String, String> languages = {
    'English': 'en',
    'Arabic': 'ar',
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Chinese': 'zh',
  };

  void translateText() async {
    final translation = await translator.translate(inputText,
        from: fromLanguage, to: toLanguage);
    setState(() {
      translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Translation",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: fromLanguage,
                  items: languages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      fromLanguage = value!;
                    });
                  },
                ),
                const Icon(Icons.swap_horiz, size: 30, color: Colors.grey),
                DropdownButton<String>(
                  value: toLanguage,
                  items: languages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      toLanguage = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "Enter text",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (text) {
                setState(() {
                  inputText = text;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: translateText,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor,
              ),
              child: const Text("Translate",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                translatedText,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
