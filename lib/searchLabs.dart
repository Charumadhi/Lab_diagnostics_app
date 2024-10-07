import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchingLabs extends StatefulWidget {
  @override
  _SearchingLabsState createState() => _SearchingLabsState();
}

class _SearchingLabsState extends State<SearchingLabs> {
  List<dynamic> labs = [];
  bool isLoading = false;
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  void dispose() {
    // Clean up any controllers, listeners, etc.
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }
  }

  Future<void> _findLabsNearMe() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      final response = await http.get(Uri.parse('http://192.168.137.59:3000/nearby-labs?lat=$latitude&lon=$longitude'));

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          labs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch nearby labs: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error fetching nearby labs: $e');
    }
  }

  Future<void> _searchLabs() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    String locality = _localityController.text;
    String city = _cityController.text;
    String state = _stateController.text;

    try {
      final response = await http.get(Uri.parse('http://192.168.137.59:3000/search-labs?locality=$locality&city=$city&state=$state'));

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          labs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        print('Failed to search labs: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error searching labs: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Labs Near Me'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
              ),
              onPressed: _findLabsNearMe,
              child: Text('Labs Near Me'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _localityController,
              decoration: InputDecoration(
                labelText: 'Locality',
              ),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
              ),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(
                labelText: 'State',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
              ),
              onPressed: _searchLabs,
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: labs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(labs[index]['name']),
                    subtitle: Text('Rating: ${labs[index]['rating']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}