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
  List<ChatMessage> massages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1", firstName: "Gemini", profileImage: 'assests/images/gmini.jpeg');

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
        inputOptions: InputOptions(trailing: [
          IconButton(
              onPressed: _SendMediaMessage, icon: const Icon(Icons.image))
        ]),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: massages);
  }

  //this function will be called when the user enter the send button
  void _sendMessage(ChatMessage chatMassage) {
    setState(() {
      massages = [chatMassage, ...massages];
    });
    try {
      String question = chatMassage.text; //this message will pass to gimini
      List<Uint8List>? images;
      if (chatMassage.medias?.isNotEmpty ?? false) {
        //this means that file,image,media attached
        images = [File(chatMassage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = massages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = massages.removeAt(0);
          String responce = event.content?.parts //current.text
                  ?.fold(
                      "",
                      (previous, current) =>
                          "$previous ${current.toString()}") ??
              "";
          lastMessage.text += responce;
          setState(() {
            massages = [lastMessage!, ...massages];
          });
        } else {
          String responce = event.content?.parts //current.text not toString
                  ?.fold(
                      "",
                      (previous, current) =>
                          "$previous ${current.toString()}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: responce);
          setState(() {
            massages = [message, ...massages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _SendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
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
