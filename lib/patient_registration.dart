// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uuid/uuid.dart';
// import 'homePagePatient.dart';
//
// class PatientFormFirstPage extends StatefulWidget {
//   @override
//   _PatientFormFirstPageState createState() => _PatientFormFirstPageState();
// }
//
// class _PatientFormFirstPageState extends State<PatientFormFirstPage> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _ageController = TextEditingController();
//   TextEditingController _mobileController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _dobController = TextEditingController();
//   TextEditingController _heightController = TextEditingController();
//   TextEditingController _weightController = TextEditingController();
//   String? _selectedGender;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _dobController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient Form'),
//         backgroundColor: Colors.green[600],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _ageController,
//                 decoration: InputDecoration(labelText: 'Age'),
//               ),
//               SizedBox(height: 16.0),
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedGender = newValue!;
//                   });
//                 },
//                 items: <String>['Male', 'Female', 'Transgender']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 decoration: InputDecoration(labelText: 'Gender'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _mobileController,
//                 decoration: InputDecoration(labelText: 'Mobile Number'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _dobController,
//                 decoration: InputDecoration(labelText: 'Date of Birth'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _heightController,
//                 decoration: InputDecoration(labelText: 'Height (in cm)'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _weightController,
//                 decoration: InputDecoration(labelText: 'Weight (in kg)'),
//               ),
//               SizedBox(height: 100.0),
//               ElevatedButton(
//                 onPressed: () {
//                   int? age = int.tryParse(_ageController.text.trim());
//                   double? height = double.tryParse(_heightController.text);
//                   double? weight = double.tryParse(_weightController.text);
//
//                   if (age == null || height == null || weight == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Please enter valid age, height, and weight.'),
//                       ),
//                     );
//                   } else {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PatientFormSecondPage(
//                           id: Uuid().v4(), // Generate a unique ID
//                           name: _nameController.text,
//                           age: age,
//                           gender: _selectedGender!,
//                           mobile: _mobileController.text,
//                           email: _emailController.text,
//                           dob: _dobController.text,
//                           height: height,
//                           weight: weight,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text(
//                   'Next',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green[600],
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PatientFormSecondPage extends StatefulWidget {
//   final String id; // Unique ID
//   final String name;
//   final int age;
//   final String gender;
//   final String mobile;
//   final String email;
//   final String dob;
//   final double height;
//   final double weight;
//
//   PatientFormSecondPage({
//     required this.id,
//     required this.name,
//     required this.age,
//     required this.gender,
//     required this.mobile,
//     required this.email,
//     required this.dob,
//     required this.height,
//     required this.weight,
//   });
//
//   @override
//   _PatientFormSecondPageState createState() => _PatientFormSecondPageState();
// }
//
// class _PatientFormSecondPageState extends State<PatientFormSecondPage> {
//   TextEditingController _aadhaarController = TextEditingController();
//   TextEditingController _bloodGroupController = TextEditingController();
//   TextEditingController _maritalStatusController = TextEditingController();
//   TextEditingController _occupationController = TextEditingController();
//   TextEditingController _emergencyContactController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _smokingController = TextEditingController();
//   TextEditingController _alcoholController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _aadhaarController.dispose();
//     _bloodGroupController.dispose();
//     _maritalStatusController.dispose();
//     _occupationController.dispose();
//     _emergencyContactController.dispose();
//     _addressController.dispose();
//     _smokingController.dispose();
//     _alcoholController.dispose();
//     super.dispose();
//   }
//
//   void _submitForm() async {
//     final String apiUrl = 'http://10.0.2.2:3000/register_patient';
//
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'name': widget.name,
//         'age': widget.age,
//         'gender': widget.gender,
//         'mobile_number': widget.mobile, // Change to 'mobile_number'
//         'email': widget.email,
//         'dob': widget.dob,
//         'height': widget.height,
//         'weight': widget.weight,
//         'aadhaar_no': _aadhaarController.text,
//         'blood_group': _bloodGroupController.text,
//         'marital_status': _maritalStatusController.text,
//         'occupation': _occupationController.text,
//         'emergency_contact_no': _emergencyContactController.text,
//         'address': _addressController.text,
//         'smoking': _smokingController.text,
//         'alcohol_consumption': _alcoholController.text,
//         'password': _passwordController.text
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Patient registered successfully')),
//       );
//       String email = "";
//       // Navigate to homePagePatient
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePagePatient(email: email)),
//       );
//       Navigator.popUntil(context, (route) => route.isFirst);
//     } else {
//       print('Failed to register patient. Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to register patient. Status code: ${response.statusCode}, Response: ${response.body}')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         title: Text('Patient Form'),
//           backgroundColor: Colors.green[600],
//         ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: _aadhaarController,
//                 decoration: InputDecoration(labelText: 'Aadhaar Number'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _bloodGroupController,
//                 decoration: InputDecoration(labelText: 'Blood Group'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _maritalStatusController,
//                 decoration: InputDecoration(labelText: 'Marital Status'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _occupationController,
//                 decoration: InputDecoration(labelText: 'Occupation'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _emergencyContactController,
//                 decoration: InputDecoration(labelText: 'Emergency Contact Number'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _addressController,
//                 decoration: InputDecoration(labelText: 'Address'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _smokingController,
//                 decoration: InputDecoration(labelText: 'Smoking (Yes/No)'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _alcoholController,
//                 decoration: InputDecoration(labelText: 'Alcohol Consumption (Yes/No)'),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//               ),
//               SizedBox(height: 40.0),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text(
//                   'Register',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green[600],
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:uuid/uuid.dart';
import 'homePagePatient.dart';

class PatientFormFirstPage extends StatefulWidget {
  @override
  _PatientFormFirstPageState createState() => _PatientFormFirstPageState();
}

class _PatientFormFirstPageState extends State<PatientFormFirstPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Form'),
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
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (in cm)'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (in kg)'),
              ),
              SizedBox(height: 100.0),
              ElevatedButton(
                onPressed: () {
                  int? age = int.tryParse(_ageController.text.trim());
                  double? height = double.tryParse(_heightController.text);
                  double? weight = double.tryParse(_weightController.text);

                  if (age == null || height == null || weight == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter valid age, height, and weight.'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientFormSecondPage(
                          id: Uuid().v4(), // Generate a unique ID
                          name: _nameController.text,
                          age: age,
                          gender: _selectedGender!,
                          mobile: _mobileController.text,
                          email: _emailController.text,
                          dob: _dobController.text,
                          height: height,
                          weight: weight,
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

class PatientFormSecondPage extends StatefulWidget {
  final String id; // Unique ID
  final String name;
  final int age;
  final String gender;
  final String mobile;
  final String email;
  final String dob;
  final double height;
  final double weight;

  PatientFormSecondPage({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.height,
    required this.weight,
  });

  @override
  _PatientFormSecondPageState createState() => _PatientFormSecondPageState();
}

class _PatientFormSecondPageState extends State<PatientFormSecondPage> {
  TextEditingController _aadhaarController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _maritalStatusController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _emergencyContactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _smokingController = TextEditingController();
  TextEditingController _alcoholController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _aadhaarController.dispose();
    _bloodGroupController.dispose();
    _maritalStatusController.dispose();
    _occupationController.dispose();
    _emergencyContactController.dispose();
    _addressController.dispose();
    _smokingController.dispose();
    _alcoholController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Storing in Firestore
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('patients').doc(widget.id).set({
        'id': widget.id,
        'name': widget.name,
        'age': widget.age,
        'gender': widget.gender,
        'mobile_number': widget.mobile,
        'email': widget.email,
        'dob': widget.dob,
        'height': widget.height,
        'weight': widget.weight,
        'aadhaar_no': _aadhaarController.text,
        'blood_group': _bloodGroupController.text,
        'marital_status': _maritalStatusController.text,
        'occupation': _occupationController.text,
        'emergency_contact_no': _emergencyContactController.text,
        'address': _addressController.text,
        'smoking': _smokingController.text,
        'alcohol_consumption': _alcoholController.text,
        'password': _passwordController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient registered successfully')),
      );
      String email = "";
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePagePatient(email: email)),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register patient: $e')),
      );
      print('Failed to register patient: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Form'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _aadhaarController,
                decoration: InputDecoration(labelText: 'Aadhaar Number'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _bloodGroupController,
                decoration: InputDecoration(labelText: 'Blood Group'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _maritalStatusController,
                decoration: InputDecoration(labelText: 'Marital Status'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _occupationController,
                decoration: InputDecoration(labelText: 'Occupation'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emergencyContactController,
                decoration: InputDecoration(labelText: 'Emergency Contact Number'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _smokingController,
                decoration: InputDecoration(labelText: 'Smoking Habit (Yes/No)'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _alcoholController,
                decoration: InputDecoration(labelText: 'Alcohol Consumption (Yes/No)'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Register',
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
