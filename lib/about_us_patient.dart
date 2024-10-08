import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
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
                      'https://img.freepik.com/free-vector/organic-flat-doctors-nurses_23-2148912164.jpg?t=st=1718126098~exp=1718129698~hmac=d6e53c162aa3f3286b51c0bce36b0aea63c3e432d24b876f357608875313a177&w=996'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.0),
                child: Center(
                  // child: Text(
                  //   'About Our App',
                  //   style: TextStyle(
                  //     fontSize: 36.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About DiagnoCare',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'DiagnoCare is a healthcare platform dedicated to providing cost-effective, '
                        'remote-enabled diagnostic services. Based in Chennai, DiagnoCare connects '
                        'patients with over 250 accredited diagnostic labs across India. Our state-of-the-art platform, '
                        'powered by advanced data science and AI tools, offers access to a wide range of '
                        'diagnostic tests and wellness programs. With a team of expert clinical professionals, '
                        'DiagnoCare ensures accurate and timely results for over 30 million tests annually, '
                        'helping you manage your health efficiently from the comfort of your home.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Our Vision',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Our vision is to revolutionize healthcare by integrating '
                        'cutting-edge diagnostics with data science and AI, '
                        'making quality healthcare accessible to everyone. '
                        'We strive to be a global leader in diagnostic services, '
                        'fostering a healthier and more informed society.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Our mission is to deliver cost-effective and accessible '
                        'diagnostic services through advanced technology and '
                        'expert clinical professionals. We aim to empower '
                        'patients with timely and accurate health information, '
                        'enabling better health management from the comfort of their homes.',
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
                            'https://img.freepik.com/free-photo/examining-sample-with-microscope_1098-18424.jpg?t=st=1718130190~exp=1718133790~hmac=2b765ececae1581ea81711f64db028095795c63dd3a47d19776a1396518ce7ba&w=996'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.0),
                      child: Center(
                        // child: Text(
                        //   'About Our App',
                        //   style: TextStyle(
                        //     fontSize: 36.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• Easy lab search based on location and cost.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '• Detailed information about lab tests and pricing.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '• User-friendly interface for both patients and medical professionals.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '• Secure and confidential handling of medical information.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '• 24/7 customer support.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Contact Us',
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
                          Text(
                            'If you have any questions or need assistance, please contact us at:',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.green[600]),
                              SizedBox(width: 10.0),
                              Text(
                                'support@healthcareapp.com',
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
                                '+91 9755372901',
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
                                  '34, 2nd cross, Annai salai, Puducherry - 605001.',
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
