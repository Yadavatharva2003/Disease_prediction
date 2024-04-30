import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _patientNameController,
                  decoration: InputDecoration(labelText: 'Patient Name'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _medicineNameController,
                  decoration: InputDecoration(labelText: 'Medicine Name'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _dosageController,
                  decoration: InputDecoration(labelText: 'Dosage'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _timingController,
                  decoration: InputDecoration(labelText: 'Timing'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _frequencyController,
                  decoration: InputDecoration(labelText: 'Frequency'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality to save the reminder
                // You can access the entered values using the respective controllers
                String patientName = _patientNameController.text;
                String medicineName = _medicineNameController.text;
                String dosage = _dosageController.text;
                String timing = _timingController.text;
                String startDate = _startDateController.text;
                String endDate = _endDateController.text;
                String frequency = _frequencyController.text;
                String notes = _notesController.text;

                // You can add code here to save the reminder
                // For example, you can add the reminder to a list of reminders or store it in a database

                // After saving the reminder, close the dialog
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add your list of reminders here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _medicineNameController.dispose();
    _dosageController.dispose();
    _timingController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
