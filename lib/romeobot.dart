import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'customcontainer.dart';
import 'keys.dart';

class Bot extends StatefulWidget {
  const Bot({Key? key}) : super(key: key);

  @override
  State<Bot> createState() => _BotState();
}

class _BotState extends State<Bot> {
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKEY';

  final header = {
    'Content-Type': 'application/json',
  };

  ChatUser me = ChatUser(
    id: '1',
    firstName: 'Krishna',
  );
  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Romeo',
  );

  List<ChatMessage> messageList = [];
  List<ChatUser> typing = [];

  void getMessage(ChatMessage message) async {
    typing.add(bot);
    messageList.insert(0, message);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };
    await http
        .post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode(data),
    )
        .then(
      (value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);
          debugPrint(
            result['candidates'][0]['content']['parts'][0]['text'],
          );

          ChatMessage romeoMessage = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now(),
          );

          messageList.insert(0, romeoMessage);
        } else {
          debugPrint("Some Error Occurred!");
        }
      },
    ).catchError(
      (exception) {},
    );
    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 48.0,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/romeo.png'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Romeo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 163, 5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text(
            'Hey, How can I help you today?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20,
                bottom: 10,
              ),
              child: Text(
                'Try a suggestion',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                CustomContainer(
                  color: Color.fromRGBO(166, 237, 244, 0.758),
                  headerText: 'Write an email',
                  descText: 'requesting a leave from office for 3-days',
                ),
              ],
            ),
          ),
          Expanded(
            child: DashChat(
              typingUsers: typing,
              currentUser: me,
              onSend: (ChatMessage message) {
                getMessage(message);
              },
              messages: messageList,
            ),
          ),
        ],
      ),
    );
  }
}
