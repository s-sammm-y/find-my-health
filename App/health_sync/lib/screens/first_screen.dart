import 'package:flutter/material.dart' hide CarouselController;
import 'package:health_sync/chatbot/chatbot_page.dart';
import 'package:health_sync/first_screen_widgets/opd_services_page.dart';
// import 'package:health_sync/screens/second_screen.dart';
import 'package:health_sync/widgets/opd_booking.dart';
import 'package:health_sync/widgets/voice_chatbot_ui.dart';
import 'package:carousel_slider/carousel_slider.dart' as carouselSlider;

class FirstScreen extends StatefulWidget {
  final void Function(int)? onTabChange;
  const FirstScreen({super.key, this.onTabChange});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _VibratingPhoneIcon extends StatefulWidget {
  @override
  _VibratingPhoneIconState createState() => _VibratingPhoneIconState();
}

class _VibratingPhoneIconState extends State<_VibratingPhoneIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100), // Fast vibration
      vsync: this,
    )..repeat(reverse: true); // Continuous animation
    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0), // Horizontal vibration
          child: Icon(
            Icons.phone_in_talk,
            size: 20,
            color: Colors.red[800],
          ),
        );
      },
    );
  }
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> diseases = [
    {
      "name": "Chest",
      "image":
          "https://lasecosmetic.com/wp-content/uploads/2019/12/Breast-Chest-Male-Chest-Redefinition-Surgery-1.jpg",
      "description": "Specialized care for chest-related conditions",
      "color": Colors.teal[300]
    },
    {
      "name": "Dental",
      "image":
          "https://dentallavelle.com/wp-content/uploads/2019/06/Dental-Lavelle-Why-you-need-to-visit-your-Dentist-every-6-months.jpg",
      "description": "Complete dental care services",
      "color": Colors.teal[300]
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
      "color": Colors.teal[300]
    },
    {
      "name": "Pediatric",
      "image":
          "https://img.freepik.com/free-photo/doctor-examining-child_23-2148882159.jpg",
      "description": "Specialized healthcare for children",
      "color": Colors.teal[300]
    },
    {
      "name": "ENT",
      "image":
          "https://img.freepik.com/free-photo/doctor-examining-patient-s-ear_23-2148882168.jpg",
      "description": "Ear, nose, and throat specialist care",
      "color": Colors.teal[300]
    }
  ];

  final List<String> imgList = [
    'https://images.pexels.com/photos/3376799/pexels-photo-3376799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/236380/pexels-photo-236380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/305568/pexels-photo-305568.jpeg?auto=compress&cs=tinysrgb&w=1950',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SingleChildScrollView(
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
                            builder: (context) => VoiceChatbotPage(),
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
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.teal[100],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.teal.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            "https://wesoftyou.com/wp-content/uploads/2025/01/robot-1280x720_0.jpg",
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(
                                                  Icons.smart_toy_rounded,
                                                  size: 30,
                                                  color: Colors.teal[300]);
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Talk with Virtual Doctor",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(Icons.chat_bubble_outline,
                                                    size: 20,
                                                    color: Colors.teal[300]),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Consult With our AI-powered virtual Doctor anytime",
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
                                Positioned(
                                  right: 16,
                                  bottom: 16,
                                  child: _VibratingPhoneIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "OPD Services",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OPDServicesPage(diseases: diseases),
                            ),
                          );
                        },
                        child: const Text(
                          "See all services",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // OPD Services Carousel
                  SizedBox(
                    height: 200,
                    child: carouselSlider.CarouselSlider(
                      options: carouselSlider.CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false, // Disable to avoid scaling
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 1.0, // Full screen width
                      ),
                      items: diseases.asMap().entries.map((entry) {
                        final index = entry.key;
                        final disease = entry.value;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OPDBookingPage(
                                  selectedDisease: disease["name"]!,
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
                                    tag: 'opd_service_${disease["name"]}',
                                    child: Card(
                                      elevation: 4,
                                      shadowColor: Colors.teal.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        width: screenWidth -
                                            40, // Full width minus padding
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              disease["color"]!,
                                              Colors.white,
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(15)),
                                              child: Image.network(
                                                disease["image"]!,
                                                height: 130,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return Container(
                                                    height: 100,
                                                    color: disease["color"],
                                                    child: const Icon(
                                                      Icons.medical_services,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    disease["name"]!,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.teal,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    disease["description"]!,
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Live Bed Availability Card
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
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.onTabChange != null) {
                              widget.onTabChange!(1);
                            }
                          },
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.redAccent.withOpacity(0.4),
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
                                    Colors.red[50]!,
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
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.redAccent
                                                .withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          "https://img.freepik.com/free-vector/hospital-bed-concept-illustration_114360-8741.jpg",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.bed_rounded,
                                                size: 30,
                                                color: Colors.red[300]);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Check Live Bed Status",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.redAccent,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                  Icons
                                                      .airline_seat_individual_suite_rounded,
                                                  size: 20,
                                                  color: Colors.red[300]),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Check real-time hospital bed availability",
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
                        Positioned(
                          right: 18,
                          bottom: 18,
                          child: _BlinkingRedDot(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  carouselSlider.CarouselSlider(
                    options: carouselSlider.CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false, // Disable to reduce gaps
                      viewportFraction: 1.0, // Full screen width
                      scrollDirection: Axis.horizontal,
                    ),
                    items: imgList
                        .map((item) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 2.0), // Minimal margin
                              child: Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ))),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return IgnorePointer(
                child: Positioned(
                  top: _animation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceChatbotPage(),
                      ),
                    );
                  },
                  backgroundColor: Colors.teal,
                  shape: const CircleBorder(),
                  tooltip: 'Book OPD by Voice',
                  child: const Icon(Icons.phone_in_talk, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 60,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: child,
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.teal.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.teal[50],
                        ),
                        child: Text(
                          'Want to book OPD? Call us and book now',
                          style: TextStyle(
                            color: Colors.teal[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget at the end of the file (outside the class)
class _BlinkingRedDot extends StatefulWidget {
  @override
  _BlinkingRedDotState createState() => _BlinkingRedDotState();
}

class _BlinkingRedDotState extends State<_BlinkingRedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
