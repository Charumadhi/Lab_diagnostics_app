import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'bookSlotPage.dart';
import 'searchLabs.dart';

// void main() {
//   runApp(MaterialApp(
//     home: LabSearchPage(patientId: 'patient123'), // Example patientId
//   ));
// }

class LabSearchPage extends StatefulWidget {
  final String patientId; // Add patientId as a parameter

  LabSearchPage({required this.patientId}); // Constructor with patientId parameter

  @override
  _LabSearchPageState createState() => _LabSearchPageState();
}

class _LabSearchPageState extends State<LabSearchPage> {
  List<Lab> labs = [];

  @override
  void initState() {
    super.initState();
    fetchLabs();
  }

  Future<void> fetchLabs() async {
    try {
      var url = Uri.parse('http://10.0.2.2:3000/labs'); // Replace with your backend URL
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Lab> fetchedLabs = data.map((lab) => Lab.fromJson(lab)).toList();

        setState(() {
          labs = fetchedLabs;
        });
      } else {
        throw Exception('Failed to fetch labs');
      }
    } catch (e) {
      print('Error fetching labs: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Labs'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchingLabs(),
                        ),
                      );
                      // Implement search functionality
                      print('Search button pressed');
                    },
                    icon: Icon(Icons.search),
                    label: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Implement Labs Near Me functionality
                      print('Labs Near Me button pressed');
                    },
                    icon: Icon(Icons.location_on),
                    label: Text('Labs Near Me'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: labs.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: labs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LabCard(lab: labs[index], patientId: widget.patientId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Lab {
  final String labUniqueId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final String contactNumber;
  final List<String> userReviews;
  final String mapUrl;
  final String landmark;

  Lab({
    required this.labUniqueId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.contactNumber,
    required this.userReviews,
    required this.mapUrl,
    required this.landmark,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      labUniqueId: json['lab_unique_id'] ?? '',
      name: json['name'] ?? 'No Name',
      address: json['address'] ?? 'No Address',
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      contactNumber: json['contact_number'] ?? 'No Contact',
      userReviews: json['user_reviews'] != null ? List<String>.from(json['user_reviews']) : [],
      mapUrl: json['mapurl'] ?? '',
      landmark: json['landmark'] ?? 'No Landmark',
    );
  }
}

class LabCard extends StatelessWidget {
  final Lab lab;
  final String patientId;

  LabCard({required this.lab, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LabDetailPage(lab: lab, patientId: patientId),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lab.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 8.0),
              Text(lab.address, style: TextStyle(fontSize: 16)),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow[800]),
                  SizedBox(width: 4.0),
                  Text(
                    lab.rating.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(lab.mapUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Map'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement view tests functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LabDetailPage(lab: lab, patientId: patientId),
                        ),
                      );
                      print('View Tests button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('View Tests'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class LabDetailPage extends StatefulWidget {
  final Lab lab;
  final String patientId;

  LabDetailPage({required this.lab, required this.patientId});

  @override
  _LabDetailPageState createState() => _LabDetailPageState();
}

class _LabDetailPageState extends State<LabDetailPage> {
  List<Test> tests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTests();
  }

  Future<void> fetchTests() async {
    try {
      var url = Uri.parse('http://10.0.2.2:3000/tests/${widget.lab.labUniqueId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Test> fetchedTests = data.map((test) => Test.fromJson(test)).toList();

        setState(() {
          tests = fetchedTests;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch tests. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching tests: $e';
        isLoading = false;
      });
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lab.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Tests Available:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : tests.isEmpty
                  ? Center(child: Text('No tests available'))
                  : Column(
                children: tests.map((test) {
                  return Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        title: Text(
                          test.name, // Display test name here
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                        subtitle: Text(
                          'Price: ₹ ${test.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestDetailPage(
                                test: test,
                                labUniqueId: widget.lab.labUniqueId,
                                patientId: widget.patientId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Test {
  final String testId;
  final String name;
  final String description;
  final double price;

  Test({
    required this.testId,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testId: json['test_id'] ?? '',
      name: json['test_name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
    );
  }
}

class TestDetailPage extends StatelessWidget {
  final Test test;
  final String labUniqueId;
  final String patientId;

  TestDetailPage({required this.test, required this.labUniqueId, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(test.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  test.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 25),
              Text(
                test.description,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 24),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSlotPage(
                            test: test,
                            labUniqueId: labUniqueId,
                            patientId: patientId,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.teal),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'BOOK SLOT',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
