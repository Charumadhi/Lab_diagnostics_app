import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportsPage extends StatefulWidget {
  final String patientId;

  ReportsPage({required this.patientId});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List _reports = [];

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/getReports?patient_id=${widget.patientId}'));

      if (response.statusCode == 200) {
        setState(() {
          _reports = json.decode(response.body);
        });
        print(_reports);
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reports')),
      );
    }
  }

  Future<void> _downloadReport(String? reportUrl) async {
    if (reportUrl == null || reportUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report URL is not available')),
      );
      return;
    }

    try {
      if (await canLaunch(reportUrl)) {
        await launch(reportUrl);
      } else {
        throw 'Could not launch $reportUrl';
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reports'),
      ),
      body: _reports.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(report['test_name'] ?? 'Test Name Not Available'),
              subtitle: Text(report['lab_name'] ?? 'Lab Name Not Available'),
              trailing: ElevatedButton(
                onPressed: () => _downloadReport(report['report_url']),
                child: Text('Download Report'),
              ),
            ),
          );
        },
      ),
    );
  }
}
