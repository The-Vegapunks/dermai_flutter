import 'package:dermai/env/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPagePatient extends StatefulWidget {
  const ChatPagePatient({super.key});

  @override
  State<ChatPagePatient> createState() => _ChatPagePatientState();
}

class _ChatPagePatientState extends State<ChatPagePatient> {
  final TextEditingController _chatController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Chat",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 160,
              child: ListView.builder(
                  itemCount: _chatHistory.length,
                  shrinkWrap: false,
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (_chatHistory[index]["isSender"]
                              ? Alignment.topRight
                              : Alignment.topLeft),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3))
                                  ],
                                  color: (_chatHistory[index]
                                          ["isSender"]
                                      ? Colors.deepPurple[300]
                                      : Colors.white)),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  _chatHistory[index]["message"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: _chatHistory[index]
                                              ["isSender"]
                                          ? Colors.white
                                          : Colors.black))),
                        ));
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  // vertical: 8,
                ),
                height: 100,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[700]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 1, bottom: 1, left: 15, right: 15),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Type your message...",
                                hintStyle: TextStyle(
                                    color: Colors.grey[300]),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.all(10)),
                            controller: _chatController,
                            maxLines: 5,
                            minLines: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      minWidth: 30,
                      onPressed: () {
                        setState(() {
                          if (_chatController.text.isNotEmpty) {
                            _chatHistory.add({
                              "time": DateTime.now(),
                              "message": _chatController.text,
                              "isSender": true,
                            });
                            _chatController.clear();
                          }
                        });
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                        setState(() {
                          if (_chatController.text.isNotEmpty) {
                            _chatHistory.add({
                              "time": DateTime.now(),
                              "message": _chatController.text,
                              "isSender": true,
                            });
                            _chatController.clear();
                          }
                        });
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );

                        getAnswer();
                      },
                      child: Ink(
                        child: Container(
                          height: 56,
                          width: 30,
                          decoration: const BoxDecoration(),
                          padding: const EdgeInsets.all(0),
                          child: Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getAnswer() async {
    List<Map<String, String>> msg = [];
    for (var i = 0; i < _chatHistory.length; i++) {
      msg.add({"content": _chatHistory[i]["message"]});
    }
    // Access your API key as an environment variable (see "Set up your API key" above)
    const String apiKey = Env.geminiKey;
    // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text(_chatController.text)];
    final response = await model.generateContent(content);
    print(_chatController.text);
    print(response.text);

    const url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey";
    final uri = Uri.parse(url);

    Map<String, dynamic> request = {
      "contents": [
        {
          "parts": [
            {
              "text": [msg]
            }
          ]
        }
      ]
    };

    final response1 = await http.post(uri, body: jsonEncode(request));

    final generatedText = response;

    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": response.text,
        "isSender": false,
      });
    });

    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
}
