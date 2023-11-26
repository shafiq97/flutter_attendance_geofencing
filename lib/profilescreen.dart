import 'dart:io';
import 'package:attendance/editscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:attendance/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String birth = "Date of birth";

  late SharedPreferences sharedPreferences;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ScholarshipNameController = TextEditingController();
  TextEditingController MobileNumberController = TextEditingController();
  TextEditingController EmailIdController = TextEditingController();
  TextEditingController GenderController = TextEditingController();
  TextEditingController ReligionController = TextEditingController();
  TextEditingController CasteController = TextEditingController();
  TextEditingController CategoryController = TextEditingController();
  TextEditingController InstituteNameController = TextEditingController();
  TextEditingController IncomeController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${User.studentId.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        User.profilePicLink = value;
      });
      await FirebaseFirestore.instance
          .collection("student")
          .doc(User.id)
          .update({
        'profilePic': value,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight / 4.25,
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
                ),
                Positioned(
                  top: 80,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: screenWidth / 6,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: screenWidth / 15,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 50),
                      height: 90,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primary,
                      ),
                      child: Center(
                        child: User.profilePicLink == " "
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 60,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(User.profilePicLink),
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 165,
                  right: 0,
                  bottom: 80,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${User.firstName} ${User.lastName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "BebasNeue-Bold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 165,
                  right: 0,
                  bottom: 60,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Student Id: ${User.studentId}",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "BebasNeue-Bold",
                          fontSize: screenWidth / 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 165,
                  right: 0,
                  bottom: 140,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "BebasNeue-Bold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              margin:
                  const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
              elevation: 0.0,
              color: const Color(0x00000000),
              child: FlipCard(
                front: Container(
                  margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                              "No. of days present",
                              style: TextStyle(
                                fontFamily: "BebasNeue-Regular",
                                fontSize: screenWidth / 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            "90/180",
                            style: TextStyle(
                              fontFamily: "BebasNeue-Bold",
                              fontSize: screenWidth / 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                back: Container(
                  margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                              "Present Progress",
                              style: TextStyle(
                                fontFamily: "BebasNeue-Regular",
                                fontSize: screenWidth / 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            "50%",
                            style: TextStyle(
                              fontFamily: "BebasNeue-Bold",
                              fontSize: screenWidth / 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 12, left: 12, right: 12, bottom: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black26,
                            width: 1,
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 4, left: 12, right: 12, bottom: 4),
                      height: screenWidth / 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth / 6,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black54,
                              size: screenWidth / 15,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "News and Notifications",
                                  style: TextStyle(
                                    fontFamily: "BebasNeue-Regular",
                                    fontSize: screenWidth / 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black26,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                        top: 4, left: 12, right: 12, bottom: 4),
                    height: screenWidth / 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth / 6,
                          child: Icon(
                            Icons.question_answer_rounded,
                            color: Colors.black54,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Query",
                                style: TextStyle(
                                  fontFamily: "BebasNeue-Regular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black26,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                        top: 4, left: 12, right: 12, bottom: 4),
                    height: screenWidth / 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth / 6,
                          child: Icon(
                            Icons.dark_mode,
                            color: Colors.black54,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  fontFamily: "BebasNeue-Regular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black26,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                        top: 4, left: 12, right: 12, bottom: 4),
                    height: screenWidth / 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth / 6,
                          child: Icon(
                            Icons.password,
                            color: Colors.black54,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontFamily: "BebasNeue-Regular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection("student")
                          .doc(User.id)
                          .update({
                        'lo': false,
                      }).then((value) {
                        setState(() {
                          User.lo = false;
                        });
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 4, left: 12, right: 12, bottom: 4),
                      height: screenWidth / 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth / 6,
                            child: Icon(
                              Icons.logout,
                              color: Colors.black54,
                              size: screenWidth / 15,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    fontFamily: "BebasNeue-Regular",
                                    fontSize: screenWidth / 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
