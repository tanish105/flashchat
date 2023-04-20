import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutterchat/group/create_group.dart';
import 'package:flutterchat/screens/search_screen.dart';
import 'package:flutterchat/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/chat_tile.dart';
import '../utils/group_tile.dart';

class MainScreen extends StatefulWidget {
  static String id = 'MainScreen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Map<String, dynamic>? currUserMap;

  bool isEmpty = true;

  final TextEditingController _controller = TextEditingController();
  late List<Widget> chats = [];

  late Size size = MediaQuery.of(context).size;

  final TextEditingController _search = TextEditingController();

  late String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String,dynamic>> getUser() async{
    Map<String, dynamic> user = {};
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    dynamic doc =  await firestore
        .collection('users')
        .doc(uid)
        .get().then((value) => {
          user = value.data()!
    });

    return user;
  }


  @override
  void dispose() {
    _controller.dispose();
    _search.dispose();
    super.dispose();
  }

  String chatId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override

  Widget build(BuildContext context){
    return FutureBuilder<Map<String, dynamic>>(
        future: getUser(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.hasData){
            currUserMap = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 25,178,238),
                        Color.fromARGB(255, 21,236,229)
                      ],),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        } else {
                          throw ("Invalid Request");
                        }
                      }),
                ],
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    children: [
                      Text("Chat",style: GoogleFonts.alexandria(),),
                    ],
                  ),
                ),
                backgroundColor: Colors.lightBlueAccent,
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: size.height / 30,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('userUI').doc(uid).collection('chats').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: Colors.blueAccent,
                            secondRingColor: Colors.white,
                            thirdRingColor: Colors.blueAccent,
                            size: 30,
                          ),
                        );
                      }
                      var chats = snapshot.data?.docs;
                      List<Widget> friends = [];

                      for (var chat in chats!) {
                        if(chat.data()['Group Name']==null){
                          friends.add(
                            ChatTile(receiverUserMap: chat.data(), senderUserMap: currUserMap, chatId: chatId(chat['uid'],uid), controller: _controller, add: (){},),
                          );
                        }
                        else{
                          friends.add(
                              GroupTile(senderUserMap: currUserMap, groupName: chat.data()['Group Name'],controller: _controller,)
                          );
                        }
                      }
                      return Expanded(
                        child: ListView(
                          children: friends,
                        ),
                      );
                    },
                  ),
                ],
              ),
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                backgroundColor: Colors.blueAccent,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.person, color: Colors.white,),
                    label: "Add User",
                    backgroundColor: Colors.blueAccent,
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SearchScreen(uid, currUserMap!);
                          });
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.group, color: Colors.white,),
                    label: "Create Group",
                    backgroundColor: Colors.blueAccent,
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CreateGroup(currUserMap!);
                          });
                    }
                  )
                ],
              )
            );
          }
          else{
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color:  Colors.blueAccent,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          }
        }
    );
  }
}
