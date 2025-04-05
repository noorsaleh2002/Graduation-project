import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gp_2/utils/App_constant.dart';
import 'package:image_picker/image_picker.dart';

class Chatbotscreen extends StatefulWidget {
  const Chatbotscreen({super.key});

  @override
  State<Chatbotscreen> createState() => _ChatbotscreenState();
}

class _ChatbotscreenState extends State<Chatbotscreen> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage:
          'https://www.boisestate.edu/oit/wp-content/uploads/sites/42/2023/08/Google_Bard_logo-300x300.jpg' // Fixed path
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        centerTitle: true,
        title: Text(
          "Gemini Chat",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
              onPressed: _sendMediaMessage, icon: const Icon(Icons.image))
        ],
        inputTextStyle: TextStyle(color: const Color.fromARGB(255, 66, 7, 77)),
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: AppConstant.appMainColor.withOpacity(0.5),
        containerColor: AppConstant.appTextColor2,
        textColor: AppConstant.appTextColor,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      gemini.streamGenerateContent(question, images: images).listen((event) {
        String response = event.content?.parts
                ?.whereType<TextPart>()
                .map((part) => part.text)
                .join(" ") ??
            "";

        setState(() {
          // Check if there's an existing Gemini message to update
          final index = messages
              .indexWhere((m) => m.user == geminiUser && m == messages.first);

          if (index != -1) {
            // Update existing message by creating new instance
            final updatedMessage = ChatMessage(
              user: messages[index].user,
              createdAt: messages[index].createdAt,
              text: messages[index].text + response,
              medias: messages[index].medias,
            );
            messages[index] = updatedMessage;
          } else {
            // Add new message
            messages = [
              ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: response,
              ),
              ...messages,
            ];
          }
        });
      }, onError: (error) {
        setState(() {
          messages = [
            ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: "Error: ${error.toString()}",
            ),
            ...messages,
          ];
        });
      });
    } catch (e) {
      setState(() {
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: "Error: ${e.toString()}",
          ),
          ...messages,
        ];
      });
    }
  }

  Future<void> _sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture?",
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }
}
