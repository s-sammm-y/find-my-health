import 'package:flutter/material.dart';
import 'package:health_sync/chatbot/chatbot_page.dart';
import 'package:health_sync/widgets/opd_booking.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final List<Map<String, dynamic>> diseases = [
    {
      "name": "Chest",
      "image":
          "https://lasecosmetic.com/wp-content/uploads/2019/12/Breast-Chest-Male-Chest-Redefinition-Surgery-1.jpg",
      "description": "Specialized care for chest-related conditions",
      "color": Colors.teal[100]
    },
    {
      "name": "Dental",
      "image":
          "https://dentallavelle.com/wp-content/uploads/2019/06/Dental-Lavelle-Why-you-need-to-visit-your-Dentist-every-6-months.jpg",
      "description": "Complete dental care services",
      "color": Colors.teal[200]
    },
    {
      "name": "General",
      "image":
          "https://nmc.ae/_next/image?url=https%3A%2F%2Fstatic-cdn.nmc.ae%2Fstrapi%2FGeneral_Medicine_Getty_Images_175264754_706x500px_8673c31a59.jpg&w=3840&q=75",
      "description": "Comprehensive general medical care",
      "color": Colors.teal[300]
    },
    {
      "name": "Orthopedic",
      "image":
          "https://img.freepik.com/free-photo/doctor-examining-patient-with-knee-problems_23-2148882104.jpg",
      "description": "Expert care for bone and joint conditions",
      "color": Colors.teal[400]
    },
    {
      "name": "Pediatric",
      "image":
          "https://img.freepik.com/free-photo/doctor-examining-child_23-2148882159.jpg",
      "description": "Specialized healthcare for children",
      "color": Colors.teal[500]
    },
    {
      "name": "ENT",
      "image":
          "https://img.freepik.com/free-photo/doctor-examining-patient-s-ear_23-2148882168.jpg",
      "description": "Ear, nose, and throat specialist care",
      "color": Colors.teal[600]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chatbot Card
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBotScreen(),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'chat_card',
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.teal.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.teal[50]!,
                              Colors.white,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.teal[100],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    "https://wesoftyou.com/wp-content/uploads/2025/01/robot-1280x720_0.jpg",
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Icon(Icons.smart_toy_rounded,
                                          size: 40, color: Colors.teal[300]);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Chat with us 24/7",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.chat_bubble_outline,
                                            size: 20, color: Colors.teal[300]),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Get instant assistance with our AI-powered virtual assistant",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // OPD Services Title
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  "Our OPD Services",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OPD Services Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: diseases.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: MouseRegion(
                      onEnter: (_) => setState(() {}),
                      onExit: (_) => setState(() {}),
                      child: GestureDetector(
                        onTapDown: (_) => setState(() {}),
                        onTapUp: (_) {
                          setState(() {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OPDBookingPage(
                                selectedDisease: diseases[index]["name"]!,
                              ),
                            ),
                          );
                        },
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: 0.95 + (0.05 * value),
                              child: Opacity(
                                opacity: value,
                                child: Hero(
                                  tag: 'opd_service_${diseases[index]["name"]}',
                                  child: Card(
                                    elevation: 4,
                                    shadowColor: Colors.teal.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            diseases[index]["color"]!,
                                            Colors.white,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.teal.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.vertical(
                                                    top: Radius.circular(15)),
                                                child: ShaderMask(
                                                  shaderCallback: (Rect bounds) {
                                                    return LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                                                      stops: const [0.7, 1.0],
                                                    ).createShader(bounds);
                                                  },
                                                  blendMode: BlendMode.darken,
                                                  child: Image.network(
                                                    diseases[index]["image"]!,
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if (loadingProgress == null) return child;
                                                      return Container(
                                                        height: 120,
                                                        color: diseases[index]["color"],
                                                        child: const Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        height: 120,
                                                        color: diseases[index]["color"],
                                                        child: const Icon(
                                                          Icons.medical_services,
                                                          size: 50,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  diseases[index]["name"]!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  diseases[index]["description"]!,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
