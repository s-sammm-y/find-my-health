import 'package:flutter/material.dart';
import 'package:health_sync/hospital_list/doctors.list.dart';
 // Import DoctorsList page
import 'package:supabase_flutter/supabase_flutter.dart'; 

class CityHospitalList extends StatefulWidget {
  final String cityName;
  final bool noHospitalsAvailable;

  const CityHospitalList({
    Key? key,
    required this.cityName,
    this.noHospitalsAvailable = false,
  }) : super(key: key);

  @override
  _CityHospitalListState createState() => _CityHospitalListState();
}

class _CityHospitalListState extends State<CityHospitalList> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> _hospitals = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  Future<void> _fetchHospitals() async {
    try {
      final response = await _supabase
          .from('hospitals')
          .select()
          .eq('city', widget.cityName);

      if (response.isNotEmpty) {
        setState(() {
          _hospitals = response;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hospitals = [];
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching hospitals: $error');
      setState(() {
        _isLoading = false;
        _hasError = true;
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
              child: CircularProgressIndicator(),
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
                          title: Text(hospital['name']),
                          subtitle: Text(hospital['address'] ?? 'Address not available'),
                          onTap: () {
                            // Navigate to DoctorsList page and pass the selected hospital
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorsList(
                                  hospitalName: hospital['name'],
                                  cityName: widget.cityName, // Pass city name
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}
