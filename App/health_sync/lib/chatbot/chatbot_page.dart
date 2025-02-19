import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  final String? apiKey = dotenv.env['apiKey'];
  bool isLoading = false;

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "text": userMessage});
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": userMessage}
              ]
            }
          ],
          "generationConfig": {
            "maxOutputTokens": 100,
            "temperature": 0.7, // Controls randomness
            "topP": 0.8 // Limit response to 150 tokens
          }
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String botReply = responseBody["candidates"]?[0]?["content"]?["parts"]
                ?[0]?["text"] ??
            "I couldn't understand that.";

        setState(() {
          messages.add({"role": "bot", "text": botReply});
        });
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text": "Error: ${response.body}"
          }); // Show full error
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "text": "Error: $e"});
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Sync AI"),
      actions: [
    IconButton(
      icon: Icon(Icons.delete, color: const Color.fromARGB(255, 0, 0, 0)),
      onPressed: () {
        setState(() {
          messages.clear(); // Clears all chat messages
        });
      },
    ),
  ],),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["role"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(messages[index]["text"] ?? "",
                        style: TextStyle(
                            color: isUser ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          if (isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Ask something...",
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
