import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final List<Medicine> medicines = [];

  TextEditingController patientNameController = TextEditingController();
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController timingController = TextEditingController();

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Medicine'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: patientNameController,
                    decoration: InputDecoration(labelText: 'Patient Name'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: medicineNameController,
                    decoration: InputDecoration(labelText: 'Medicine Name'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: dosageController,
                    decoration: InputDecoration(labelText: 'Dosage'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: timingController,
                    decoration: InputDecoration(labelText: 'Timing'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        medicines.add(Medicine(
                          patientName: patientNameController.text,
                          medicineName: medicineNameController.text,
                          dosage: dosageController.text,
                          timing: timingController.text,
                        ));
                        medicineNameController.clear();
                        dosageController.clear();
                        timingController.clear();
                      });
                    },
                    child: Text('Add Medicine'),
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality to save the reminders
                // You can access the entered values using the medicines list
                // For example, you can save the list of medicines to a database
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Reminders'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Patient Name: ${medicines[index].patientName}'),
            subtitle: Text('Medicine: ${medicines[index].medicineName}, Dosage: ${medicines[index].dosage}, Timing: ${medicines[index].timing}'),
          );
        },
      ),
    );
  }
}

class Medicine {
  final String patientName;
  final String medicineName;
  final String dosage;
  final String timing;

  Medicine({
    required this.patientName,
    required this.medicineName,
    required this.dosage,
    required this.timing,
  });
}

void main() {
  runApp(MaterialApp(
    home: ReminderPage(),
  ));
}
