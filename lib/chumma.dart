import 'package:flutter/material.dart';


class PatientDashboard extends StatelessWidget {
  final Map<String, dynamic> patientData;

  PatientDashboard({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Profile Section
            _buildProfileSection(),
            Divider(),
            // Medical History Section
            _buildMedicalHistorySection(),
            Divider(),
            // Lab Results Section
            _buildLabResultsSection(),
            Divider(),
            // Appointment Management Section
            _buildAppointmentSection(),
            Divider(),
            // Remote Consultations Section
            _buildRemoteConsultationSection(),
            Divider(),
            // Prescriptions and Medications Section
            _buildPrescriptionsSection(),
            Divider(),
            // Notifications and Alerts Section
            _buildNotificationsSection(),
            Divider(),
            // Health Tips and Suggestions Section
            _buildHealthTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return ListTile(
      title: Text('Profile'),
      subtitle: Text('Name: ${patientData['name']}\nEmail: ${patientData['email']}'),
    );
  }

  Widget _buildMedicalHistorySection() {
    return ListTile(
      title: Text('Medical History'),
      subtitle: Text('Medical history details here...'),
    );
  }

  Widget _buildLabResultsSection() {
    return ListTile(
      title: Text('Lab Results'),
      subtitle: Text('Lab results details here...'),
    );
  }

  Widget _buildAppointmentSection() {
    return ListTile(
      title: Text('Appointments'),
      subtitle: Text('Appointment details here...'),
    );
  }

  Widget _buildRemoteConsultationSection() {
    return ListTile(
      title: Text('Remote Consultations'),
      subtitle: Text('Remote consultation details here...'),
    );
  }

  Widget _buildPrescriptionsSection() {
    return ListTile(
      title: Text('Prescriptions and Medications'),
      subtitle: Text('Prescriptions and medications details here...'),
    );
  }

  Widget _buildNotificationsSection() {
    return ListTile(
      title: Text('Notifications and Alerts'),
      subtitle: Text('Notifications and alerts details here...'),
    );
  }

  Widget _buildHealthTipsSection() {
    return ListTile(
      title: Text('Health Tips and Suggestions'),
      subtitle: Text('Health tips and suggestions details here...'),
    );
  }
}
