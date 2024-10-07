import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientsPage extends StatefulWidget {
  final String medUniqueId;

  PatientsPage({required this.medUniqueId});

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _patients = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchPatients(widget.medUniqueId, _focusedDay);
  }

  Future<void> _fetchPatients(String medUniqueId, DateTime date) async {
    final formattedDate = date.toIso8601String().substring(0, 10);
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/api/patientsdatewise?med_unique_id=$medUniqueId&date=$formattedDate'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Print the entire response to debug

      final patients = (data['patients'] as List<dynamic>).map((patient) {
        return {
          'patient_name': patient['patient_name'], // Ensure 'patient_name' matches the field in backend response
          'time_slot': patient['time_slot'],
        };
      }).toList();

      setState(() {
        _patients[date] = patients;
      });
    } else {
      // Handle error
      print('Failed to load patients');
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
              _fetchPatients(widget.medUniqueId, selectedDay);
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
                          color: Colors.teal.shade900,
                        ),
                      ),
                      subtitle: Text(
                        'Time Slot: ${patient['time_slot']}',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Colors.teal.shade700,
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
