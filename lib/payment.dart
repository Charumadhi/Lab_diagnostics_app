import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'labSearchPage.dart';
import 'dart:convert';

class PaymentPage extends StatelessWidget {
  final Test test;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String labUniqueId; // Add labUniqueId parameter
  final String patientId;

  PaymentPage({
    required this.test,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.labUniqueId, // Update
    required this.patientId,
  });

  // Perform payment logic
  Future<bool> performPayment() async {
    // Simulate a payment process
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  // Create appointment function
  Future<void> createAppointment(String otp) async {
    try {
      // Extract hour and minute from selectedTimeSlot
      final List<String> timeParts = selectedTimeSlot.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(' ')[0]); // Remove ' AM' or ' PM'

      // Adjust hour for AM/PM
      if (selectedTimeSlot.contains('PM') && hour != 12) {
        hour += 12;
      } else if (selectedTimeSlot.contains('AM') && hour == 12) {
        hour = 0;
      }

      final DateTime appointmentDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/createAppointment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'testName': test.name,
          'testPrice': test.price,
          'appointmentDate': selectedDate.toIso8601String(),
          'timeSlot': selectedTimeSlot,
          'appointmentDateTime': appointmentDateTime.toIso8601String(), // Ensure this matches your backend expectation
          'labUniqueId': labUniqueId, // Add labUniqueId to the request body
          'patientId': patientId,
          'status': 'Booked',
          'otp': otp, // Add OTP to the request body
        }),
      );

      if (response.statusCode == 201) {
        print('Appointment created successfully');
      } else {
        print('Failed to create appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error inserting appointment: $e');
      // Handle the error as per your application's error handling strategy
    }
  }

  // Send OTP function
  Future<void> sendOTP() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/sendOTP'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'patientId': patientId,
        }),
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully');
      } else {
        print('Failed to send OTP. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      // Handle the error as per your application's error handling strategy
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Confirm booking by paying!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Amount: \₹ ${test.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Image.network(
                'https://img.freepik.com/free-vector/flat-design-payday-illustration_23-2151093389.jpg?t=st=1720109206~exp=1720112806~hmac=25a4d41c4c9b26556468efb60292abe9edc7f237a72c903232aa5a45e99febef&w=740',
                height: 400,
                width: 400,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool paymentSuccess = await performPayment();

                  if (paymentSuccess) {
                    await sendOTP();

                    TextEditingController otpController = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Enter OTP'),
                          content: TextField(
                            controller: otpController,
                            decoration: InputDecoration(hintText: "OTP"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                String enteredOtp = otpController.text;
                                await createAppointment(enteredOtp);

                                Navigator.of(context).pop(); // Close OTP dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Payment Successful'),
                                      content: Text('Your appointment has been booked successfully.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Handle payment failure
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  'PAY NOW',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
