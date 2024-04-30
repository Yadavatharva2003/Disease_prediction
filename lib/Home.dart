import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:disease_prediction/Login.dart';
import 'package:disease_prediction/history.dart';
import 'package:disease_prediction/input.dart';
import 'package:disease_prediction/patient.dart';
import 'package:disease_prediction/reminder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        backgroundColor: Colors.blue[200],
        toolbarHeight: 250,
        flexibleSpace: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 190,
                ),
              ),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome, $_userName',
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: Duration(milliseconds: 200),
                ),
              ],
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              child: Text(
                _userInitials(_userName),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _generateRandomColor(),
            ),
            alignment: Alignment.topLeft,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
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
            ListTile(
              title: Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputPage()),
                  );
                },
                child: Card(
                  color:Colors.blue[200],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Overview',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Know your health.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        // Add more reminder details here if needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderPage()),
                  );
                },
                child: Card(
                  color:Colors.blue[200],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medicine Reminder',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Take your medicine at the prescribed time.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        // Add more reminder details here if needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: [
            // Add your image widgets here
            Image.network('assets/R.png', fit: BoxFit.cover),
            Image.network('assets/R.png', fit: BoxFit.cover),
            Image.network('assets/R.png', fit: BoxFit.cover),
          ],
        ),
      ],
    ),

    );
  }
}
