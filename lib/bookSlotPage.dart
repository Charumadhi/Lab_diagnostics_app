import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'labSearchPage.dart';
import 'payment.dart';
import 'main.dart';

class BookSlotPage extends StatefulWidget {
  final Test test;
  final String labUniqueId; // Add labUniqueId parameter
  final String patientId;

  BookSlotPage({required this.test, required this.labUniqueId, required this.patientId});

  @override
  _BookSlotPageState createState() => _BookSlotPageState();
}

class _BookSlotPageState extends State<BookSlotPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String _selectedTimeSlot = '';
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Slot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                '${widget.test.name}\n\₹${widget.test.price.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2101),
              focusedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot select a date before today!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                }
              },
             onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Week',
                CalendarFormat.twoWeeks: 'Month',
                CalendarFormat.week: '2 weeks',
              },
            ),
            SizedBox(height: 50),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                _timeSlotButton('07:30 am - 8.30 pm'),
                ],
            ),
            SizedBox(height: 14), // Add spacing to ensure the button is visible
            ElevatedButton(
              onPressed: _selectedTimeSlot.isEmpty ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      test: widget.test,
                      selectedDate: _selectedDay,
                      selectedTimeSlot: _selectedTimeSlot,
                      labUniqueId: widget.labUniqueId,
                      patientId: widget.patientId, // Pass patientId here
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo, // Button background color
                foregroundColor: Colors.white, // Button text color
                shadowColor: Colors.blueAccent, // Shadow color
                elevation: 5, // Elevation to create a shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), // Padding inside the button
              ),
              child: Text(
                'BOOK NOW',
                style: TextStyle(
                  fontSize: 18.0, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                  letterSpacing: 1.5, // Letter spacing
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeSlotButton(String time) {
    bool isSelected = _selectedTimeSlot == time;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedTimeSlot = time;
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: isSelected ? Colors.indigo : Colors.teal),
        ),
        backgroundColor: isSelected ? Colors.indigo : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
