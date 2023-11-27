import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'model/user.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    super.initState();
    getId().then((value) {
      _getCredentials();
      _getProfilePic();
    });
  }

  void _getCredentials() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("student")
          .doc(User.id)
          .get();
      setState(() {
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
    } catch (e) {
      return;
    }
  }

  void _getProfilePic() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("student")
        .doc(User.id)
        .get();
    setState(() {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 10, right: 10, bottom: 10, top: 240),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  User.canEdit
                      ? textField(
                          "First Name", "First name", firstNameController)
                      : field("First Name", User.firstName),
                  User.canEdit
                      ? textField("Last Name", "Last name", lastNameController)
                      : field("Last Name", User.lastName),
                  User.canEdit
                      ? GestureDetector(
                          onTap: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: primary,
                                        secondary: primary,
                                        onSecondary: Colors.white,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary: primary,
                                        ),
                                      ),
                                      textTheme: const TextTheme(
                                        headline4: TextStyle(
                                          fontFamily: "BebasNeue-Bold",
                                        ),
                                        overline: TextStyle(
                                          fontFamily: "BebasNeue-Bold",
                                        ),
                                        button: TextStyle(
                                          fontFamily: "BebasNeue-Bold",
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                }).then((value) {
                              setState(() {
                                birth = DateFormat("MM/dd/yyyy").format(value!);
                              });
                            });
                          },
                          child: field("Date of Birth", birth),
                        )
                      : field("Date of Birth", User.birthDate),
                  User.canEdit
                      ? textField("Gender", "Gender", GenderController)
                      : field("Gender", User.Gender),
                  User.canEdit
                      ? textField("Address", "Address", addressController)
                      : field("Address", User.address),
                  User.canEdit
                      ? textField("Mobile Number", "Mobile Number",
                          MobileNumberController)
                      : field("Mobile Number", User.MobileNumber),
                  User.canEdit
                      ? textField("Email Id", "Email Id", EmailIdController)
                      : field("Email Id", User.EmailId),
                  User.canEdit
                      ? textField("Institute Name", "Institute Name",
                          InstituteNameController)
                      : field("Institute Name", User.InstituteName),
                  User.canEdit
                      ? textField("Religion", "Religion", ReligionController)
                      : field("Religion", User.Religion),
                  User.canEdit
                      ? textField("Caste", "Caste", CasteController)
                      : field("Caste", User.Caste),
                  User.canEdit
                      ? textField("Category", "Category", CategoryController)
                      : field("Category", User.Category),
                  User.canEdit
                      ? textField("Income", "Income", IncomeController)
                      : field("Income", User.Income),
                  User.canEdit
                      ? textField("Scholarship Name", "Scholarship Name",
                          ScholarshipNameController)
                      : field("Scholarship Name", User.ScholarshipName),
                  User.canEdit
                      ? GestureDetector(
                          onTap: () async {
                            String firstName = firstNameController.text;
                            String lastName = lastNameController.text;
                            String birthDate = birth;
                            String Gender = GenderController.text;
                            String address = addressController.text;
                            String MobileNumber = MobileNumberController.text;
                            String EmailId = EmailIdController.text;
                            String InstituteName = InstituteNameController.text;
                            String Religion = ReligionController.text;
                            String Caste = CasteController.text;
                            String Category = CategoryController.text;
                            String Income = IncomeController.text;
                            String ScholarshipName =
                                ScholarshipNameController.text;

                            if (User.canEdit) {
                              if (firstName.isEmpty) {
                                showSnackBar("Please enter your first name!");
                              } else if (lastName.isEmpty) {
                                showSnackBar("Please enter your last name!");
                              } else if (birthDate.isEmpty) {
                                showSnackBar("Please enter your birth date!");
                              } else if (Gender.isEmpty) {
                                showSnackBar("Please enter your Gender!");
                              } else if (address.isEmpty) {
                                showSnackBar("Please enter your address!");
                              } else if (MobileNumber.isEmpty) {
                                showSnackBar(
                                    "Please enter your Mobile Number!");
                              } else if (EmailId.isEmpty) {
                                showSnackBar("Please enter your Email Id!");
                              } else if (InstituteName.isEmpty) {
                                showSnackBar(
                                    "Please enter your Institute Name!");
                              } else if (Religion.isEmpty) {
                                showSnackBar("Please enter your Religion!");
                              } else if (Caste.isEmpty) {
                                showSnackBar("Please enter your Caste!");
                              } else if (Category.isEmpty) {
                                showSnackBar("Please enter your Category!");
                              } else if (Income.isEmpty) {
                                showSnackBar("Please enter your Income!");
                              } else if (ScholarshipName.isEmpty) {
                                showSnackBar(
                                    "Please enter your scholarship name!");
                              } else {
                                await FirebaseFirestore.instance
                                    .collection("student")
                                    .doc(User.id)
                                    .update({
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'birthDate': birthDate,
                                  'Gender': Gender,
                                  'address': address,
                                  'MobileNumber': MobileNumber,
                                  'EmailId': EmailId,
                                  'InstituteName': InstituteName,
                                  'Religion': Religion,
                                  'Caste': Caste,
                                  'Category': Category,
                                  'Income': Income,
                                  'ScholarshipName': ScholarshipName,
                                  'canEdit': false,
                                }).then((value) {
                                  setState(() {
                                    User.canEdit = false;
                                    User.firstName = firstName;
                                    User.lastName = lastName;
                                    User.birthDate = birthDate;
                                    User.Gender = Gender;
                                    User.address = address;
                                    User.MobileNumber = MobileNumber;
                                    User.EmailId = EmailId;
                                    User.InstituteName = InstituteName;
                                    User.Religion = Religion;
                                    User.Caste = Caste;
                                    User.Category = Category;
                                    User.Income = Income;
                                    User.ScholarshipName = ScholarshipName;
                                  });
                                });
                              }
                            } else {
                              showSnackBar(
                                  "You can't edit anymore, please contact support team.");
                            }
                          },
                          child: Container(
                            height: kToolbarHeight,
                            width: screenWidth,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: primary,
                            ),
                            child: const Center(
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "BebasNeue-Bold",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection("student")
                          .doc(User.id)
                          .update({
                        'canEdit': true,
                      }).then((value) {
                        setState(() {
                          User.lo = false;
                        });
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditScreen()),
                      );
                    },
                    child: User.canEdit
                        ? const SizedBox()
                        : Container(
                            height: kToolbarHeight,
                            width: screenWidth,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: primary,
                            ),
                            child: const Center(
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "BebasNeue-Bold",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight / 3.5,
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
            child: GestureDetector(
              onTap: () {
                pickUploadProfilePic();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 60, bottom: 50),
                height: 120,
                width: 120,
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
                          size: 80,
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
            top: 50,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                width: screenWidth / 6,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: screenWidth / 15,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight / 80,
            left: screenHeight / 10,
            right: screenHeight / 10,
            bottom: screenHeight / 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Student Id: ${User.studentId}",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "BebasNeue-Bold",
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight / 60,
            left: screenHeight / 10,
            right: screenHeight / 10,
            bottom: screenHeight / 1.1,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "BebasNeue-Bold",
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget field(String title, String text) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "BebasNeue-Bold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black26,
                width: 1,
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: "BebasNeue-Bold",
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(
      String title, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "BebasNeue-Bold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "BebasNeue-Bold",
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}
