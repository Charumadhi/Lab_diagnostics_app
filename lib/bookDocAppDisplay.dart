import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookedAppointmentsPage extends StatelessWidget {
  final String patientId;

  BookedAppointmentsPage({required this.patientId});

  Future<List<Appointment>> fetchBookedAppointments() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/booked-appointments/$patientId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((appointment) => Appointment.fromJson(appointment)).toList();
    } else {
      throw Exception('Failed to load booked appointments');
    }
  }

  Future<void> cancelBooking(String patientId, String doctorName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/cancel-doc-booking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'patientId': patientId, 'doctorName': doctorName}),
    );

    if (response.statusCode == 200) {
      print('Booking cancelled and email notification sent');
    } else {
      print('Failed to cancel booking: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Appointments'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: fetchBookedAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No booked appointments found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      appointment.doctorName,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.0),
                        Text('Price: \₹300'),
                        SizedBox(height: 6.0),
                        Text('Date: ${appointment.date.toLocal()}'),
                        SizedBox(height: 6.0),
                        Text('Time: ${appointment.timeSlot}'),
                        SizedBox(height: 6.0),
                        Text('Address: ${appointment.address}'),
                        SizedBox(height: 6.0),
                        Text('Email: ${appointment.email}'),
                        SizedBox(height: 6.0),
                        Text('Mobile No: ${appointment.mobileNo}'),
                        SizedBox(height: 6.0),
                        Text(
                          'Status: ${appointment.status}',
                          style: TextStyle(
                            color: appointment.status == 'Booked' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: DateTime.now().isAfter(appointment.date)
                                ? null // Disable button if the appointment date has passed
                                : () async {
                              await cancelBooking(patientId, appointment.doctorName);
                            },
                            child: Text(
                              DateTime.now().isAfter(appointment.date) ? 'Done' : 'Cancel Booking',
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (DateTime.now().isAfter(appointment.date)) {
                                    return Colors.grey; // Set to grey if the appointment is done
                                  }
                                  return Theme.of(context).colorScheme.primary; // Default button color
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Appointment {
  final String id;
  final String doctorName;
  final DateTime date;
  final DateTime time;
  final String timeSlot;
  final String address;
  final String email;
  final String mobileNo;
  final String status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.timeSlot,
    required this.address,
    required this.email,
    required this.mobileNo,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? 'Unknown',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      timeSlot: json['timeSlot']?.toString() ?? 'N/A',
      address: json['address']?.toString() ?? 'N/A',
      email: json['email']?.toString() ?? 'N/A',
      mobileNo: json['mobileNo']?.toString() ?? 'N/A',
      status: json['status']?.toString() ?? 'N/A',
    );
  }
}
