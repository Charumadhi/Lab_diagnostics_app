import 'package:flutter/material.dart';
import 'login_page.dart';
import 'patient_registration.dart';
import 'medical_expert_registration.dart';
import 'techExp_registration.dart';
import 'remoteTechExp_registration.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase initialization
  runApp(MyApp());
}

// void main() {
//   runApp(MaterialApp(
//     home: HomePage(),
//   ));
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://i.pinimg.com/originals/b9/78/12/b97812e00c6a6e664e57c401d70ee36c.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'DiagnoCare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'YourFontFamily',
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24.0,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                  underline: Container(),
                  hint: Text(
                    '  Create account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  items: <String>[
                    'Medical expert',
                    'Technical expert',
                    'Patient',
                    'Remote Technical expert',
                    ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == 'Patient') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientFormFirstPage()),
                      );
                    } else if (newValue == 'Medical expert') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MEFormFirstPage()),
                      );
                    } else if (newValue == 'Technical expert') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TechnicalExpertForm()),
                      );
                    } else if (newValue == 'Remote Technical expert') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RemoteTechExpRegistration()),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 100.0),
            ],
          ),
        ],
      ),
    );
  }
}
