import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PatientsViewPage extends StatefulWidget {
  final String labUniqueId;

  PatientsViewPage({required this.labUniqueId});

  @override
  _PatientsViewPageState createState() => _PatientsViewPageState();
}

class _PatientsViewPageState extends State<PatientsViewPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _patients = {};
  Map<String, bool> _uploadedReports = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchPatients(widget.labUniqueId, _focusedDay);
  }

  Future<void> _fetchPatients(String labUniqueId, DateTime date) async {
    final formattedDate = date.toIso8601String().substring(0, 10);
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/api/labpatientsdatewise?lab_unique_id=$labUniqueId&date=$formattedDate'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final patients = (data['patients'] as List<dynamic>).map((patient) {
        return {
          'patient_id': patient['patient_id'],
          'patient_name': patient['patient_name'],
          'test_id': patient['test_id'],
          'test_name': patient['test_name'],
          'test_price': patient['test_price'],
          'time_slot': patient['time_slot'],
          'patient_email': patient['patient_email'],
        };
      }).toList();

      setState(() {
        _patients[date] = patients;
      });

      print('Patients data for $formattedDate: ${_patients[date]}'); // Debug print
    } else {
      // Handle error
      print('Failed to load patients');
    }
  }

  Future<void> _uploadReport(String? patientId, String? testId, String labUniqueId) async {
    if (patientId == null || testId == null) {
      print('Invalid patient or test ID');
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:3000/uploadReport'),
      );
      request.fields['patient_id'] = patientId;
      request.fields['lab_unique_id'] = labUniqueId;
      request.fields['test_id'] = testId;
      request.files.add(await http.MultipartFile.fromPath('report', file.path));

      try {
        var response = await request.send();
        if (response.statusCode == 201) {
          // Extract the report URL from the response body
          final responseJson = json.decode(await response.stream.bytesToString());
          final reportUrl = responseJson['report']['report_url'];

          setState(() {
            _uploadedReports[patientId] = true; // Update uploaded status
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Report uploaded successfully')),
          );

          // Store the report URL in your local storage or state for future use
          // Optionally, you can update the _patients map with the new report URL
          // or fetch updated patient data from the server to include the report URL
          print('Report uploaded successfully with URL: $reportUrl');
        } else {
          print('Failed to upload report');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('No file selected');
    }
  }

  List<Map<String, dynamic>> _getPatientsForDay(DateTime day) {
    return _patients[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchPatients(widget.labUniqueId, selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.teal,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.teal,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _getPatientsForDay(_selectedDay ?? _focusedDay).length,
                itemBuilder: (context, index) {
                  final patient = _getPatientsForDay(_selectedDay ?? _focusedDay)[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        'Name: ${patient['patient_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test: ${patient['test_name']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Price: ${patient['test_price']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Time Slot: ${patient['time_slot']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Email: ${patient['patient_email']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Colors.teal.shade700,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (patient['patient_id'] != null && patient['test_id'] != null) {
                            _uploadReport(patient['patient_id'], patient['test_id'], widget.labUniqueId);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid patient or test ID')),
                            );
                            print(patient['patient_id']);
                            print(patient['test_id']);
                          }
                        },
                        child: Text(_uploadedReports[patient['patient_id']] == true ? 'Uploaded' : 'Upload Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PatientsViewPage(labUniqueId: 'exampleLabId'),
  ));
}
