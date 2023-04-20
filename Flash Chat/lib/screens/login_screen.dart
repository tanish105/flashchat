import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/screens/main_screen.dart';
import 'package:flutterchat/utils/constants.dart';
import '../utils/rounded_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 25,178,238),
              Color.fromARGB(255, 21,236,229),
            ],),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2,color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: "Enter Email",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2,color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: "Enter Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Container(
                child: _isLoading?Center(
                    child:  LoadingAnimationWidget.discreteCircle(
                      color: Colors.blueAccent,
                      secondRingColor: Colors.white,
                      thirdRingColor: Colors.blueAccent,
                      size: 30,
                    )):
                RoundedButton(

                    text: 'Log In',
                    onPress: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, MainScreen.id);
                        }
                      } catch (e) {
                        print(e);
                        if(e.toString()=="LateInitializationError: Field 'email' has not been initialized." || e.toString()=="[firebase_auth/invalid-email] The email address is badly formatted."){
                          showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                content: Container(
                                  child: Text("Enter valid Email!"),
                                ),
                              );
                            },
                          );
                        }
                        else if(e.toString()=="[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
                          showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                content: Container(
                                  child: Text("No Such User Found!!"),
                                ),
                              );
                            },
                          );
                        }
                        else if(e.toString()=="[firebase_auth/weak-password] Password should be at least 6 characters" || e.toString()=="[firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
                          showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                content: Container(
                                  child: Text("Invalid Password"),
                                ),
                              );
                            },
                          );
                        }


                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    bgColor: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
