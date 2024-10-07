import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MEFormFirstPage extends StatefulWidget {
  @override
  _MEFormFirstPageState createState() => _MEFormFirstPageState();
}

class _MEFormFirstPageState extends State<MEFormFirstPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Expert Form'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: <String>['Male', 'Female', 'Transgender']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _specializationController,
                decoration: InputDecoration(labelText: 'Who are you? (Specialization)'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: 'Years of Experience'),
              ),
              SizedBox(height: 110.0),
              ElevatedButton(
                onPressed: () {
                  int? age = int.tryParse(_ageController.text.trim());
                  int? experience = int.tryParse(_experienceController.text.trim());

                  if (age == null || experience == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter valid age and years of experience.'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MEFormSecondPage(
                          name: _nameController.text,
                          age: age,
                          gender: _selectedGender!,
                          mobile: _mobileController.text,
                          email: _emailController.text,
                          dob: _dobController.text,
                          specialization: _specializationController.text,
                          experience: experience,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MEFormSecondPage extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String mobile;
  final String email;
  final String dob;
  final String specialization;
  final int experience;

  MEFormSecondPage({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.specialization,
    required this.experience,
  });

  @override
  _MEFormSecondPageState createState() => _MEFormSecondPageState();
}

class _MEFormSecondPageState extends State<MEFormSecondPage> {
  TextEditingController _qualificationsController = TextEditingController();
  TextEditingController _registrationsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _workingHospitalController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _qualificationsController.dispose();
    _registrationsController.dispose();
    _addressController.dispose();
    _workingHospitalController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final String apiUrl = 'http://10.0.2.2:3000/register_medical_expert';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': widget.name,
        'age': widget.age,
        'gender': widget.gender,
        'mobile': widget.mobile,
        'email': widget.email,
        'dob': widget.dob,
        'specialization': widget.specialization,
        'experience': widget.experience,
        'qualifications': _qualificationsController.text,
        'registrations': _registrationsController.text,
        'address': _addressController.text,
        'working_hospital': _workingHospitalController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medical Expert registered successfully')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      print('Failed to register patient. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register patient. Status code: ${response.statusCode}, Response: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Expert Form'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _qualificationsController,
                decoration: InputDecoration(labelText: 'Qualifications'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _registrationsController,
                decoration: InputDecoration(labelText: 'Registrations'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _workingHospitalController,
                decoration: InputDecoration(labelText: 'Working hospital'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 300.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}