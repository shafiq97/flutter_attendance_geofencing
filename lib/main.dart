import 'package:attendance/services/location_service.dart';
import 'package:attendance/mainlogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance/homescreen.dart';
import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = const Color(0xffeef444c);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: primary,
          onSecondary: Colors.white,
        ),
        primaryColor: const Color(0xffeef444c),
      ),
      home: const AuthCheck(),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _startLocationService();
    _getlatlong();
  }

  void _getlatlong() async {
    LocationService().getLongitude().then((value) {
      setState(() {
        User.long = value!;
      });

      LocationService().getLatitude().then((value) {
        setState(() {
          User.lat = value!;
        });
      });
    });
  }

  void _startLocationService() async {
    LocationService().initialize();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString('StudentID') != null) {
        setState(() {
          User.studentId = sharedPreferences.getString('StudentID')!;
          if (User.lo == false) {
            userAvailable = false;
            User.lo = true;
            User.id = " ";
            User.studentId = " ";
            User.canEdit = true;
            User.firstName = " ";
            User.lastName = " ";
            User.birthDate = " ";
            User.address = " ";
            User.profilePicLink = " ";
            User.ScholarshipName = " ";
            User.MobileNumber = " ";
            User.EmailId = " ";
            User.Gender = " ";
            User.Religion = " ";
            User.Caste = " ";
            User.Category = " ";
            User.InstituteName = " ";
            User.Income = " ";
          } else {
            userAvailable = true;
          }
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const HomeScreen() : const MainLogin();
  }
}
