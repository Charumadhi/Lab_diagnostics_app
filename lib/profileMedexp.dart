import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ProfileMedExp extends StatefulWidget {
  final String email;

  ProfileMedExp({required this.email});

  @override
  _ProfileMedExpState createState() => _ProfileMedExpState();
}

class _ProfileMedExpState extends State<ProfileMedExp> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _qualificationsController = TextEditingController();
  TextEditingController _registrationsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _workingHospitalController = TextEditingController();

  bool _isEditing = false;
  Map<String, dynamic> _currentDoctorDetails = {};

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    final apiUrl = 'http://10.0.2.2:3000/getDoctorDetails';
    try {
      final response = await http.get(Uri.parse('$apiUrl?email=${widget.email}'), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _currentDoctorDetails = data ?? {};
          _nameController.text = _currentDoctorDetails['name'] ?? '';
          _ageController.text = _currentDoctorDetails['age']?.toString() ?? '';
          _mobileController.text = _currentDoctorDetails['mobile'] ?? '';
          _emailController.text = _currentDoctorDetails['email'] ?? '';
          String dob = _currentDoctorDetails['dob'] ?? '';
          if (dob.isNotEmpty) {
            DateTime dobDate = DateTime.parse(dob);
            String formattedDob = DateFormat('yyyy-MM-dd').format(dobDate);
            _dobController.text = formattedDob;
          } else {
            _dobController.text = '';
          }
          _specializationController.text = _currentDoctorDetails['specialization'] ?? '';
          _experienceController.text = _currentDoctorDetails['experience']?.toString() ?? '';
          _qualificationsController.text = _currentDoctorDetails['qualifications'] ?? '';
          _registrationsController.text = _currentDoctorDetails['registrations'] ?? '';
          _addressController.text = _currentDoctorDetails['address'] ?? '';
          _workingHospitalController.text = _currentDoctorDetails['working_hospital'] ?? '';
        });
      } else {
        print('Failed to load doctor details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    final String apiUrl = 'http://10.0.2.2:3000/updateDoctorProfile';

    int? age;
    int? experience;

    try {
      age = int.parse(_ageController.text);
    } catch (e) {
      print('Error parsing age: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid age format')),
      );
      return;
    }

    try {
      experience = int.parse(_experienceController.text);
    } catch (e) {
      print('Error parsing experience: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid experience format')),
      );
      return;
    }

    _currentDoctorDetails['name'] = _nameController.text;
    _currentDoctorDetails['age'] = age;
    _currentDoctorDetails['mobile'] = _mobileController.text;
    _currentDoctorDetails['dob'] = _dobController.text;
    _currentDoctorDetails['specialization'] = _specializationController.text;
    _currentDoctorDetails['experience'] = experience;
    _currentDoctorDetails['qualifications'] = _qualificationsController.text;
    _currentDoctorDetails['registrations'] = _registrationsController.text;
    _currentDoctorDetails['address'] = _addressController.text;
    _currentDoctorDetails['working_hospital'] = _workingHospitalController.text;

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(_currentDoctorDetails),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while updating the profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: _currentDoctorDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello ${_currentDoctorDetails['name']}',
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
              controller: _specializationController,
              decoration: InputDecoration(labelText: 'Specialization'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _experienceController,
              decoration: InputDecoration(labelText: 'Years of Experience'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _qualificationsController,
              decoration: InputDecoration(labelText: 'Qualifications'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _registrationsController,
              decoration: InputDecoration(labelText: 'Registrations'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _workingHospitalController,
              decoration: InputDecoration(labelText: 'Working Hospital'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
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
