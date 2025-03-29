// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';

import '../../utils/App_constant.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final translator = GoogleTranslator();
  String translatedText = '';
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

  /*void translateText() async {
    final translation = await translator.translate(inputText, from: fromLanguage, to: toLanguage);
    setState(() {
      translatedText = translation.text;
    });
  }*/

  void translateText() async {
    if (inputText.trim().isEmpty) {
      setState(() {
        translatedText = ''; // Clear translated text if input is empty
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter text to translate',
              style: TextStyle(color: Colors.white)),
          backgroundColor: AppConstant.appMainColor,
        ),
      );
      return;
    }

    final translation = await translator.translate(inputText,
        from: fromLanguage, to: toLanguage);

    setState(() {
      translatedText = translation.text;
    });
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: translatedText));
    if (translatedText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nothing to copy!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppConstant.appMainColor, // Error color
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('the translation has been copied ',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor, // Success color
        behavior: SnackBarBehavior.floating, // Optional for better visibility
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    );
  }

  void swapLanguages() {
    setState(() {
      String temp = fromLanguage;
      fromLanguage = toLanguage;
      toLanguage = temp;
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
                GestureDetector(
                  onTap: swapLanguages,
                  child: const Icon(
                    Icons.swap_horiz,
                    size: 30,
                    color: AppConstant.appMainColor,
                  ),
                ),
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
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (text) {
                setState(() {
                  inputText = text;
                  if (text.trim().isEmpty) {
                    translatedText =
                        ''; // Clear translation result when input is empty
                  }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    translatedText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: copyToClipboard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                    ),
                    child: const Text("Copy",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
