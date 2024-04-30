import 'package:disease_prediction/Home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<List<DocumentSnapshot>> historyData;

  @override
  void initState() {
    super.initState();
    // Call function to fetch history data
    historyData = fetchHistoryData();
  }

  Future<String> getCurrentUserId() async {
    // Get current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<List<DocumentSnapshot>> fetchHistoryData() async {
    try {
      // Get current user ID
      String currentUserId = await getCurrentUserId();

      // Get Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Query data from Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('users') // Assuming user data is stored in 'users' collection
          .doc(currentUserId) // Assuming each user has a document with their ID
          .collection('medical') // Subcollection containing history data
          .get();

      // Filter out the 'bmi' document
      List<DocumentSnapshot> historyDocs = querySnapshot.docs
          .where((doc) => doc.id != 'bmi')
          .toList();

      return historyDocs;
    } catch (e) {
      print('Error fetching history data: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display fetched history data
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data![index];
                // Extracting disease name and date from document

                Timestamp timestamp = document['dateTime'];
                DateTime dateTime = timestamp.toDate();
                String formattedDateTime =
                    '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';

                // Custom card widget to display data
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text("diseaseName"),
                    subtitle: Text(formattedDateTime),
                    onTap: () {
                      // Navigate to new page on card tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(document),
                        ),
                      );
                    },
                    // Add any additional details you want to display here
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}



class DetailsPage extends StatelessWidget {
  final DocumentSnapshot document;

  const DetailsPage(this.document);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Date and Time'),
              SizedBox(height: 8.0),
              _buildSectionContent('Date and Time', document['dateTime'].toDate().toString()),
              SizedBox(height: 24.0),
              _buildSectionHeader('Patient Details'),
              SizedBox(height: 8.0),

              _buildSectionContent('Temperature', '${data?['temperature'] ?? ''} °C'),
              _buildDivider(),
              _buildSectionContent('Blood Pressure', data?['bloodPressure'] ?? ''),
              _buildDivider(),
              _buildSectionContent('Oxygen Level', '${data?['oxygenLevel'] ?? ''} %'),
              _buildDivider(),
              _buildSectionContent('Heart Rate', '${data?['heartRate'] ?? ''} bpm'),
              _buildDivider(),
              _buildSymptomsSection(data?['symptoms']),
              // Add more sections as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSectionContent(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1.0,
      height: 24.0,
    );
  }

  Widget _buildSymptomsSection(List<dynamic>? symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Symptoms'),
        SizedBox(height: 8.0),
        Container(
          height: 100, // Set a fixed height for the symptoms list
          child: ListView.builder(
            itemCount: symptoms?.length ?? 0,
            itemBuilder: (context, index) {
              return Text(
                '- ${symptoms?[index]}',
                style: TextStyle(fontSize: 16),
              );
            },
          ),
        ),
      ],
    );
  }
}
