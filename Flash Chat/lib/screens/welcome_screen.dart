import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/rounded_button.dart';
import 'package:flutterchat/screens/login_screen.dart';
import 'package:flutterchat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  void initialise() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return MainScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color:  Colors.lightBlueAccent,
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: animation.value,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 25,178,238),
                  Color.fromARGB(255, 21,236,229)
              ],),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: SizedBox(
                          height: 60,
                          child: Image.asset('images/logo.png'),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/9,
                            fontWeight: FontWeight.w900,
                            color: Colors.black26),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText('Flash Chat',
                                textStyle: GoogleFonts.alexandria(color: Colors.black87),
                                speed: const Duration(milliseconds: 200)),
                          ],
                          isRepeatingAnimation: true,
                          totalRepeatCount: 10,
                          pause: const Duration(seconds: 1),
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  RoundedButton(
                      text: 'Log In',
                      onPress: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      bgColor: Colors.blueAccent,),
                  RoundedButton(
                      text: "Register",
                      onPress: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      bgColor: Colors.grey,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
