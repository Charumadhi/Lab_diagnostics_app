import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homePagePatient.dart';  // Import the homePagePatient
import 'homePageMedicalExp.dart'; // Import the homePageMedicalExpert
import 'homePageTechnicalExpert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final String apiUrl = 'http://10.0.2.2:3000/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      String userType = '';
      String email = '';

      if (responseData.containsKey('type')) {
        userType = responseData['type'];
        email = responseData['user']['email']; // Get the user's email
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );

      // Navigate to the appropriate homepage based on user type
      if (userType == 'patients_buffer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePagePatient(email: email), // Use homePagePatient widget
          ),
        );
      } else if (userType == 'medical_experts_buffer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageMedicalExpert(email: email), // Pass email to homePageMedicalExpert
          ),
        );
      } else if (userType == 'technicalexperts_buffer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepagetechnicalexpert(email: email), // Pass email to homePageMedicalExpert
          ),
        );
        }else if (userType == 'remote_technical_experts_buffer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageMedicalExpert(email: email), // Pass email to homePageMedicalExpert
            ),
          );
        }  else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User type not supported')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 80.0),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
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