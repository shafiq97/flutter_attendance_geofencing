import 'package:attendance/attendancescreen.dart';
import 'package:attendance/studentlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: const Color(0xffeef444c),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffeef444c),
              ),
              child: Text(
                'Teacher Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Attendance List'),
              onTap: () {
                // Navigate to Attendance List screen
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentListScreen()),
                );
              },
            ),
            // Add other drawer items here
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['subject']),
                    subtitle: Text(data['time']),
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubjectDialog(),
        tooltip: 'Add Subject',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(hintText: 'Subject'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(hintText: 'Time'),
                ),
                // Add more fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _submitForm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    String subject = _subjectController.text.trim();
    String time = _timeController.text.trim();
    // Clear text fields after submission
    _subjectController.clear();
    _timeController.clear();

    try {
      await FirebaseFirestore.instance.collection('subjects').add({
        'subject': subject,
        'time': time,
        // Add other field data
      });
      // Optionally show a success message
    } catch (e) {
      // Optionally handle errors, e.g., show an error message
    }
  }
}
