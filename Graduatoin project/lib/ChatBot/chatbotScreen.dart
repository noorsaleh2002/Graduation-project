import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image),
          )
        ],
        inputTextStyle: TextStyle(color: const Color.fromARGB(255, 66, 7, 77)),
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.white,
        containerColor: AppConstant.appTextColor2,
        textColor: AppConstant.appTextColor,
        messageTextBuilder: _buildMessageText,
      ),
    );
  }

  Widget _buildMessageText(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage) {
    final isCurrentUser = message.user.id == currentUser.id;
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppConstant.appMainColor.withOpacity(0.5)
                  : AppConstant.appTextColor2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  message.text,
                  style: TextStyle(
                    color: AppConstant.appTextColor,
                    fontSize: 16,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon:
                        Icon(Icons.copy, size: 18, color: Colors.grey.shade600),
                    tooltip: "Copy to Clipboard",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Message copied to clipboard"),
                          duration: Duration(seconds: 1),
                          backgroundColor: AppConstant.appMainColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isCurrentUser)
          IconButton(
            icon: Icon(Icons.edit, color: AppConstant.appMainColor, size: 18),
            tooltip: "Edit Message",
            onPressed: () => _editMessage(message),
          ),
      ],
    );
  }

  void _editMessage(ChatMessage oldMessage) {
    TextEditingController _controller =
        TextEditingController(text: oldMessage.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.edit, color: AppConstant.appMainColor),
              SizedBox(width: 8),
              Text(
                "Edit Your Message",
                style: TextStyle(
                  color: AppConstant.appMainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: _controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Update your message...",
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppConstant.appMainColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(color: AppConstant.appMainColor)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.save, color: AppConstant.appTextColor),
              label: Text("Update"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                String updatedText = _controller.text.trim();
                if (updatedText.isNotEmpty) {
                  setState(() {
                    int index = messages.indexOf(oldMessage);
                    messages[index] = ChatMessage(
                      user: currentUser,
                      createdAt: oldMessage.createdAt,
                      text: updatedText,
                      medias: oldMessage.medias,
                    );
                  });

                  _sendMessage(messages.firstWhere((m) =>
                      m.createdAt == oldMessage.createdAt &&
                      m.user.id == currentUser.id));
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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

    // Show dialog to pick between camera or gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose Image Source?',
            style: TextStyle(
                color: AppConstant.appMainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppConstant.appMainColor,
                    ),
                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                    child: Text('Camera', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppConstant.appMainColor,
                    ),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                    child: Text('Gallery', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppConstant.appMainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (source != null) {
      // Pick the image based on the selected source
      final XFile? file = await picker.pickImage(source: source);

      if (file != null) {
        final ChatMessage chatMessage = ChatMessage(
            user: currentUser,
            createdAt: DateTime.now(),
            text: "Describe this picture?",
            medias: [
              ChatMedia(url: file.path, fileName: "", type: MediaType.image),
            ]);
        _sendMessage(chatMessage);
      }
    }
  }
}
