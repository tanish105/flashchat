import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/screens/main_screen.dart';
import 'package:flutterchat/screens/welcome_screen.dart';
import 'package:flutterchat/screens/login_screen.dart';
import 'package:flutterchat/screens/registration_screen.dart';
import 'package:flutterchat/screens/chat_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

FirebaseAuth _auth = FirebaseAuth.instance;

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        MainScreen.id : (context)=>MainScreen(),
        LoginScreen.id: (context)=> LoginScreen(),
        RegistrationScreen.id: (context)=> const RegistrationScreen(),
        WelcomeScreen.id: (context)=>WelcomeScreen(),
      },
    );
  }
}
