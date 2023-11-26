import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendanceScreen extends StatelessWidget {
  final String studentId;

  StudentAttendanceScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(studentId)
            .collection('Record')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['date']
                    .toDate()
                    .toString()), // Assuming 'date' is a Timestamp
                subtitle: Text(
                    'Check-in: ${data['checkIn']}, Check-out: ${data['checkOut']}'),
                trailing: Text(data['att']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
