import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:geminichat/appbar.dart';
import 'package:geminichat/contstants.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatUser currentUser = ChatUser(id: '0', firstName: "User");
  ChatUser geminiUser =
      ChatUser(id: '1', firstName: "Gemini", profileImage: "assets/amico.png");
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       const DrawerHeader(
      //         child: Text("Menu"),
      //       ),
      //       ListTile(
      //         title: const Text("Chat History"),
      //         onTap: _showChatHistory,
      //       )
      //     ],
      //   ),
      // ),
      // backgroundColor: Colors.blue[900],
      backgroundColor: bgcolor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.1),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: newsappBar(
              'Chat Bot',
              () {},
              height,
              width,
            ),
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
        inputOptions: InputOptions(trailing: [
          IconButton(
              onPressed: _sendMediaMessage, icon: const Icon(Icons.image))
        ]),
        currentUser: currentUser,
        onSend: _onSend,
        messages: messages);
  }

  void _onSend(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "",
                  (previousValue, currentValue) =>
                      "$previousValue ${currentValue.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "",
                  (previousValue, currentValue) =>
                      "$previousValue ${currentValue.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _sendMediaMessage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "analysis the image",
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _onSend(chatMessage);
    }
  }

  // void _showChatHistory() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => ChatHistoryScreen(messages: messages),
  //   ));
  // }
}
