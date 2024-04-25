import 'dart:math';
import 'package:disease_prediction/Login.dart';
import 'package:disease_prediction/history.dart';
import 'package:disease_prediction/input.dart';
import 'package:disease_prediction/patient.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  String _userName = ''; // Variable to store the user's full name
  double _userBMI = 0;

  @override
  void initState() {
    super.initState();
    _getUserName(); // Fetch the user's name when the widget initializes
    _fetchUserBMI(); // Fetch the user's BMI when the widget initializes
  }

  Future<void> _getUserName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      setState(() {
        _userName = userDoc.get('fullName'); // Update the user's full name
      });
    } catch (e) {
      print('Error retrieving user name: $e');
    }
  }

  Future<void> _fetchUserBMI() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> bmiDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('medical')
          .doc('bmi')
          .get();
      setState(() {
        _userBMI = double.parse(bmiDoc.get('bmi'));
      });
    } catch (e) {
      print('Error retrieving user BMI: $e');
    }
  }

  String _userInitials(String name) {
    if (name.isNotEmpty) {
      List<String> nameSplit = name.split(" ");
      if (nameSplit.length >= 2) {
        String initials = nameSplit[0][0] + nameSplit[1][0];
        return initials.toUpperCase();
      }
    }
    return '';
  }

  Color _generateRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              child: Text(
                _userInitials(_userName), // Display user's initials dynamically
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _generateRandomColor(),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the side drawer
            },
          ),
        ),
        actions: [
          // Navigate to the input page with slide transition animation
          IconButton(
            icon: Icon(Icons.input),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputPage()),
              );
            },
          ),
          // Logout button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: _generateRandomColor(),
              ),
              child: Text(
                _userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Patient information'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PatientInfoPage()));
              },
            ),
            ListTile(
              title: Text('Medical history'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to the Home Page'),
                SizedBox(height: 20),
                Text('Your BMI: $_userBMI'),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: SizedBox(
              width: 200,
              height: 200,
              child: BMIMeter(bmi: _userBMI),
            ),
          ),
        ],
      ),
    );
  }
}
class BMIMeter extends StatelessWidget {
  final double bmi;

  BMIMeter({required this.bmi});

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal';
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return 'Obese';
    } else {
      return 'Over Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.2),
              ],
              stops: [0.5, 1.0],
            ),
          ),
        ),
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                bmi < 18.5 ? Colors.blue : Colors.transparent,
                bmi >= 18.5 && bmi < 24.9 ? Colors.green : Colors.transparent,
                bmi >= 24.9 && bmi < 29.9 ? Colors.orangeAccent : Colors.transparent, // Change the color here
                bmi >= 29.9 ? Colors.red : Colors.transparent,
              ],
              stops: [0.0, 0.33, 0.67, 1.0],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BMI',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getBMICategory(bmi),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}
