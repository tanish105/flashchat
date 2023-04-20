import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/rounded_button.dart';
import 'main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  late String email;
  late String password;
  late String userName;
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
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2,color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: "Enter Name",
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
                    text: "Register",
                    onPress: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await Firebase.initializeApp();
                      try{
                        if(userName==null){
                          throw("Enter valid username");
                        }
                        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        await _database.collection("users").doc(_auth.currentUser?.uid).set(
                            {
                              'Name': userName,
                              'Email' : email,
                              'uid' : _auth.currentUser!.uid,
                              'Date of Creation' : FieldValue.serverTimestamp(),
                            });
                        if(newUser!=null){
                          Navigator.pushNamed(context, MainScreen.id);
                        }
                      }catch(e){
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
                          else if(e.toString()=="[firebase_auth/weak-password] Password should be at least 6 characters"){
                            showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  content: Container(
                                    child: Text("Password Should be greater than 6 character"),
                                  ),
                                );
                              },
                            );
                          }
                          else if(e.toString()=="LateInitializationError: Field 'userName' has not been initialized."){
                            showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  content: Container(
                                    child: Text("Enter valid username"),
                                  ),
                                );
                              },
                            );
                          }
                          else{
                            print(e);
                            showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  content: Container(
                                    child: Text("Error!! Check again!"),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
