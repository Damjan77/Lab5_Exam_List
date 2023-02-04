import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab3_exams_193222/screens/home_screen.dart';
import 'package:lab3_exams_193222/screens/signin_screen.dart';
import 'package:lab3_exams_193222/screens/signup_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lab App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: SignInScreen.id,
        routes: {
          HomeScreen.id:(context) => HomeScreen(),
          SignInScreen.id:(context) => SignInScreen(),
          SignUpScreen.id:(context) => SignUpScreen(),
        }
    );
  }
}
