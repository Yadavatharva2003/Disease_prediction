import 'package:disease_prediction/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationController;

  late String _selectedWeightUnit;
  late String _selectedHeightUnit;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationController = TextEditingController();
    _selectedWeightUnit = 'kg'; // Default weight unit
    _selectedHeightUnit = 'cm'; // Default height unit
    _selectedGender = 'Male'; // Default gender
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  DropdownButton<String>(
                    value: _selectedWeightUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedWeightUnit = newValue!;
                      });
                    },
                    items: <String>['kg', 'lbs'].map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height',
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  DropdownButton<String>(
                    value: _selectedHeightUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHeightUnit = newValue!;
                      });
                    },
                    items: <String>['cm', 'feet/inches'].map<
                        DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Gender',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Emergency Contact Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              TextField(
                controller: _emergencyNameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emergencyRelationController,
                decoration: InputDecoration(
                  labelText: 'Relationship',
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Calculate BMI
                  double weight = double.parse(_weightController.text);
                  double height = double.parse(_heightController.text);
                  double bmi = calculateBMI(
                      weight, height, _selectedWeightUnit, _selectedHeightUnit);

                  // Save user details in users collection
                  saveUserDetails();

                  // Save BMI in medical subcollection of current user
                  saveBMI(bmi,weight,height);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home()));
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateBMI(double weight, double height, String weightUnit,
      String heightUnit) {
    if (weightUnit == 'lbs') {
      weight *= 0.453592; // Convert lbs to kg
    }
    if (heightUnit == 'feet/inches') {
      height = (height * 30.48) / 100; // Convert feet to cm
    }
    print((weight / (height * height))*10000);
    return weight *10000/ (height * height);
  }

  void saveUserDetails() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'phoneNumber': _phoneNumberController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
        'emergencyContact': {
          'name': _emergencyNameController.text,
          'phoneNumber': _emergencyPhoneController.text,
          'relationship': _emergencyRelationController.text,
        },
        'fullName': user.displayName,
        'email': user.email,
      });
    }
  }


  void saveBMI(double bmi, double weight, double height) {
    // Save BMI, weight, and height in the medical subcollection of the current user
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid).collection('medical').doc('bmi').set({
      'bmi': bmi.toStringAsFixed(2), // Round BMI to 2 decimal places
      'weight': weight.toStringAsFixed(2), // Round weight to 2 decimal places
      'height': height.toStringAsFixed(2), // Round height to 2 decimal places
    });
  }
}
