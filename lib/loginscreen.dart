import 'package:attendance/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardService.isVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    const urlImage =
        'https://cdn.discordapp.com/attachments/968498876111810603/1011036768008687746/Thesis-amico.png';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              isKeyboardVisible
                  ? SizedBox(height: screenHeight / 20)
                  : Container(
                      margin: EdgeInsets.only(
                        top: screenHeight / 30,
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        urlImage,
                        height: screenWidth / 1.45,
                        width: screenWidth / 1.45,
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: screenHeight / 30,
                  bottom: screenHeight / 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("WELCOME!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primary,
                          fontSize: screenWidth / 16,
                          fontFamily: "BebasNeue-Regular",
                        )),
                    Text("Please login to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: screenWidth / 24,
                          fontFamily: "BebasNeue-Regular",
                        )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldTitle("Student ID"),
                    customField("Enter your student ID", idController, false),
                    fieldTitle("Password"),
                    customField("Enter your password", passController, true),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String id = idController.text.trim();
                        String password = passController.text.trim();

                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Student ID is still empty!"),
                          ));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Password is still empty!"),
                          ));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("student")
                              .where('id', isEqualTo: id)
                              .get();

                          try {
                            if (password == snap.docs[0]['password']) {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();

                              sharedPreferences
                                  .setString('StudentID', id)
                                  .then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Password is not correct!"),
                              ));
                            }
                          } catch (e) {
                            String error = " ";
                            if (kDebugMode) {
                              print(e.toString());
                            }
                            if (e.toString() ==
                                "RangeError (index): Invalid value: Valid value range is empty: 0") {
                              setState(() {
                                error = "Student ID does not exist!";
                              });
                            } else {
                              setState(() {
                                error = "Error occurred!";
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(error),
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 40),
                        decoration: const BoxDecoration(
                          color: Color(0xffeef444c),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: "BebasNeue-Bold",
                              fontSize: screenWidth / 26,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url =
                            'https://cdn.discordapp.com/attachments/968498876111810603/1011035371351592971/kids_wearing_masks_at_school-rafiki.png';

                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 40),
                        decoration: const BoxDecoration(
                          color: Color(0xffeef444c),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                              fontFamily: "BebasNeue-Bold",
                              fontSize: screenWidth / 26,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Color(0xffe1b2327),
          fontSize: screenWidth / 24,
          fontFamily: "BebasNeue-Regular",
        ),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: Color(0xffeef444c),
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
