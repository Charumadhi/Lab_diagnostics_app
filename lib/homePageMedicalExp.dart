import 'package:flutter/material.dart';
import 'about_us_medexp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profileMedexp.dart';
import 'patientsDocDiisplay.dart';
import 'health_risk_detail_page.dart';
import 'main.dart';

class HomePageMedicalExpert extends StatefulWidget {
  final String email;

  HomePageMedicalExpert({required this.email});

  @override
  _HomePageMedicalExpertState createState() => _HomePageMedicalExpertState();
}

class _HomePageMedicalExpertState extends State<HomePageMedicalExpert> {
  String _doctorName = 'Unknown';
  String _doctorUniqId = 'Unknown';
  Map<String, dynamic>? doctorDetails;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/getDoctorDetails?email=${widget.email}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _doctorName = data['name'] ?? 'Doctor';
          _doctorUniqId = data['unique_id'] ?? 'Unique Id';
          doctorDetails = data; // Populate doctorDetails map
        });
      } else {
        throw Exception('Failed to load doctor details');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load doctor details')),
      );
    }
  }

  Future<void> _navigateToAboutMe(BuildContext context) async {
    try {
      await fetchDoctorDetails(); // Wait for doctor details to be fetched
      // Log the state of doctorDetails before attempting navigation
      print('Navigating to AboutMePage with doctorDetails: $doctorDetails');

      if (doctorDetails != null) {
        // Attempt to navigate to AboutMePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutMePage(doctorDetails: doctorDetails!),
          ),
        );
      } else {
        // doctorDetails is null, show a Snackbar
        print('doctorDetails is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load doctor details')),
        );
      }
    } catch (error, stackTrace) {
      // Log the error and stack trace for better debugging
      print('Error during navigation: $error');
      print('Stack trace: $stackTrace');

      // Show a Snackbar indicating the failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load doctor details')),
      );
    }
  }


  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileMedExp(email: widget.email),
      ),
    );
  }


  void _navigateToTestPage(BuildContext context, String testName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestPage(testName: testName),
      ),
    );
  }

  void _navigateToAllTests(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllTestsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://img.freepik.com/premium-vector/foot-care-with-cardiogram-logo-designs-medical-service_1093924-329.jpg?w=826',
              height: 40.0,
              width: 40.0,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                print('Failed to load app bar logo: $exception');
                return Icon(Icons.error);
              },
            ),
            SizedBox(width: 5),
            Text('DiagnoCare'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_alert),
              title: Text('Appointments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientsPage(medUniqueId: _doctorUniqId)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Me'),
              onTap: () => _navigateToAboutMe(context),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () => _navigateToProfile(context),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Dr. $_doctorName, ($_doctorUniqId)',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 20.0),
                  Image.network(
                    'https://static.vecteezy.com/system/resources/previews/005/607/844/original/group-of-medical-students-doing-lab-experiments-isolated-flat-illustration-cartoon-scientist-doing-research-or-chemical-test-concept-of-chemistry-medicine-and-science-free-vector.jpg',
                    height: 350.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 50),
                          SizedBox(height: 10),
                          Text(
                            'Image failed to load',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tests',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _navigateToAllTests(context),
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing before the footer
                  _buildTestCard(context, 'CBC (Complete Blood Count) Haemogram test', 'https://img.freepik.com/free-photo/rubber-gloved-hand-holds-one-test-tube-with-drug_1153-3908.jpg?t=st=1718988926~exp=1718992526~hmac=f31963ae7ccebd53cf80f6b41f17bd5313d1a6e7352225c1e1d63b5e8d7fbad2&w=1060'),
                  _buildTestCard(context, 'X-Ray', 'https://img.freepik.com/free-photo/doctor-patient-watching-x-ray_23-2147763763.jpg?t=st=1718990608~exp=1718994208~hmac=73809aae2b7dd6189003b985609400424c1d5780d419d4691a0a93bd7cb565fc&w=996'),
                  _buildTestCard(context, 'MRI', 'https://img.freepik.com/free-photo/doctor-getting-patient-ready-ct-scan_23-2149367401.jpg?t=st=1718990666~exp=1718994266~hmac=7130a42cb2b3a194ba422eada75277be72bce7f81adc42791d5e9fd431ebf1f2&w=996'),
                  _buildTestCard(context, 'CT Scan', 'https://img.freepik.com/free-photo/doctor-getting-patient-ready-ct-scan_23-2149367454.jpg?t=st=1718990747~exp=1718994347~hmac=ded00124414c95fbd7184581c257f44dbf17a110fb254fe18310f428ac0e2a7c&w=996'),
                  _buildTestCard(context, 'Ultrasound', 'https://img.freepik.com/free-photo/gynecologist-performing-ultrasound-consultation_23-2149353023.jpg?t=st=1718990813~exp=1718994413~hmac=9d21d02dd994fd390b48831d72b51a73b524518d9ee26d804e5de88d3ad43bdc&w=996'),
                  _buildTestCard(context, 'Urine Test', 'https://img.freepik.com/free-photo/lab-doctor-performing-medical-exam-urine_23-2149371980.jpg?t=st=1718990503~exp=1718994103~hmac=54ff8f772fa59f70e9958dffe5dd294f675cd77cd0fd266f9c67ceaec1c9cc68&w=996'),
                  SizedBox(height: 20), // Add spacing before the footer
                  HealthRisksWidget(),
                  SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Color(0xFFFFA726), // Orange at the top
            Color(0xFFFFA726),      // White at the bottom
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Text(
                  'Why Choose DiagnoCare',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFooterItem('250+', 'Cities', Colors.purple),
                    _buildFooterItem('1 million+', 'Test every year', Colors.purple),
                    _buildFooterItem('200+', 'Lab networks', Colors.purple),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  '© 2023 DiagnoCare. All rights reserved.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(String number, String description, Color numberColor) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: numberColor,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }



  Widget _buildTestCard(BuildContext context, String testName, String imageUrl) {
    return GestureDetector(
      //onTap: () => _navigateToTestPage(context, testName),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black.withOpacity(0.5), // Violet shade with reduced opacity
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Padding(
                  padding: const EdgeInsets.all(35.0), // Add padding to the text
                  child: Text(
                    testName,
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestPage extends StatelessWidget {
  final String testName;

  TestPage({required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
      ),
      body: Center(
        child: Text('This is the $testName page'),
      ),
    );
  }
}

class AllTestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tests'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildTestCard(context, 'CBC (Complete Blood Count) Haemogram test', 'https://img.freepik.com/premium-photo/blood-vial-with-blood-sample-test-form_159160-909.jpg?w=996'),
          _buildTestCard(context, 'Urine Test', 'https://img.freepik.com/free-photo/lab-doctor-performing-medical-exam-urine_23-2149371980.jpg?t=st=1718990503~exp=1718994103~hmac=54ff8f772fa59f70e9958dffe5dd294f675cd77cd0fd266f9c67ceaec1c9cc68&w=996'),
          _buildTestCard(context, 'X-Ray', 'https://img.freepik.com/free-photo/doctor-patient-watching-x-ray_23-2147763763.jpg?t=st=1718990608~exp=1718994208~hmac=73809aae2b7dd6189003b985609400424c1d5780d419d4691a0a93bd7cb565fc&w=996'),
          _buildTestCard(context, 'MRI', 'https://img.freepik.com/free-photo/doctor-getting-patient-ready-ct-scan_23-2149367401.jpg?t=st=1718990666~exp=1718994266~hmac=7130a42cb2b3a194ba422eada75277be72bce7f81adc42791d5e9fd431ebf1f2&w=996'),
          _buildTestCard(context, 'CT Scan', 'https://img.freepik.com/free-photo/doctor-getting-patient-ready-ct-scan_23-2149367454.jpg?t=st=1718990747~exp=1718994347~hmac=ded00124414c95fbd7184581c257f44dbf17a110fb254fe18310f428ac0e2a7c&w=996'),
          _buildTestCard(context, 'Ultrasound', 'https://img.freepik.com/free-photo/gynecologist-performing-ultrasound-consultation_23-2149353023.jpg?t=st=1718990813~exp=1718994413~hmac=9d21d02dd994fd390b48831d72b51a73b524518d9ee26d804e5de88d3ad43bdc&w=996'),
          _buildTestCard(context, 'Sugar Test', 'https://img.freepik.com/free-photo/closeup-shot-doctor-with-rubber-gloves-taking-blood-test-from-patient_181624-56107.jpg?t=st=1718990978~exp=1718994578~hmac=10f1952a137597054b87648162ee854822802cf0257a42ecb77cb5f90fa776db&w=996'),
          _buildTestCard(context, 'BP Test', 'https://img.freepik.com/free-photo/doctor-examining-blood-pressure_23-2148285758.jpg?t=st=1718990312~exp=1718993912~hmac=18e3d7139d8f7cab67855b507ffd17a172c7044fcb99cc58bc785475560b8fab&w=996'),
          _buildTestCard(context, 'Cholesterol Test', 'https://img.freepik.com/free-photo/doctor-performing-routine-medical-checkup_23-2149281077.jpg?t=st=1718991134~exp=1718994734~hmac=de94ee738c74319e72dc1bab8ba02b3159074b81f77281e7378a1eabba9897e7&w=996'),
          _buildTestCard(context, 'Liver Function Test', 'https://img.freepik.com/premium-photo/doctor-demonstrates-model-liver-table-clinic_587895-3652.jpg?w=1380'),
          _buildTestCard(context, 'Kidney Function Test', 'https://img.freepik.com/premium-photo/doctor-holding-anatomical-kidney-model-stethoscope-his-office_132310-10132.jpg?w=996'),
          _buildTestCard(context, 'Thyroid Test', 'https://img.freepik.com/free-photo/endocrinologist-examining-throat-young-woman-clinic-women-with-thyroid-gland-test-endocrinology-hormones-treatment-inflammation-sore-throat_657921-270.jpg?t=st=1718991459~exp=1718995059~hmac=5983e727faff181e6dc23f7d8f6b69f25150f9fae1aa2412b311fe36d554dd0e&w=996'),
          _buildTestCard(context, 'ECG', 'https://img.freepik.com/free-photo/did-you-saw-when-your-neighbor-is-leave-his-house-suspicious-man-passes-lie-detector-office-asking-questions-polygraph-test_146671-17335.jpg?t=st=1718991533~exp=1718995133~hmac=810043c5778d66d256626c48251d6b700c53602ad950865d07bf48538005ba6c&w=996'),
          _buildTestCard(context, 'Vitamin D Test', 'https://img.freepik.com/premium-photo/pill-from-any-illness-female-doctor-white-uniform-holding-pill_425904-27674.jpg?w=996'),
          _buildTestCard(context, 'Calcium Test', 'https://img.freepik.com/premium-photo/patient-visiting-doctor-urine-test_656932-2489.jpg?w=996'),
          _buildTestCard(context, 'Hormone Panels(e.g.,Estrogen, Testosterone)', 'https://img.freepik.com/premium-photo/man-working-table_1048944-26290625.jpg?w=996')
        ],
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, String testName, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Handle test card tap
      },

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Container(
              height: 180.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 180.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Padding(
                  padding: const EdgeInsets.all(35.0), // Add padding to the text
                  child: Text(
                    testName,
                    style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestByHealthRisks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test By Health Risks',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Add color
              fontStyle: FontStyle.italic, // Add font style
            ),
          ),
          SizedBox(height: 10),
          // _buildRiskTestCard('Diabetes', 'https://example.com/diabetes.jpg'),
          // _buildRiskTestCard('Heart Disease', 'https://example.com/heart_disease.jpg'),
          // _buildRiskTestCard('Cancer', 'https://example.com/cancer.jpg'),
        ],
      ),
    );
  }

  // Widget _buildRiskTestCard(String riskName, String imageUrl) {
  //   return Card(
  //     margin: EdgeInsets.symmetric(vertical: 10.0),
  //     color: Colors.grey[200], // Add background color
  //     child: ListTile(
  //       leading: Image.network(
  //         imageUrl,
  //         width: 50.0,
  //         height: 50.0,
  //         fit: BoxFit.cover,
  //         errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
  //           return Icon(Icons.error);
  //         },
  //       ),
  //       title: Text(
  //         riskName,
  //         style: TextStyle(
  //           fontSize: 18.0, // Add font size
  //           fontWeight: FontWeight.bold, // Add font weight
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class HealthRisksWidget extends StatefulWidget {
  @override
  _HealthRisksWidgetState createState() => _HealthRisksWidgetState();
}

class _HealthRisksWidgetState extends State<HealthRisksWidget> {
  final List<Map<String, String>> healthRisks = [
    {
      'name': 'Heart',
      'image': 'https://media.istockphoto.com/id/1399012277/vector/human-heart-3d-realistic-vector-isolated-on-white-background-anatomically-correct-heart-with.jpg?s=2048x2048&w=is&k=20&c=GvnPVk9hKGC7MygMcjfdN0X39UrdcoAp_tqtLVcZyPo='
    },
    {
      'name': 'Liver',
      'image': 'https://img.freepik.com/free-vector/human-liver-structure-organ-human-medical-science-health-internal_1284-42361.jpg?w=740&t=st=1719731180~exp=1719731780~hmac=522894a67fe18beda3456302ee0154033722346615499a7eae70b0d8fa379ec8'
    },
    {
      'name': 'Kidney',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqH9shG6lR4EcRFHWKUeuF1036hNVNEFNXFg&s'
    },
    {
      'name': 'Thyroid',
      'image': 'https://cdn.vectorstock.com/i/1000x1000/38/23/human-thyroid-gland-vector-1253823.webp'
    },
    {
      'name': 'Bone and Joint',
      'image': 'https://img.freepik.com/free-psd/skull-figure-isolated_23-2151374244.jpg?t=st=1719731680~exp=1719735280~hmac=8088534b2c12d34acb0115caf56791a53d3ba78d1520ee6e1d7c833a91ff390f&w=826'
    },
    {
      'name': 'Nerves',
      'image': 'https://img.freepik.com/premium-photo/synapses-brain_777271-1493.jpg?w=996'
    },
    {
      'name': 'Lungs',
      'image': 'https://img.freepik.com/free-vector/red-lungs-with-white-background-word-heart-it_1308-153031.jpg'
    },
    {
      'name': 'Stomach',
      'image': 'https://static.vecteezy.com/system/resources/previews/003/661/874/original/stomach-organ-human-free-vector.jpg'
    },
    {
      'name': 'Skin',
      'image': 'https://my.clevelandclinic.org/-/scassets/images/org/health/articles/10978-skin'
    },
    {
      'name': 'Blood',
      'image': 'https://png.pngtree.com/png-vector/20230414/ourmid/pngtree-blood-drop-blood-red-cartoon-illustration-png-image_6694336.png'
    },
    {
      'name': 'Eyes',
      'image': 'https://m.economictimes.com/thumb/msid-91467453,width-1200,height-900,resizemode-4,imgsize-41314/eye_think.jpg'
    },
    {
      'name': 'Ears',
      'image': 'https://media.istockphoto.com/id/1394801910/vector/realistic-human-ear-isolated-on-white-background-human-ear-organ-hearing-health-care-closeup.jpg?s=612x612&w=0&k=20&c=Sz7uFiG7-aXja7r7M8qaSuH_7AicbixpuKB87LWKXbA='
    },
    {
      'name': 'Teeth',
      'image': 'https://media.istockphoto.com/id/1311426433/photo/whitening-tooth-and-dental-health-on-treatment-background-with-cleaning-teeth-3d-rendering.jpg?s=612x612&w=0&k=20&c=xd6gDp1RdWMWvNlBa3C4-_eJVNkjLzg42jxVBW1f2qo='
    },
    {
      'name': 'Muscles',
      'image': 'https://www.shoulder-pain-explained.com/images/shoulder-muscles-anatomy.jpg'
    },
    {
      'name': 'Pancreas',
      'image': 'https://media.istockphoto.com/id/1401150101/vector/pancreas-human-internal-organ-anatomy-vector-illustration-on-a-white-background-flat-design.jpg?s=612x612&w=0&k=20&c=2z2BLXqOGNBfWCa2wpaWfSrX-cnwSymyM9MvjIuV1bQ='
    },
    {
      'name': 'Bladder',
      'image': 'https://uthealtheasttexas.com/sites/default/files/styles/services_node_image/public/sub-service-images/bladderControl_subservice940x450.png?itok=DRZ2mzh8'
    },
    {
      'name': 'Colon',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb_NTMq7uG9c-T2yjXWdqYDJWAlCE_ED-4AT1ruoYlWWdlmbpxbS8Nkmbr0P-MUvQfD5Q&usqp=CAU'
    },
    {
      'name': 'Reproductive',
      'image': 'https://img.freepik.com/premium-vector/realistic-female-genitals-human-reproductive-system-anatomy-composition-with-realistic-images-blank-background-vector-illustration_1284-66120.jpg'
    },
    // Add more health risks as needed
  ];

  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    double newOffset = (_scrollController.offset - MediaQuery.of(context).size.width / 2);
    _scrollController.animateTo(
      newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _scrollRight() {
    double newOffset = (_scrollController.offset + MediaQuery.of(context).size.width / 2);
    _scrollController.animateTo(
      newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Test by Health Risks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Choose test by Health Risk',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              onPressed: _scrollLeft,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: healthRisks.map((risk) => _buildHealthRiskCard(risk)).toList(),
                ),
              ),
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              onPressed: _scrollRight,
            ),
          ],
        ),
        // Center(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       // Implement view more functionality
        //     },
        //     child: Text('View More'),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildHealthRiskCard(Map<String, String> risk) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRiskDetailPage(healthRisk: risk),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: NetworkImage(risk['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(risk['name']!),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePageMedicalExpert(email: 'example@example.com'),
  ));
}
