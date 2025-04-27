import 'package:flutter/material.dart';
import 'package:health_sync/widgets/opd_booking.dart';

class CityHospitalList extends StatelessWidget {
  CityHospitalList({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with animation
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

            // Grid of OPD Services
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio:
                      0.75, // Taller cards for better content display
                ),
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OPDBookingPage(
                            selectedDisease: diseases[index]["name"]!,
                          ),
                        ),
                      );
                    },
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
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Disease Image
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Image.network(
                                      diseases[index]["image"]!,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 120,
                                          color: diseases[index]["color"],
                                          child: const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white)),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 120,
                                          color: diseases[index]["color"],
                                          child: const Icon(
                                              Icons.medical_services,
                                              size: 50,
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent
                                          ],
                                        ),
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
                                    // Disease Name
                                    Text(
                                      diseases[index]["name"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Description
                                    Text(
                                      diseases[index]["description"]!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
