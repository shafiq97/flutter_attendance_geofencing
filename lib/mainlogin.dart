import 'package:attendance/teacherlogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginscreen.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({Key? key}) : super(key: key);

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
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
              Container(
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
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
                            "STUDENT LOGIN",
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TeacherLogin(),
                          ),
                        );
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
                            "TEACHER LOGIN",
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
}
