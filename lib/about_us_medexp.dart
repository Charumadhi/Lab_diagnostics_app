import 'package:flutter/material.dart';

class AboutMePage extends StatelessWidget {
  final Map<String, dynamic> doctorDetails;

  AboutMePage({required this.doctorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Me'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 290.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://as1.ftcdn.net/v2/jpg/04/37/24/36/1000_F_437243687_skMFHt5kDTenVygt3ZrrN7lI9aZSxpFg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.0),
                child: Center(
                  child: Text(
                    doctorDetails['name'],
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Name: ${doctorDetails['name']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Specialization: ${doctorDetails['specialization']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Experience: ${doctorDetails['experience']} years',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Qualifications: ${doctorDetails['qualifications']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Registrations: ${doctorDetails['registrations']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Working Hospital: ${doctorDetails['working_hospital']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Biography',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Dr. ${doctorDetails['name']} is a renowned specialist in ${doctorDetails['specialization']}. With over ${doctorDetails['experience']} years of experience in the medical field, Dr. ${doctorDetails['name']} has a proven track record of excellence in patient care and medical diagnostics. Holding qualifications in ${doctorDetails['qualifications']}, and registered with ${doctorDetails['registrations']}, Dr. ${doctorDetails['name']} is committed to providing the highest quality of healthcare services.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 290.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://img.freepik.com/free-vector/female-doctor-with-clipboard-elements_23-2147793134.jpg?t=st=1718344659~exp=1718348259~hmac=ef5bc75642375066b80a006f3cdcc82995c3598917c993dc9a3b1594dcf14954&w=740'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.0),
                      child: Center(
                        // Add additional details if needed
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.green[600]),
                              SizedBox(width: 10.0),
                              Text(
                                doctorDetails['email'],
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.green[600]),
                              SizedBox(width: 10.0),
                              Text(
                                doctorDetails['mobile'],
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.green[600]),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  doctorDetails['address'],
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage Example:
// Navigate to the AboutMePage with doctor details
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => AboutMePage(
//       doctorDetails: {
//         'name': 'Dr. Susila S',
//         'specialization': 'Neurology',
//         'experience': 8,
//         'qualifications': 'MD',
//         'registrations': 'Medical Council of India',
//         'working_hospital': 'Be Well Hospitals, Puducherry',
//         'email': 'susila87@gmail.com',
//         'mobile': '6388201937',
//         'address': 'No.78,3rd cross, Kamaraj salai, Puducherry',
//       },
//     ),
//   ),
// );

