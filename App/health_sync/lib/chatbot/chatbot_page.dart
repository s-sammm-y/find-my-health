import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: WebView(
        initialUrl:
            'https://your-chatbot-url.com', // Replace with your chatbot's hosted URL
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
