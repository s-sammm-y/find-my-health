import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package

class CityHospitalList extends StatefulWidget {
  final String cityName;
  final bool noHospitalsAvailable; // New parameter to handle when no hospitals are available

  const CityHospitalList({
    Key? key,
    required this.cityName,
    this.noHospitalsAvailable = false,
  }) : super(key: key);

  @override
  _CityHospitalListState createState() => _CityHospitalListState();
}

class _CityHospitalListState extends State<CityHospitalList> {
  final SupabaseClient _supabase = Supabase.instance.client; // Initialize Supabase client
  List<dynamic> _hospitals = []; // To store hospitals fetched from the database
  bool _isLoading = true; // For showing a loading spinner
  bool _hasError = false; // For error handling

  @override
  void initState() {
    super.initState();
    _fetchHospitals(); // Fetch hospitals when the screen is initialized
  }

  // Function to fetch hospitals from the Supabase database based on the selected city
  Future<void> _fetchHospitals() async {
    try {
      final response = await _supabase
          .from('hospitals') // Assuming your table is named 'hospitals'
          .select()
          .eq('city', widget.cityName); // Match city with the cityName

      // Check if data is available
      if (response.isNotEmpty) {
        setState(() {
          _hospitals = response; // Store the hospital data
          _isLoading = false; // Stop showing loading spinner
        });
      } else {
        // If no hospitals available, handle it
        setState(() {
          _hospitals = [];
          _isLoading = false; // Stop loading
        });
      }
    } catch (error) {
      print('Error fetching hospitals: $error');
      setState(() {
        _isLoading = false;
        _hasError = true; // Set error flag
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals in ${widget.cityName}'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner while fetching data
            )
          : _hasError
              ? const Center(
                  child: Text('Error loading hospitals. Please try again later.'),
                )
              : _hospitals.isEmpty
                  ? Center(
                      child: Text(
                        'No Hospitals Available in ${widget.cityName}',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _hospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = _hospitals[index];
                        return ListTile(
                          title: Text(hospital['name']), // Assuming 'name' is a column in your hospitals table
                          subtitle: Text(hospital['address'] ?? 'Adress not available'), // Assuming 'address' is a column
                        );
                      },
                    ),
    );
  }
}
