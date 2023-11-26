import 'dart:async';
import 'dart:developer';
import 'package:attendance/services/EasyPolyGeofencing.dart';
import 'package:attendance/services/enums/geofence_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'model/user.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";

  Color primary = const Color(0xffeef444c);

  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position? position;

  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    _getRecord();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to avoid unauthorized access.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
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

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("student")
          .where('id', isEqualTo: User.studentId)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("student")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Welcome, ",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "BebasNeue-Regular",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Student ${User.studentId}",
              style: TextStyle(
                fontFamily: "BebasNeue-Bold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Today's Status",
              style: TextStyle(
                fontFamily: "BebasNeue-Bold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check In",
                        style: TextStyle(
                          fontFamily: "BebasNeue-Regular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        checkIn,
                        style: TextStyle(
                          fontFamily: "BebasNeue-Bold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check Out",
                        style: TextStyle(
                          fontFamily: "BebasNeue-Regular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        checkOut,
                        style: TextStyle(
                          fontFamily: "BebasNeue-Bold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                      color: primary,
                      fontSize: screenWidth / 18,
                      fontFamily: "BebasNeue-Bold",
                    ),
                    children: [
                      TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 20,
                            fontFamily: "BebasNeue-Bold",
                          ))
                    ]),
              )),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      fontFamily: "BebasNeue-Regular",
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                    ),
                  ),
                );
              }),
          checkOut == "--/--"
              ? Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> key = GlobalKey();

                      return SlideAction(
                        text: checkIn == "--/--"
                            ? "Slide to check In"
                            : "Slide to check Out",
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: screenWidth / 20,
                          fontFamily: "BebasNeue-Regular",
                        ),
                        outerColor: Colors.white,
                        innerColor: primary,
                        key: key,
                        onSubmit: () async {
                          await _authenticateWithBiometrics();
                          await getCurrentPosition();

                          // Define your location point
                          const double fixedLatitude = 4.5885;
                          const double fixedLongitude = 101.1260;

                          // Define the radius
                          const double radius = 300; // meters

                          // Get the current position
                          Position currentPosition =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.best);

                          // Calculate the distance between the current position and the fixed point
                          double distance = Geolocator.distanceBetween(
                            currentPosition.latitude,
                            currentPosition.longitude,
                            fixedLatitude,
                            fixedLongitude,
                          );

                          if (distance > radius) {
                            // The user is out of the allowed location
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Out of Location'),
                                content: const Text(
                                    'You are too far from the specified location to check in or check out.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (_authorized != "Authorized") {
                              key.currentState!.reset();
                            }
                            location = "check";
                            if (User.flag == true) {
                              EasyPolyGeofencing.startGeofenceService(
                                  eventPeriodInSeconds: 2);
                              geofenceStatusStream ??=
                                  EasyPolyGeofencing.getGeofenceStream()!
                                      .listen((GeofenceStatus status) {
                                log("😀 STATUS $status");

                                setState(() {
                                  geofenceStatus = status.toString();
                                  if (geofenceStatus ==
                                      "GeofenceStatus.enter") {
                                    geofenceStatus = "IN";
                                  } else {
                                    geofenceStatus = "OUT";
                                  }
                                });
                              });
                              User.flag = false;
                            } else {
                              EasyPolyGeofencing.stopGeofenceService();
                              geofenceStatusStream!.cancel();
                            }

                            if (User.lat != 0) {
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("student")
                                  .where('id', isEqualTo: User.studentId)
                                  .get();

                              DocumentSnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection("student")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .get();

                              try {
                                String checkIn = snap2['checkIn'];
                                setState(() {
                                  checkOut = DateFormat('hh:mm a')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("student")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'date': Timestamp.now(),
                                  'checkIn': checkIn,
                                  'checkOut': DateFormat('hh:mm a')
                                      .format(DateTime.now()),
                                  'sec': User.sec.toString(),
                                  'min': User.min.toString(),
                                  'hr': User.hr.toString(),
                                  'att': User.att,
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat('hh:mm a')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("student")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'date': Timestamp.now(),
                                  'checkIn': DateFormat('hh:mm a')
                                      .format(DateTime.now()),
                                  'checkOut': "--/--",
                                  'sec': User.sec.toString(),
                                  'min': User.min.toString(),
                                  'hr': User.hr.toString(),
                                  'att': User.att,
                                });
                              }

                              key.currentState!.reset();
                            } else {
                              Timer(const Duration(seconds: 3), () async {
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("student")
                                    .where('id', isEqualTo: User.studentId)
                                    .get();

                                DocumentSnapshot snap2 = await FirebaseFirestore
                                    .instance
                                    .collection("student")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .get();

                                try {
                                  String checkIn = snap2['checkIn'];
                                  setState(() {
                                    checkOut = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("student")
                                      .doc(snap.docs[0].id)
                                      .collection("Record")
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .update({
                                    'date': Timestamp.now(),
                                    'checkIn': checkIn,
                                    'checkOut': DateFormat('hh:mm a')
                                        .format(DateTime.now()),
                                    'sec': User.sec.toString(),
                                    'min': User.min.toString(),
                                    'hr': User.hr.toString(),
                                    'att': User.att,
                                  });
                                } catch (e) {
                                  setState(() {
                                    checkIn = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("student")
                                      .doc(snap.docs[0].id)
                                      .collection("Record")
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .set({
                                    'date': Timestamp.now(),
                                    'checkIn': DateFormat('hh:mm a')
                                        .format(DateTime.now()),
                                    'checkOut': "--/--",
                                    'sec': User.sec.toString(),
                                    'min': User.min.toString(),
                                    'hr': User.hr.toString(),
                                    'att': User.att,
                                  });
                                }
                                key.currentState!.reset();
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 32),
                  child: Text(
                    "You have completed this day!",
                    style: TextStyle(
                      fontFamily: "BebasNeue-Regular",
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
          location != " "
              ? Text(
                  "Status: $geofenceStatus\nTime: ${User.count} sec",
                  style: TextStyle(
                    fontFamily: "BebasNeue-Bold",
                    fontSize: screenWidth / 24,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    ));
  }
}
