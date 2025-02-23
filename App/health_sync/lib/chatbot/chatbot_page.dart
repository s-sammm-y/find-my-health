import 'package:flutter/material.dart';
import 'package:health_sync/chatbot/chatbot_logic.dart'; // Import the chatbot logic file

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final ChatbotLogic chatbot = ChatbotLogic();
  bool isTyping = false; // Tracks if bot is "typing"
  bool showBookingOptions = true; // Show buttons for OPD and Emergency
  bool showDateButtons = false; // Show buttons for date selection

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    setState(() {
      messages.add({
        "role": "bot",
        "text": "How can we help you?",
        "showButtons": true,
      });
    });
  }

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "text": userMessage});
      isTyping = true;
      showBookingOptions = false; // Hide OPD and Emergency buttons
      showDateButtons = false; // Hide date buttons unless triggered
    });

    String botReply = await chatbot.getBotResponse(userMessage);

    setState(() {
      isTyping = false;
      messages.add({"role": "bot", "text": botReply});
      
      // Show date buttons if bot asks for a date
      if (botReply.contains("Please select a date")) {
        showDateButtons = true;
      }
    });
  }

  void _handleBooking(String bookingType) {
    if (bookingType == "I want to book an OPD appointment") {
      chatbot.startOPDBookingFlow();
      sendMessage("I want to book an OPD appointment");
    } else {
      sendMessage(bookingType);
    }
  }

  void _selectDate(String dateOption) {
    sendMessage(dateOption); // Send "Tomorrow" or "Day after tomorrow"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Sync AI"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: () {
              setState(() {
                messages.clear();
                _showWelcomeMessage();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text("Bot is typing...",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey)),
                    ),
                  );
                }

                final message = messages[index];
                bool isUser = message["role"] == "user";
                bool showButtons = message["showButtons"] ?? false;

                return Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message["text"] ?? "",
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black)),
                    ),
                    // OPD and Emergency Buttons
                    if (showButtons && showBookingOptions)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleBooking(
                                    "I want to book an OPD appointment"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text("OPD Booking",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _handleBooking("I have a medical emergency"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text("Emergency",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Date selection buttons (Tomorrow / Day after tomorrow)
                    if (showDateButtons)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectDate("Tomorrow"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text("Tomorrow",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _selectDate("Day after tomorrow"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text("Day after tomorrow",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
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
