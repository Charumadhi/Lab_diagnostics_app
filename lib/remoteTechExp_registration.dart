import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homePageTechnicalExpert.dart';

class RemoteTechExpRegistration extends StatefulWidget {
  @override
  _RemoteTechExpRegistrationState createState() => _RemoteTechExpRegistrationState();
}

class _RemoteTechExpRegistrationState extends State<RemoteTechExpRegistration> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _educationalQualificationController = TextEditingController();
  TextEditingController _workExperienceController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _dobController.dispose();
    _educationalQualificationController.dispose();
    _workExperienceController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final String apiUrl = 'http://10.0.2.2:3000/register_remote_technical_expert';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': _fullNameController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
        'email': _emailController.text,
        'mobile_number': _mobileNumberController.text,
        'dob': _dobController.text,
        'educational_qualification': _educationalQualificationController.text,
        'work_experience': _workExperienceController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Remote Technical Expert registered successfully')),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => homePageTechnicalExpert()),
      // );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      print('Failed to register remote technical expert. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register remote technical expert.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Technical Expert Registration'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
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
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _educationalQualificationController,
                decoration: InputDecoration(labelText: 'Educational Qualification'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _workExperienceController,
                decoration: InputDecoration(labelText: 'Work Experience (in years)'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
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
