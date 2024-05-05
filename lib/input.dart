import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_prediction/report.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late TextEditingController _temperatureController;
  late TextEditingController _bloodPressureController;
  late TextEditingController _oxygenLevelController;
  late TextEditingController _heartRateController;
  late TextEditingController _symptomsController;
  final List<String> allSymptoms = [
    'itching',
    'skin_rash',
    'nodal_skin_eruptions',
    'continuous_sneezing',
    'shivering',
    'chills',
    'joint_pain',
    'stomach_pain',
    'acidity',
    'ulcers_on_tongue',
    'muscle_wasting',
    'vomiting',
    'burning_micturition',
    'spotting_urination',
    'fatigue',
    'weight_gain',
    'anxiety',
    'cold_hands_and_feets',
    'mood_swings',
    'weight_loss',
    'restlessness',
    'lethargy',
    'patches_in_throat',
    'irregular_sugar_level',
    'cough',
    'high_fever',
    'sunken_eyes',
    'breathlessness',
    'sweating',
    'dehydration',
    'indigestion',
    'headache',
    'yellowish_skin',
    'dark_urine',
    'nausea',
    'loss_of_appetite',
    'pain_behind_the_eyes',
    'back_pain',
    'constipation',
    'abdominal_pain',
    'diarrhoea',
    'mild_fever',
    'yellow_urine',
    'yellowing_of_eyes',
    'acute_liver_failure',
    'fluid_overload',
    'swelling_of_stomach',
    'swelled_lymph_nodes',
    'malaise',
    'blurred_and_distorted_vision',
    'phlegm',
    'throat_irritation',
    'redness_of_eyes',
    'sinus_pressure',
    'runny_nose',
    'congestion',
    'chest_pain',
    'weakness_in_limbs',
    'fast_heart_rate',
    'pain_during_bowel_movements',
    'pain_in_anal_region',
    'bloody_stool',
    'irritation_in_anus',
    'neck_pain',
    'dizziness',
    'cramps',
    'bruising',
    'obesity',
    'swollen_legs',
    'swollen_blood_vessels',
    'puffy_face_and_eyes',
    'enlarged_thyroid',
    'brittle_nails',
    'swollen_extremeties',
    'excessive_hunger',
    'extra_marital_contacts',
    'drying_and_tingling_lips',
    'slurred_speech',
    'knee_pain',
    'hip_joint_pain',
    'muscle_weakness',
    'stiff_neck',
    'swelling_joints',
    'movement_stiffness',
    'spinning_movements',
    'loss_of_balance',
    'unsteadiness',
    'weakness_of_one_body_side',
    'loss_of_smell',
    'bladder_discomfort',
    'foul_smell_of_urine',
    'continuous_feel_of_urine',
    'passage_of_gases',
    'internal_itching',
    'toxic_look_(typhos)',
    'depression',
    'irritability',
    'muscle_pain',
    'altered_sensorium',
    'red_spots_over_body',
    'belly_pain',
    'abnormal_menstruation',
    'dischromic_patches',
    'watering_from_eyes',
    'increased_appetite',
    'polyuria',
    'family_history',
    'mucoid_sputum',
    'rusty_sputum',
    'lack_of_concentration',
    'visual_disturbances',
    'receiving_blood_transfusion',
    'receiving_unsterile_injections',
    'coma',
    'stomach_bleeding',
    'distention_of_abdomen',
    'history_of_alcohol_consumption',
    'fluid_overload',
    'blood_in_sputum',
    'prominent_veins_on_calf',
    'palpitations',
    'painful_walking',
    'pus_filled_pimples',
    'blackheads',
    'scurring',
    'skin_peeling',
    'silver_like_dusting',
    'small_dents_in_nails',
    'inflammatory_nails',
    'blister',
    'red_sore_around_nose',
    'yellow_crust_ooze'
  ];
  List<String> _filteredSymptoms = [];
  List<String> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _bloodPressureController = TextEditingController();
    _oxygenLevelController = TextEditingController();
    _heartRateController = TextEditingController();
    _symptomsController = TextEditingController();
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _bloodPressureController.dispose();
    _oxygenLevelController.dispose();
    _heartRateController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                  _temperatureController, 'Body Temperature (°C)', Icons.thermostat),
              SizedBox(height: 16.0),
              _buildInputField(
                  _bloodPressureController, 'Blood Pressure', Icons.favorite),
              SizedBox(height: 16.0),
              _buildInputField(_oxygenLevelController, 'Oxygen Level (%)',
                  Icons.opacity), // Changed icon to Icons.opacity
              SizedBox(height: 16.0),
              _buildInputField(
                  _heartRateController, 'Heart Rate (bpm)', Icons.favorite_outline),
              SizedBox(height: 16.0),
              _buildSymptomsField(),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  // Prepare data to be saved
                  Map<String, dynamic> inputData = {
                    'temperature': _temperatureController.text,
                    'heartRate': _heartRateController.text,
                    'bloodPressure': _bloodPressureController.text,
                    'oxygenLevel': _oxygenLevelController.text,

                  };

                  // Get current user ID
                  String? userId = await getCurrentUserId();

                  // Save data to Firestore and navigate to DiagnosticReportPage
                  if (userId != null) {
                    try {
                      // Make API call to predict disease
                      var prediction = await predictDisease(inputData);

                      // Save data to Firestore
                      await FirebaseFirestore.instance
                          .collection('users') // Assuming 'users' is the collection where users' data is stored
                          .doc(userId)
                          .collection('medical') // Sub-collection named 'medical' for storing medical data
                          .add({
                        ...inputData,
                        'predictedDisease': prediction,
                      });

                      // Navigate to the next screen after data is successfully saved
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DiagnosticReportPage()),
                      );
                    } catch (e) {
                      print('Error saving data: $e');
                      // Handle error saving data
                    }
                  } else {
                    print('User ID is null');
                    // Handle scenario when user ID is null
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String labelText, IconData iconData) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(iconData),
      ),
    );
  }

  Widget _buildSymptomsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptoms',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _symptomsController,
          decoration: InputDecoration(
            hintText: 'Enter symptom',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _filteredSymptoms.clear();
              _filterSymptoms(value);
            });
          },
        ),
        SizedBox(height: 8.0),
        Container(
          height: 150.0,
          child: ListView.builder(
            itemCount: _filteredSymptoms.length,
            itemBuilder: (context, index) {
              final symptom = _filteredSymptoms[index];
              return ListTile(
                title: Text(symptom),
                onTap: () {
                  setState(() {
                    _symptomsController.text = symptom;
                    _addSymptom(symptom);
                    _filteredSymptoms.clear();
                  });
                },
              );
            },
          ),
        ),
        SizedBox(height: 8.0),
        // Container to display added symptoms
        _buildSelectedSymptomsContainer(),
      ],
    );
  }

  Widget _buildSelectedSymptomsContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Symptoms',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: _selectedSymptoms.map((symptom) {
              return Chip(
                label: Text(symptom),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  _removeSymptom(symptom);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _addSymptom(String symptom) {
    if (!_selectedSymptoms.contains(symptom)) {
      setState(() {
        _selectedSymptoms.add(symptom);
      });
    }
  }

  void _removeSymptom(String symptom) {
    setState(() {
      _selectedSymptoms.remove(symptom);
    });
  }

  void _filterSymptoms(String query) {
    setState(() {
      _filteredSymptoms = allSymptoms.where((symptom) {
        return symptom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }
}
Future<String?> predictDisease(Map<String, dynamic> inputData) async {
  // Replace 'YOUR_PREDICTION_API_ENDPOINT' with the actual endpoint URL
  String predictionEndpoint = 'https://disease-prediction-pcfy.onrender.com/predict_model2';

  try {
    // Make POST request to prediction API endpoint
    var response = await http.post(
      Uri.parse(predictionEndpoint),
      body: jsonEncode(inputData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the request is successful, return the predicted disease
      return response.body;
    } else {
      // If there's an error with the request, print the response status code
      print('Failed to predict disease: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Catch any errors that occur during the request and print them
    print('Failed to predict disease: $e');
    return null;
  }
}
