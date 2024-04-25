import 'package:disease_prediction/Home.dart';
import 'package:disease_prediction/Login.dart';
import 'package:disease_prediction/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({Key? key}) : super(key: key);

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration(milliseconds: 500)); // Optional delay for better UI
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>Home()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show a loading indicator while checking the user
            : Container(), // Empty container when not loading
      ),
    );
  }
}
