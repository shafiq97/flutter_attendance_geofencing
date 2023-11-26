import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/user.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: screenHeight / 1.09,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("student")
                              .doc(User.id)
                              .collection("Record")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final snap = snapshot.data!.docs;
                              User.length = snap.length;
                              return ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 150, left: 10, right: 10),
                                itemCount: snap.length,
                                itemBuilder: (context, index) {
                                  return DateFormat('MMMM').format(
                                              snap[index]['date'].toDate()) ==
                                          _month
                                      ? Card(
                                          margin: const EdgeInsets.only(
                                              top: 0,
                                              left: 4,
                                              right: 4,
                                              bottom: 12),
                                          elevation: 0.0,
                                          color: const Color(0x00000000),
                                          child: FlipCard(
                                            direction: FlipDirection.HORIZONTAL,
                                            speed: 1000,
                                            onFlipDone: (status) {
                                              if (kDebugMode) {
                                                print(status);
                                              }
                                            },
                                            front: Container(
                                              height: screenWidth / 5,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 5,
                                                    offset: Offset(2, 2),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          DateFormat('EE\ndd')
                                                              .format(snap[
                                                                          index]
                                                                      ['date']
                                                                  .toDate()),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Bold",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Check In",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Regular",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          snap[index]
                                                              ['checkIn'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Bold",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Check Out",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Regular",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          snap[index]
                                                              ['checkOut'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Bold",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            back: Container(
                                              height: screenWidth / 5,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 5,
                                                    offset: Offset(2, 2),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          snap[index]['att'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Bold",
                                                            fontSize:
                                                                screenWidth /
                                                                    20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Time",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Regular",
                                                            fontSize:
                                                                screenWidth /
                                                                    20,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          snap[index]['hr'] +
                                                              " hr " +
                                                              snap[index]
                                                                  ['min'] +
                                                              " min " +
                                                              snap[index]
                                                                  ['sec'] +
                                                              " sec",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "BebasNeue-Bold",
                                                            fontSize:
                                                                screenWidth /
                                                                    25,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: screenHeight / 8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primary,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      margin: const EdgeInsets.only(bottom: 48),
                      child: Text(
                        "Attendance",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "BebasNeue-Bold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 30,
                    right: 30,
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year + 1, 0),
                        );
                        if (month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: Container(
                        height: screenHeight / 16,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        margin: const EdgeInsets.only(bottom: 48),
                        child: Text(
                          _month,
                          style: TextStyle(
                            color: primary,
                            fontFamily: "BebasNeue-Bold",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
