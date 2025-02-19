import 'package:flutter/material.dart';
import 'package:health_sync/chatbot/chatbot_page.dart';
import 'package:health_sync/first_screen_widgets/city_hospital_list.dart';
// Import the ChatBotPage

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Browse By Hospitals Card
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to ChatBotPage when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotScreen()),
                );
              },
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // Doctor Image Container
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://wesoftyou.com/wp-content/uploads/2025/01/robot-1280x720_0.jpg", // Replace with an actual image URL
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, size: 40, color: Colors.grey);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Text Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Chat with us 24/7",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Talk with virtual Assistant for help",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // CityHospitalList
          Expanded(
            child: CityHospitalList(),
          ),
        ],
      ),
    );
  }
}
