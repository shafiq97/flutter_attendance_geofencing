import 'dart:async';

import 'package:attendance/mapscreen.dart';
import 'package:attendance/services/enums/geofence_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:attendance/calendarscreen.dart';
import 'package:attendance/profilescreen.dart';
import 'package:attendance/todayscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  int currentIndex = 1;

  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position? position;

  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  @override
  void initState() {
    super.initState();
    getId().then((value){
      _getCredentials();
      _getProfilePic();
      getCurrentPosition();
    });
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (kDebugMode) {
      print("LOCATION => ${position!.toJson()}");
    }
    isReady = (position != null) ? true : false;
  }

  setLocation() async {
    await getCurrentPosition();
    // print("POSITION => ${position!.toJson()}");
  }

  void _getCredentials() async{
    try{
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("student").doc(User.id).get();
      setState((){
        User.canEdit = doc['canEdit'];
        User.firstName = doc['firstName'];
        User.lastName = doc['lastName'];
        User.birthDate = doc['birthDate'];
        User.address = doc['address'];
        User.ScholarshipName = doc['ScholarshipName'];
        User.MobileNumber = doc['MobileNumber'];
        User.EmailId = doc['EmailId'];
        User.Gender = doc['Gender'];
        User.Religion = doc['Religion'];
        User.Caste = doc['Caste'];
        User.Category = doc['Category'];
        User.InstituteName = doc['InstituteName'];
        User.Income = doc['Income'];
      });
    } catch(e) {
      return;
    }
  }

  void _getProfilePic() async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("student").doc(User.id).get();
    setState((){
      User.profilePicLink = doc['profilePic'];
    });
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("student")
        .where('id', isEqualTo: User.studentId)
        .get();

    setState(() {
      User.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: currentIndex,
        children: const [
          CalendarScreen(),
          TodayScreen(),
          MapScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 100),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: primary,
                  iconColor: Colors.black54,
                  textColor: primary,
                  backgroundColor: primary.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: FontAwesomeIcons.calendarCheck,
                  text: 'Calendar',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: primary,
                  iconColor: Colors.black54,
                  textColor: primary,
                  backgroundColor: primary.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: FontAwesomeIcons.check,
                  text: 'Check',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: primary,
                  iconColor: Colors.black54,
                  textColor: primary,
                  backgroundColor: primary.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: FontAwesomeIcons.mapLocationDot,
                  text: 'Map',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: primary,
                  iconColor: Colors.black54,
                  textColor: primary,
                  backgroundColor: primary.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: FontAwesomeIcons.gear,
                  text: 'Settings',
                )
              ],
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
