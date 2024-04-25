import 'package:disease_prediction/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfoPage extends StatefulWidget {
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _patientStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Initialize stream to fetch patient information from Firestore
    _patientStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Information'),
        backgroundColor: Colors.blue, // Change app bar color to blue
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _patientStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // Extract patient data from the snapshot
            var patientData = snapshot.data!.data();
            return AnimatedPatientInfo(patientData: patientData);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home())); // Navigate back when the FAB is pressed
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.blue, // Change FAB color to blue
      ),
    );
  }
}

class AnimatedPatientInfo extends StatelessWidget {
  final Map<String, dynamic>? patientData;

  const AnimatedPatientInfo({Key? key, this.patientData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Change the color to blue
            ),
          ),
          SizedBox(height: 20.0),
          _buildInfoField(
            label: 'Name:',
            value: patientData?['fullName'] ?? 'Unknown',
            icon: Icons.person, // Add person icon
          ),
          SizedBox(height: 16.0),
          _buildInfoField(
            label: 'Phone Number:',
            value: patientData?['phoneNumber'] ?? 'Unknown',
            icon: Icons.phone, // Add phone icon
          ),
          SizedBox(height: 16.0),
          _buildInfoField(
            label: 'Age:',
            value: patientData?['age'] ?? 'Unknown',
            icon: Icons.calendar_today, // Add calendar icon
          ),
          SizedBox(height: 16.0),
          _buildInfoField(
            label: 'Email ID:',
            value: patientData?['email'] ?? 'Unknown',
            icon: Icons.email, // Add email icon
          ),
          SizedBox(height: 16.0),
          _buildEmergencyContactField(patientData?['emergencyContact'] ?? {}), // Display emergency contact details
        ],
      ),
    );
  }

  Widget _buildInfoField({required String label, required String value, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24.0,
          color: Colors.blue, // Change icon color to blue
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Change label color to blue
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyContactField(Map<String, dynamic> emergencyContact) {
    String name = emergencyContact['name'] ?? 'Unknown';
    String phoneNumber = emergencyContact['phoneNumber'] ?? 'Unknown';
    String relationship = emergencyContact['relationship'] ?? 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Change label color to blue
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'Name: $name\nPhone Number: $phoneNumber\nRelationship: $relationship',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PatientInfoPage(),
  ));
}
