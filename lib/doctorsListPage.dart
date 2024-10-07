import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bookDocSlotPage.dart';

class DoctorsListPage extends StatefulWidget {
  final String specialization;
  final String patientId;

  DoctorsListPage({required this.specialization, required this.patientId});

  @override
  _DoctorsListPageState createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  late Future<List<Map<String, dynamic>>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/doctors?specialization=${widget.specialization}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> doctors =
        List<Map<String, dynamic>>.from(json.decode(response.body));
        return doctors;
      } else {
        throw Exception('Failed to load doctors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.specialization),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No doctors found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final doctor = snapshot.data![index];
                return DoctorCard(
                  name: doctor['name'] ?? 'Unknown',
                  hospital: doctor['working_hospital'] ?? 'Unknown Hospital',
                  phone: doctor['mobile'] ?? 'N/A',
                  email: doctor['email'] ?? 'N/A',
                  specialization: doctor['specialization'] ?? 'N/A',
                  registrations: doctor['registrations'] ?? 'N/A',
                  imageUrl: 'https://img.freepik.com/premium-photo/dentist-digital-avatar-generative-ai_934475-9219.jpg?w=740',
                  meduniqid: doctor['unique_id'] ?? 'N/A',
                  patientId: widget.patientId,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String hospital;
  final String phone;
  final String email;
  final String specialization;
  final String registrations;
  final String imageUrl;
  final String meduniqid;
  final String patientId;

  DoctorCard({
    required this.name,
    required this.hospital,
    required this.phone,
    required this.email,
    required this.specialization,
    required this.registrations,
    required this.imageUrl,
    required this.meduniqid,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    specialization,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hospital: $hospital',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: $phone',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Registrations: $registrations',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add appointment booking functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDocSlotPage(patientId: patientId, meduniqid: meduniqid),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Make an appointment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
