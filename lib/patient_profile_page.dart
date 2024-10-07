import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class ProfilePatient extends StatefulWidget {
  final String email;

  ProfilePatient({required this.email});

  @override
  _ProfilePatientState createState() => _ProfilePatientState();
}

class _ProfilePatientState extends State<ProfilePatient> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _aadhaarNoController = TextEditingController();
  TextEditingController _maritalStatusController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _emergencyContactNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _smokingController = TextEditingController();
  TextEditingController _alcoholConsumptionController = TextEditingController();

  bool _isEditing = false;
  Map<String, dynamic> _currentPatientDetails = {}; // Initialize as an empty map

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    final apiUrl = 'http://10.0.2.2:3000/getPatientDetails';
    try {
      final response = await http.get(Uri.parse('$apiUrl?email=${widget.email}'), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _currentPatientDetails = data ?? {}; // Use empty map if data is null
          _nameController.text = _currentPatientDetails['name'] ?? '';
          _genderController.text = _currentPatientDetails['gender'] ?? '';
          _ageController.text = _currentPatientDetails['age']?.toString() ?? '';
          _mobileController.text = _currentPatientDetails['mobile_number'] ?? '';
          _emailController.text = _currentPatientDetails['email'] ?? '';
          // Assuming _currentPatientDetails['dob'] is '2004-04-04'
          DateTime dob = DateTime.parse(_currentPatientDetails['dob']); // Parses as UTC by default
          String formattedDob = DateFormat('yyyy-MM-dd').format(dob); // Formats to '2004-04-04' in local time zone
          _dobController.text = formattedDob;
          _heightController.text = _currentPatientDetails['height']?.toString() ?? '';
          _weightController.text = _currentPatientDetails['weight']?.toString() ?? '';
          _bloodGroupController.text = _currentPatientDetails['blood_group'] ?? '';
          _aadhaarNoController.text = _currentPatientDetails['aadhaar_no'] ?? '';
          _maritalStatusController.text = _currentPatientDetails['marital_status'] ?? '';
          _occupationController.text = _currentPatientDetails['occupation'] ?? '';
          _emergencyContactNoController.text = _currentPatientDetails['emergency_contact_no'] ?? '';
          _addressController.text = _currentPatientDetails['address'] ?? '';
          _smokingController.text = _currentPatientDetails['smoking'] == true ? 'Yes' : 'No';
          _alcoholConsumptionController.text = _currentPatientDetails['alcohol_consumption'] == true ? 'Yes' : 'No';
        });
      } else {
        print('Failed to load patient details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    final String apiUrl = 'http://10.0.2.2:3000/updatePatientProfile';

    // Validate and parse input for age, height, and weight
    int? age;
    double? height;
    double? weight;

    try {
      age = int.parse(_ageController.text);
      height = double.parse(_heightController.text);
      weight = double.parse(_weightController.text);
    } catch (e) {
      print('Error parsing age, height, or weight: $e');
      return; // Exit early if parsing fails
    }

    _currentPatientDetails['name'] = _nameController.text;
    _currentPatientDetails['gender'] = _genderController.text;
    _currentPatientDetails['age'] = age;
    _currentPatientDetails['mobile_number'] = _mobileController.text;
    _currentPatientDetails['dob'] = _dobController.text;
    _currentPatientDetails['height'] = height;
    _currentPatientDetails['weight'] = weight;
    _currentPatientDetails['blood_group'] = _bloodGroupController.text;
    _currentPatientDetails['aadhaar_no'] = _aadhaarNoController.text;
    _currentPatientDetails['marital_status'] = _maritalStatusController.text;
    _currentPatientDetails['occupation'] = _occupationController.text;
    _currentPatientDetails['emergency_contact_no'] = _emergencyContactNoController.text;
    _currentPatientDetails['address'] = _addressController.text;
    _currentPatientDetails['smoking'] = _smokingController.text.toLowerCase() == 'yes';
    _currentPatientDetails['alcohol_consumption'] = _alcoholConsumptionController.text.toLowerCase() == 'yes';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(_currentPatientDetails),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _toggleEditing();
        });
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Status code: ${response.statusCode}, Response: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: _currentPatientDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello ${_currentPatientDetails['name']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (in cm)'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (in kg)'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bloodGroupController,
              decoration: InputDecoration(labelText: 'Blood Group'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _aadhaarNoController,
              decoration: InputDecoration(labelText: 'Aadhaar Number'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _maritalStatusController,
              decoration: InputDecoration(labelText: 'Marital Status'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _occupationController,
              decoration: InputDecoration(labelText: 'Occupation'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emergencyContactNoController,
              decoration: InputDecoration(labelText: 'Emergency Contact Number'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _smokingController,
              decoration: InputDecoration(labelText: 'Smoking (Yes/No)'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _alcoholConsumptionController,
              decoration: InputDecoration(labelText: 'Alcohol Consumption (Yes/No)'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            if (_isEditing)
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
