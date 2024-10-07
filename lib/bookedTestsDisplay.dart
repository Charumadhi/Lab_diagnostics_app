import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookedTestsPage extends StatelessWidget {
  final String patientId;

  BookedTestsPage({required this.patientId});

  Future<List<Appointment>> fetchBookedAppointments() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/booked-tests/$patientId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((appointment) => Appointment.fromJson(appointment)).toList();
    } else {
      throw Exception('Failed to load booked appointments');
    }
  }

  Future<void> cancelBooking(String patientId, String testName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/cancel-booking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'patientId': patientId, 'testName': testName}),
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
        title: Text('Booked Tests'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: fetchBookedAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Appointment> allAppointments = snapshot.data ?? [];
            if (allAppointments.isEmpty) {
              return Center(child: Text('No booked tests found.'));
            } else {
              return ListView.builder(
                itemCount: allAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = allAppointments[index];
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      title: Text(
                        '${appointment.labName}',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Test: ${appointment.testName}'),
                              Text('Price: \₹${appointment.testPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          SizedBox(height: 6.0),
                          Text('Lab Address: ${appointment.labAddress}'),
                          SizedBox(height: 6.0),
                          Text('Lab Mobile: ${appointment.labMobile}'),
                          SizedBox(height: 6.0),
                          Text('Appointment Date: ${appointment.appointmentDate.toLocal()}'),
                          SizedBox(height: 6.0),
                          Text('Time Slot: ${appointment.timeSlot}'),
                          SizedBox(height: 6.0),
                          Text('Appointment Time: ${appointment.appointmentTime.toLocal()}'),
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
                              onPressed: DateTime.now().isAfter(appointment.appointmentDate)
                                  ? null // Disable button if the appointment date has passed
                                  : () async {
                                await cancelBooking(patientId, appointment.testName);
                              },
                              child: Text(
                                DateTime.now().isAfter(appointment.appointmentDate) ? 'Done' : 'Cancel Booking',
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (DateTime.now().isAfter(appointment.appointmentDate)) {
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
          }
        },
      ),
    );
  }
}

class Appointment {
  final String testName;
  final String labName;
  final double testPrice;
  final String labAddress;
  final String labMobile;
  final String status;
  final DateTime appointmentDate;
  final String timeSlot;
  final DateTime appointmentTime;

  Appointment({
    required this.testName,
    required this.labName,
    required this.testPrice,
    required this.labAddress,
    required this.labMobile,
    required this.status,
    required this.appointmentDate,
    required this.timeSlot,
    required this.appointmentTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      testName: json['test_name'] ?? '',
      labName: json['lab_name'] ?? '',
      testPrice: double.parse(json['test_price'].toString()) ?? 0.0,
      labAddress: json['address'] ?? '',
      labMobile: json['mobile_no'] ?? '',
      status: json['status'] ?? '',
      appointmentDate: DateTime.parse(json['appointment_date'] ?? DateTime.now().toIso8601String()),
      timeSlot: json['time_slot'] ?? '',
      appointmentTime: DateTime.parse(json['appointment_time'] ?? DateTime.now().toIso8601String()),
    );
  }
}
