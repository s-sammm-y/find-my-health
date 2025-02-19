import 'package:flutter/material.dart';
import 'package:health_sync/widgets/opd_booking.dart'; // Import the OPD Booking Page

class CityHospitalList extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {
      "name": "Chest OPD",
      "image": "https://lasecosmetic.com/wp-content/uploads/2019/12/Breast-Chest-Male-Chest-Redefinition-Surgery-1.jpg"
    },
    {
      "name": "Dental OPD",
      "image": "https://dentallavelle.com/wp-content/uploads/2019/06/Dental-Lavelle-Why-you-need-to-visit-your-Dentist-every-6-months.jpg"
    },
    {
      "name": "General OPD",
      "image": "https://nmc.ae/_next/image?url=https%3A%2F%2Fstatic-cdn.nmc.ae%2Fstrapi%2FGeneral_Medicine_Getty_Images_175264754_706x500px_8673c31a59.jpg&w=3840&q=75"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Our OPD Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Grid of OPD Services
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9, // Adjust for a balanced look
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
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Disease Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              diseases[index]["image"]!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50, color: Colors.red);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Disease Name
                          Text(
                            diseases[index]["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
