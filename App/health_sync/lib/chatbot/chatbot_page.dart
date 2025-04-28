import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  String? _geminiApiKey;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    // Automatically greet the user if the chat is empty
    if (_messages.isEmpty) {
      _messages.add({
        'text': 'Are you facing any problem ? Tell me',
        'isUser': false,
        'time': DateTime.now(),
      });
    }
  }

  // Load API key from .env file
  Future<void> _loadApiKey() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      setState(() {
        _geminiApiKey = dotenv.env['GEMINI_API_KEY'];
      });
      if (_geminiApiKey == null || _geminiApiKey!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: Gemini API key not found in .env')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading .env file: $e')),
      );
    }
  }

  // Reset chat functionality
  void _resetChat() {
    setState(() {
      _messages.clear();
    });
  }

  // Handle sending a message and calling Gemini API
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add({
        'text': userMessage,
        'isUser': true,
        'time': DateTime.now(),
      });
      _controller.clear();
      _isTyping = true;
    });

    if (_geminiApiKey == null || _geminiApiKey!.isEmpty) {
      setState(() {
        _messages.add({
          'text': 'Error: Gemini API key is missing.',
          'isUser': false,
          'time': DateTime.now(),
        });
        _isTyping = false;
      });
      return;
    }

    try {
      final response = await _callGeminiApi(userMessage);
      setState(() {
        _messages.add({
          'text': response,
          'isUser': false,
          'time': DateTime.now(),
        });
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Error: Could not get response from Gemini API. $e',
          'isUser': false,
          'time': DateTime.now(),
        });
        _isTyping = false;
      });
    }
  }

  // Call Gemini API
  Future<String> _callGeminiApi(String userMessage) async {
    // Use the correct model and endpoint (e.g., gemini-1.5-pro or gemini-1.5-flash)
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
    final uri = Uri.parse('$apiUrl?key=$_geminiApiKey');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': userMessage}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Log the response for debugging
        debugPrint('API Response: $data');
        // Check if the expected field exists
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('No valid candidates in response');
        }
      } else {
        // Log the error response for debugging
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Log the exception for debugging
      debugPrint('API Call Exception: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat messages area
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isTyping && index == _messages.length) {
                return _buildTypingIndicator();
              }
              final message = _messages[index];
              return _buildChatBubble(
                message['text'],
                message['isUser'],
                message['time'],
              );
            },
          ),
        ),
        // Input area with reset button
        _buildInputArea(),
      ],
    );
  }

  // Build chat bubble
  Widget _buildChatBubble(String text, bool isUser, DateTime time) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build input area with reset button
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Reset button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.teal),
            tooltip: 'Reset Chat',
            onPressed: _resetChat,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: Colors.teal,
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget _buildTypingIndicator() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedTypingDots(),
        ],
      ),
    ),
  );
}

class _AnimatedTypingDots extends StatefulWidget {
  @override
  State<_AnimatedTypingDots> createState() => _AnimatedTypingDotsState();
}

class _AnimatedTypingDotsState extends State<_AnimatedTypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int dot = ((3 * _controller.value)).floor() % 3;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Opacity(
                opacity: i <= dot ? 1.0 : 0.3,
                child: const Text(
                  '.',
                  style: TextStyle(fontSize: 28, color: Colors.grey),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
