import 'package:flutter/material.dart';
import 'package:health_sync/widgets/opd_booking.dart'; // Import the OPD Booking Page

class CityHospitalList extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {
      "name": "Influenza",
      "image": "https://influenzahub.com/wp-content/uploads/2023/02/influenza-rsv.jpg"
    },
    {
      "name": "Dengue",
      "image": "https://www.cdc.gov/dengue/images/socialmedia/LVV7_Aedes_aegypti_Adult_Feeding_2022_029.jpg"
    },
    {
      "name": "COVID-19",
      "image": "https://lh6.googleusercontent.com/proxy/_hqesV327apghyZcw6CyNpIGK5nSqArxGaFzVNkZFkCO9CS_b7W8ahN_grFdg_sHUy8xRWXfDaQVG1TwAzSaP0z2mGGXMcs_G4xxd9IJ"
    },
    {
      "name": "Malaria",
      "image": "https://cdn.baptistjax.com//image/upload/c_fill,g_auto,f_auto,q_auto,w_580/v1688586960/Juice/Malaria_Juice.jpg"
    },
    {
      "name": "Typhoid",
      "image": "https://www.mdrcindia.com/uploads/blog/122023//251701689993.jpeg"
    },
    {
      "name": "Chikungunya",
      "image": "https://example.com/images/chikungunya.png"
    },
    {
      "name": "Hepatitis B",
      "image": "https://example.com/images/hepatitis_b.png"
    },
    {
      "name": "Tuberculosis",
      "image": "https://example.com/images/tuberculosis.png"
    },
    {
      "name": "Pneumonia",
      "image": "https://example.com/images/pneumonia.png"
    },
    {
      "name": "Asthma",
      "image": "https://example.com/images/asthma.png"
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
            // Trending Diseases Title
            Text(
              "Trending Diseases",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            // Disease List
            Expanded(
              child: ListView.builder(
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                          child: Image.network(
                            diseases[index]["image"]!,
                            width: 70,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 50, color: Colors.red);
                            },
                          ),
                        ),
                        title: Text(
                          diseases[index]["name"]!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text("Common disease in recent trends", style: TextStyle(fontSize: 14)),
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
